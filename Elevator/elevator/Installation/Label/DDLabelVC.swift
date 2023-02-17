//
//  DDLabelVC.swift
//  elevator
//
//  Created by ddy on 2023/1/29.
//

import Foundation
import Then
import UIKit

class DDLabelVC: UIViewController {
    
    var selectBlock: ((String) -> Void)?
    
    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Label"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var flootLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
        $0.text = "Floot"
    }
    
    private lazy var tagLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
        $0.text = "Label"
    }
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.rowHeight = 47
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 6
        $0.ddy_zeroPadding()
        $0.ddy_register(cellClass: DDLabelCell.self)
    }
    
    private lazy var okButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("OK", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 6
        $0.addTarget(self, action: #selector(okAction), for: .touchUpInside)
    }
    
    private lazy var dataArray: [String] = []
    
    var selectIndex: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, flootLabel, tagLabel, tableView, okButton)
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        flootLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(80)
        }
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(80)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(navigationBar.snp.bottom).offset(48)
            make.bottom.equalTo(okButton.snp.top).offset(-30)
        }
        okButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(80)
            make.height.equalTo(40)
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func okAction() {
        if let index = selectIndex, index < dataArray.count {
            selectBlock?(dataArray[index])
        }
        navigationController?.popViewController(animated: true)
    }
    
    func loadData(_ array: [String], index: Int) {
        selectIndex = index
        dataArray = array
        tableView.reloadData()
    }
}

extension DDLabelVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDLabelCell.self, for: indexPath).then {
            $0.loadData(floor: "*\(indexPath.row)", label: dataArray[indexPath.row], isSelected: indexPath.row == selectIndex)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectIndex = indexPath.row
        tableView.reloadData()
    }
}
