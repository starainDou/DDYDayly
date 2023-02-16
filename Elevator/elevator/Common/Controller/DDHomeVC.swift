//
//  DDHomeVC.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import UIKit
import SwiftyJSON
import DDYSwiftyExtension
import ProgressHUD

class DDHomeVC: UIViewController {
    
    private lazy var headerView: DDHomeHeaderView = DDHomeHeaderView().then {
        $0.avatarView.ddy_longPress(self, action: #selector(logoutAction), gestureBlock: { gesture in
            gesture.minimumPressDuration = 3
        })
    }
    
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
    
    private lazy var logoutButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.setTitle("Logout", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
    }
    
    private lazy var dataArray: [DDHomeModel] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(headerView, tableView, logoutButton)
        setViewConstraints()
        loadData()
    }
    
    private func setViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.width * 0.64)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(logoutButton.snp.top).offset(-15)
        }
        logoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    public func loadData() {
        headerView.nameLabel.text = "Welcome," + (DDShared.shared.json?["user"]["username"].string ?? "-")
        headerView.roleLabel.text = DDShared.shared.json?["user"]["rolename"].string ?? "-"
        dataArray = DDShared.shared.homeItems
        tableView.reloadData()
    }
    
    @objc private func logoutAction() {
        let alert = UIAlertController(title: "Tip", message: "Are you sure to quit?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (action) in
            self?.logOut()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func logOut() {
        ProgressHUD.show()
        guard let id = DDShared.shared.json?["user"]["id"].stringValue else { return delayLogout() }
        perform(#selector(delayLogout), with: nil, afterDelay: 1)
        DDGet(target: .doApplogout(id: id), success: { [weak self] result, msg in
            self?.delayLogout()
        }, failure: { [weak self] code, msg in
            self?.delayLogout()
        })
    }
    
    @objc private func delayLogout() {
        ProgressHUD.dismiss()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delayLogout), object: nil)
        DDShared.shared.json = nil
        DDShared.shared.remove(for: DDShared.LogDataKey)
        DDShared.shared.event.logInOrOut.onNext(false)
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
        navigationController?.pushViewController(dataArray[indexPath.row].vc, animated: true)
    }
}
