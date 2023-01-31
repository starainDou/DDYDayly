//
//  DDCommisionVC.swift
//  elevator
//
//  Created by ddy on 2023/1/31.
//

import UIKit

class DDCommisionVC: UIViewController {

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Before Installation"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var headerView: DDCommisionHeader = DDCommisionHeader().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    private lazy var footerView: DDCommisionFooter = DDCommisionFooter().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    private lazy var submitButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#999999")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.setTitle("Submit", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, headerView, footerView, submitButton)
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(navigationBar.snp.bottom).offset(15)
            make.height.equalTo(160)
        }
        footerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.height.equalTo(220)
        }
        
        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(40)
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func submitAction() {
        
    }
}
