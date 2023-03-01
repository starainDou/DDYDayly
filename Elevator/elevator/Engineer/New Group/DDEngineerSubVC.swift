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
    }
    
    private(set) lazy var dataArray: [JSON] = []
    
    var tagIndex: Int = 0;
    
    var page: Int = 1
    
    var alarmType: Int = 0
    
    var searchWord: String = "" {
        didSet {
            page = 1
            loadData()
        }
    }
    
    var sortType: Int = 0 {
        didSet {
            page = 1
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#01F5FF")
        view.addSubviews(tableView)
        setViewConstraints()
        setupRefresh()
        loadData()
    }
    
    private func setViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        guard let userId = DDShared.shared.json?["user"]["id"].stringValue else { return }
        DDPost(target: .getAlarmsOfLift(userid: userId, page: "\(page)", limit: "20", alarmType: "\(alarmType)", severityType: "\(tagIndex)", value: searchWord, sortType: "\(sortType)", dateRange: ["",""]), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            if let `self` = self {
                if (self.page == 1) {
                    self.dataArray = []
                }
                self.dataArray += JSON(result)["data"]["rows"].arrayValue
                if self.dataArray.count < JSON(result)["data"]["total"].intValue {
                    self.page += 1
                }
            }
            self?.tableView.reloadData()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
        }, failure: { [weak self] code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
        })
    }
    
    private func setupRefresh() {
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.page = 1
            self?.loadData()
        })
        // 上拉加载更多
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
            self?.loadData()
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
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DDEngineerSubVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
