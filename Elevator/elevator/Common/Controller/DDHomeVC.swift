//
//  DDHomeVC.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import UIKit
import SwiftyJSON

class DDHomeVC: UIViewController {
    
    private lazy var headerView: DDHomeHeaderView = DDHomeHeaderView()
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = 85
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDHomeCell.self)
    }
    
    private lazy var dataArray: [DDHomeModel] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(headerView, tableView)
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.width * 0.64)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func clickAction(_ item: DDHomeModel) {
        let vc = DDQRCodeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func loadData() {
        headerView.nameLabel.text = "Welcome," + (DDShared.shared.user?.username ?? "-")
        headerView.roleLabel.text = DDShared.shared.user?.rolename ?? "-"
        dataArray = DDShared.shared.homeItems
        tableView.reloadData()
    }
    
    private func logout() {
        
    }
}


extension DDHomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDHomeCell.self, for: indexPath).then {
            $0.loadData(item: dataArray[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        clickAction(dataArray[indexPath.row])
    }
}
