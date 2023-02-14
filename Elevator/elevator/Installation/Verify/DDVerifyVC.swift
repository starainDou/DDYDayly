//
//  DDVerifyVC.swift
//  elevator
//
//  Created by ddy on 2023/1/28.
//

import UIKit
import Then
import ProgressHUD
import SwiftyJSON
import EmptyDataSet_Swift

class DDVerifyVC: UIViewController {
    
    var sensorJson: JSON?
    
    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Verify"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
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
        $0.emptyDataSetSource = self
        $0.emptyDataSetDelegate = self
    }
    
    private lazy var nextButton: UIButton = UIButton(type: .custom).then {
        $0.isHidden = true
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.setTitle("Next", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }
    
    private lazy var dataArray: [JSON] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, tableView, nextButton)
        setViewConstraints()
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
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(25)
            make.height.equalTo(40);
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        guard let json = sensorJson, let deviceId = json["deviceId"].string else { return } //  "HWW014600000274"
        ProgressHUD.show()
        DDGet(target: .getSensor(deviceId: deviceId), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            self?.dataArray = JSON(result)["data"].arrayValue
            self?.tableView.reloadData()
            self?.checkNext()
        }, failure: { code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
    }
    private func checkNext() {
        nextButton.isHidden = dataArray.count == 0
        nextButton.backgroundColor = UIColor(hex: "#AAAAAA")
        nextButton.isEnabled = false
        // guard dataArray.first?["status"].string == "1" else { return }
        nextButton.backgroundColor = UIColor(hex: "#168991")
        nextButton.isEnabled = true
    }
    @objc private func nextAction() {
        let vc = DDInstallationVC()
        vc.sensorJson = dataArray.first
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DDVerifyVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDVerifyCell.self, for: indexPath).then {
            $0.loadData(json: dataArray[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let json = dataArray[indexPath.row]
        //guard json["status"].stringValue == "1" else { return }
//        let vc = DDInstallationVC()
//        vc.sensorJson = dataArray[indexPath.row]
//        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DDVerifyVC: EmptyDataSetSource, EmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "Icon218")
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        loadData()
    }
}
