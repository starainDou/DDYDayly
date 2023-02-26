//
//  DDMainteDetail4InfoView.swift
//  elevator
//
//  Created by ddy on 2023/2/26.
//

import UIKit

class DDMainteDetail4InfoView: UIView {
    
    private lazy var titleLabel: UILabel = UILabel().then {
        $0.text = "Device Overview"
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    private lazy var wearView: DDMainteDetail4ItemView = DDMainteDetail4ItemView().then {
        $0.titleLabel.text = "WEARwatcherID"
    }
    private lazy var modelView: DDMainteDetail4ItemView = DDMainteDetail4ItemView().then {
        $0.titleLabel.text = "Device Model"
    }
    private lazy var manufacturerView: DDMainteDetail4ItemView = DDMainteDetail4ItemView().then {
        $0.titleLabel.text = "Manufacturer"
    }
    private lazy var hardwareView: DDMainteDetail4ItemView = DDMainteDetail4ItemView().then {
        $0.titleLabel.text = "Hardware Version"
    }
    private lazy var firewareView: DDMainteDetail4ItemView = DDMainteDetail4ItemView().then {
        $0.titleLabel.text = "Firmware Version"
    }
    
    private lazy var enableButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("ENABLED", for: .normal)
        $0.setTitleColor(UIColor(hex: "#10C69C"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private lazy var commissionButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("COMMSSIONED", for: .normal)
        $0.setTitleColor(UIColor(hex: "#10C69C"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private lazy var serviceButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("IN SERVICE", for: .normal)
        $0.setTitleColor(UIColor(hex: "#10C69C"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubviews(titleLabel, wearView, modelView, manufacturerView, hardwareView, firewareView, enableButton, commissionButton, serviceButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(22)
        }
        wearView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.height.equalTo(43)
        }
        modelView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(wearView.snp.bottom)
            make.height.equalTo(43)
        }
        manufacturerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(modelView.snp.bottom)
            make.height.equalTo(43)
        }
        hardwareView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(manufacturerView.snp.bottom)
            make.height.equalTo(43)
        }
        firewareView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(hardwareView.snp.bottom)
            make.height.equalTo(43)
        }
        enableButton.snp.makeConstraints { make in
            make.trailing.equalTo(commissionButton.snp.leading).offset(-10)
            make.centerY.equalTo(commissionButton)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        commissionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firewareView.snp.bottom).offset(13)
            make.size.equalTo(CGSize(width: 115, height: 32))
            make.bottom.equalToSuperview().inset(22)
        }
        serviceButton.snp.makeConstraints { make in
            make.leading.equalTo(commissionButton.snp.trailing).offset(10)
            make.centerY.equalTo(commissionButton)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
    }

}
