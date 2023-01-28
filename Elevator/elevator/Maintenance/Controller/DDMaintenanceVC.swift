//
//  DDMaintenanceVC.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import UIKit
import SwiftyJSON

class DDMaintenanceVC: UIViewController {
    
    private lazy var topImageView: UIImageView = UIImageView(image: UIImage(named: "BeiJing"))
    
    private lazy var avatarView: UIImageView = UIImageView(image: UIImage(named: "AvatarDefault"))
    
    private lazy var nameLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#FFFFFF")
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private lazy var roleLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#FFFFFF")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.ddy_register(cellClass: DDMaintenanceCell.self)
    }
    
    private lazy var dataArray: [DDMaintenanceModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(topImageView, avatarView, nameLabel, roleLabel, tableView)
        setViewConstraints()
        loadData()
    }
    
    private func setViewConstraints() {
        topImageView.snp.makeConstraints { make in
            
        }
        avatarView.snp.makeConstraints { make in
            
        }
        nameLabel.snp.makeConstraints { make in
            
        }
        roleLabel.snp.makeConstraints { make in
            
        }
        tableView.snp.makeConstraints { make in
            
        }
    }
    
    private func loadData() {
        dataArray = [DDMaintenanceModel(icon: "Elevator", title: "Lift"),
                     DDMaintenanceModel(icon: "History", title: "History"),
                     DDMaintenanceModel(icon: "FavouriteCyan", title: "Favourite"),
                     DDMaintenanceModel(icon: "Summary", title: "Summary of Lift Performances")]
        tableView.reloadData()
    }
    
    private func clickAction(_ item: DDMaintenanceModel) {
        
    }
}


extension DDMaintenanceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDMaintenanceCell.self, for: indexPath).then {
            $0.loadData(item: dataArray[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        clickAction(dataArray[indexPath.row])
    }
}
