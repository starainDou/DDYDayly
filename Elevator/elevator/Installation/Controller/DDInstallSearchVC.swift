//
//  DDInstallSearchVC.swift
//  elevator
//
//  Created by ddy on 2023/2/6.
//

import UIKit

class DDInstallSearchVC: UIViewController {
    
    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Search"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }

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
    
    private lazy var dataArray: [DDLiftModel] = []
    
    private lazy var tagIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(navigationBar, tableView)
        setViewConstraints()
    }
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func loadData(_ array: [DDLiftModel], tag: Int) {
        dataArray = array
        tagIndex = tag
        tableView.reloadData()
    }
}

extension DDInstallSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDInstallationCell.self, for: indexPath).then {
            $0.loadData(item: dataArray[indexPath.row], tag: tagIndex)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DDVerifyDetailVC()
        vc.liftModel = dataArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
