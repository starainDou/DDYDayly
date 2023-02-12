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
    
    private(set) lazy var dataArray: [DDLiftModel] = []
    
    var tagIndex: Int = 0;
    
    var page: Int = 1
    
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
//        DDGet(target: .getLiftsBystatus(status: "\(tagIndex)", page: "\(page)", limit: "20"), success: { [weak self] result, msg in
//            print("正确 \(result) \(msg ?? "NoMsg")")
//            ProgressHUD.dismiss()
//            if let `self` = self {
//                if (self.page == 1) {
//                    self.dataArray = []
//                }
//                self.dataArray += JSON(result)["data"]["rows"].arrayValue.map { DDLiftModel(liftsBystatus: $0) }
//                if self.dataArray.count < JSON(result)["data"]["total"].intValue {
//                    self.page += 1
//                }
//            }
//            self?.tableView.reloadData()
//            self?.tableView.mj_footer?.endRefreshing()
//            self?.tableView.mj_footer?.endRefreshing()
//        }, failure: { [weak self] code, msg in
//            print("错误 \(code) \(msg ?? "NoMsg")")
//            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
//            self?.tableView.mj_footer?.endRefreshing()
//            self?.tableView.mj_footer?.endRefreshing()
//        })
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
        return 10 // dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDEngineerCell.self, for: indexPath).then {
            //$0.loadData(item: dataArray[indexPath.row], tag: tagIndex)
            $0.loadData(item: DDLiftModel(liftsBystatus: JSON()), tag: 0)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let vc = DDVerifyDetailVC()
//        vc.liftModel = dataArray[indexPath.row]
//        navigationController?.pushViewController(vc, animated: true)
    }
}
