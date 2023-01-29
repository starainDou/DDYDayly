//
//  DDVerifyVC.swift
//  elevator
//
//  Created by ddy on 2023/1/28.
//

import UIKit
import Then

class DDVerifyVC: UIViewController {
    
    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Verify"
    }
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = 98
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDVerifyCell.self)
    }
    
    private lazy var dataArray: [DDVerifyModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, tableView)
        setViewConstraints()
        setupClosure()
        loadData()
    }
    
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
    }
    
    // MARK:- 回调响应
    private func setupClosure() {
        navigationBar.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func clickAction(_ item: DDVerifyModel) {
        let vc = DDLabelVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadData() {
        let model = DDVerifyModel()
        model.title = "HWW014600000274"
        model.state = "Not Ready"
        model.time = "09/11/2021 11:17:00"
        dataArray = [model]
        tableView.reloadData()
    }
}

extension DDVerifyVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDVerifyCell.self, for: indexPath).then {
            $0.loadData(item: dataArray[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        clickAction(dataArray[indexPath.row])
    }
}
