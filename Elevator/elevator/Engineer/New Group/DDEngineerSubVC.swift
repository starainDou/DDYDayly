//
//  DDEngineerSubVC.swift
//  elevator
//
//  Created by ddy on 2023/2/11.
//

import UIKit
import DDYSwiftyExtension
import JXSegmentedView
import ProgressHUD
import SwiftyJSON
import MJRefresh
import EmptyDataSet_Swift

class DDEngineerSubVC: UIViewController {

    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 170
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.showsVerticalScrollIndicator = false
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDEngineerCell.self)
        $0.keyboardDismissMode = .onDrag
        $0.emptyDataSetSource = self
        $0.emptyDataSetDelegate = self
    }
    
    private var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    private(set) lazy var dataArray: [JSON] = []
    
    var tagIndex: Int = 0; // 0:Alert,1:alarm,2:normal
    
    var page: Int = 1
    
    var alarmType: Int = 0 // 1:未处理的alarm,2:已处理的alarm(历史alarm),3:收藏的alarm
    
    var time:(start: String, end: String) = ("", "")
    
    var searchWord: String? {
        didSet {
            loadData(restart: true)
        }
    }
    
    var sortType: Int = 0 {
        didSet {
            loadData(restart: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#01F5FF")
        view.addSubviews(tableView)
        setViewConstraints()
        setupRefresh()
        loadData(restart: true)
    }
    
    deinit {
        listViewDidScrollCallback = nil
    }
    
    private func setViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadData(restart: Bool) {
        if restart {
            page = 1
        }
        guard let userId = DDShared.shared.json?["user"]["id"].stringValue else { return }
        ProgressHUD.show(interaction: false)
        let dateRange: [String]? = alarmType == 2 ? [time.start, time.end] : nil
        let tempType: String? = alarmType == 2 ? nil : "\(sortType)"
        DDPost(target: .getAlarmsOfLift(userid: userId, page: "\(page)", limit: "20", alarmType: "\(alarmType)", severityType: "\(tagIndex)", value: searchWord, sortType: tempType, dateRange: dateRange), success: { [weak self] result, msg in
            ProgressHUD.dismiss()
            if let `self` = self {
                if (self.page == 1) {
                    self.dataArray = []
                }
                self.dataArray += JSON(result)["data"].arrayValue
                if JSON(result)["data"].arrayValue.count >= 20 {
                    self.page += 1
                }
            }
            self?.tableView.reloadData()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
        }, failure: { [weak self] code, msg in
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
        })
    }
    
    private func setupRefresh() {
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.loadData(restart: true)
        })
        // 上拉加载更多
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
            self?.loadData(restart: false)
        })
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
    public func showDoubleTimeView() {
        DDDoubleDatePicker.show(in: view, date: time, sure: { [weak self] (start, end) in
            self?.time = (start, end)
            self?.loadData(restart: true)
        })
    }
}


extension DDEngineerSubVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDEngineerCell.self, for: indexPath).then {
            $0.loadData(dataArray[indexPath.row], tag: tagIndex)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DDAlertDetailVC()
        vc.baseJson = dataArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DDEngineerSubVC: JXPagingViewListViewDelegate, JXSegmentedListContainerViewListDelegate {
    func listScrollView() -> UIScrollView {
        return self.tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
    }
    
    func listView() -> UIView {
        return view
    }
}

extension DDEngineerSubVC: EmptyDataSetSource, EmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "Icon218")
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        loadData(restart: true)
    }
}
