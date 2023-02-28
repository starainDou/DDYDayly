//
//  DDMainteDetail4TopView.swift
//  elevator
//
//  Created by ddy on 2023/2/26.
//

import UIKit

class DDMainteDetail4TopView: UIView {

    private lazy var titleLabel: UILabel = UILabel().then {
        $0.text = "Device reboot"
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    private lazy var softButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#FE5151")
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.setTitle("Soft Reboot", for: .normal)
        $0.setTitleColor(UIColor(hex:"#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private lazy var hardButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#FE5151")
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.setTitle("Hard Reboot", for: .normal)
        $0.setTitleColor(UIColor(hex:"#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }

    private lazy var wifiLabel: UILabel = UILabel().then {
        $0.text = "Device reboot"
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    private lazy var wifiButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#1ECAA1")
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.setTitle("Release Wifi-Access Button", for: .normal)
        $0.setTitleColor(UIColor(hex:"#FFFFFF"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubviews(titleLabel, softButton, hardButton, wifiLabel, wifiButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(23)
        }
        softButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        hardButton.snp.makeConstraints { make in
            make.leading.equalTo(softButton.snp.trailing).offset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        wifiLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(softButton.snp.bottom).offset(15)
        }
        wifiButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(wifiLabel.snp.bottom).offset(9)
            make.bottom.equalToSuperview().inset(22)
            make.height.equalTo(32)
        }
    }
}
