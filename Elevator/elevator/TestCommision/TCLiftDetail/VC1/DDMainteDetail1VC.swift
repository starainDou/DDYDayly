//
//  DDMainteDetail1VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView
import SwiftyJSON

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
    }
    
    private lazy var dataArray: [DDVerifyModel] = []
    
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
    
    private func clickAction(_ item: DDVerifyModel) {
        
    }
    
    func loadData() {
        let model = DDVerifyModel()
        model.title = "HWW014600000274"
        model.state = "Not Ready"
        model.time = "09/11/2021 11:17:00"
        dataArray = [model, model, model]
        tableView.reloadData()
    }

}

extension DDMainteDetail1VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDMainteDetail1Cell.self, for: indexPath).then {
            $0.test()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        clickAction(dataArray[indexPath.row])
    }
}

extension DDMainteDetail1VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
