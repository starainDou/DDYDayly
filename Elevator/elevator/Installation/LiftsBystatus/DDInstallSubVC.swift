//
//  DDInstallSubVC.swift
//  elevator
//
//  Created by ddy on 2023/2/6.
//

import UIKit
import DDYSwiftyExtension
import JXSegmentedView
import ProgressHUD
import SwiftyJSON
import MJRefresh
import EmptyDataSet_Swift

class DDInstallSubVC: UIViewController {

    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 170
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDInstallationCell.self)
        $0.keyboardDismissMode = .onDrag
    }
    
    private(set) lazy var dataArray: [JSON] = []
    
    var sensorJson: JSON?
    
    var tagIndex: Int = 0
    
    var page: Int = 1
    
    var searchWord: String? {
        didSet {
            guard oldValue != searchWord else { return }
            page = 1
            loadData()
        }
    }
    
    var isNeedLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(tableView)
        setViewConstraints()
        setupRefresh()
    }
    
    private func setViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func loadDataIfNeed() {
        if isNeedLoad {
            loadData()
            isNeedLoad = false
        }
    }
    
    private func loadData() {
        ProgressHUD.show(interaction: false)
        DDGet(target: .getLiftsBystatus(status: "\(tagIndex)", page: "\(page)", limit: "20", liftnumber: searchWord), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            if let `self` = self {
                if (self.page == 1) {
                    self.dataArray = []
                }
                let data = JSON(result)["data"]
                self.dataArray += data["rows"].arrayValue
                if self.dataArray.count < data["total"].intValue || data["rows"].arrayValue.count < 20 {
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


extension DDInstallSubVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDInstallationCell.self, for: indexPath).then {
            $0.loadData(json: dataArray[indexPath.row], tag: tagIndex)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DDVerifyDetailVC()
        vc.sensorJson = sensorJson
        vc.liftBaseJson = dataArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DDInstallSubVC: EmptyDataSetSource, EmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "Icon218")
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        loadData()
    }
}
