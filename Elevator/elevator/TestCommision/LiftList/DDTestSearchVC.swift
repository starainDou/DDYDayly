//
//  DDTestSearchVC.swift
//  elevator
//
//  Created by ddy on 2023/2/6.
//

import UIKit
import SwiftyJSON
import ProgressHUD

class DDTestSearchVC: UIViewController {
    
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
        $0.ddy_register(cellClass: DDTestCell.self)
        $0.keyboardDismissMode = .onDrag
    }
    
    private lazy var dataArray: [JSON] = []
    
    private lazy var tagIndex: Int = 0
    
    private var sensorJson: JSON?
    
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
    
    func loadData(_ array: [JSON], tag: Int, sensor: JSON?) {
        dataArray = array
        tagIndex = tag
        sensorJson = sensor
        tableView.reloadData()
    }
}

extension DDTestSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ddy_dequeueReusableCell(DDTestCell.self, for: indexPath)
        cell.loadData(json: dataArray[indexPath.row], tag: tagIndex)
        cell.detailBlock = { [weak self] in
            let vc = DDMainteDetailVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        cell.downloadBlock = { [weak self] in
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tagIndex == 0 {
            ProgressHUD.showFailed("Sorry, you don't have permission", interaction: false, delay: 3)
        } else if tagIndex == 4 {
            let vc = DDCommisionVC()
            vc.load(json: dataArray[indexPath.row], tag: tagIndex)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
