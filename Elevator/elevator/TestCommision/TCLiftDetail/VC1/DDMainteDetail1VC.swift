//
//  DDMainteDetail1VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView
import SwiftyJSON
import ProgressHUD
import EmptyDataSet_Swift

class DDMainteDetail1VC: UIViewController {
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.estimatedRowHeight = 220
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDMainteDetail1Cell.self)
        $0.emptyDataSetSource = self
        $0.emptyDataSetDelegate = self
    }
    
    private lazy var dataArray: [JSON] = []
    
    var liftBaseJson: JSON = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(tableView)
        setViewConstraints()
        loadData()
    }
    
    private func setViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        let liftNumber = liftBaseJson["liftnumber"].stringValue
        DDGet(target: .getDetailsOfLiftAlarm(liftNumber: liftNumber), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            self?.dataArray = JSON(result)["data"].arrayValue
            self?.tableView.reloadData()
        }, failure: { [weak self] code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
    }
}

extension DDMainteDetail1VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDMainteDetail1Cell.self, for: indexPath).then {
            $0.loadData(dataArray[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension DDMainteDetail1VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}


extension DDMainteDetail1VC: EmptyDataSetSource, EmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "Icon218")
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        loadData()
    }
}
