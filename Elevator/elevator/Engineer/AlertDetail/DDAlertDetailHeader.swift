//
//  DDAlertDetailHeader.swift
//  elevator
//
//  Created by ddy on 2023/2/12.
//

import UIKit
import IQKeyboardManagerSwift

class DDAlertDetailHeader: UIView {

    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "UpDown"))
    
    private lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
    }
    
    private lazy var stateLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(hex: "#1ECAA1")
    }
    
    private lazy var brandView: UIImageView = UIImageView(image: UIImage(named: "Crown"))
    
    private lazy var brandLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
    }
    
    private lazy var addressView: UIImageView = UIImageView(image: UIImage(named: "Location"))
    
    private lazy var addressLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
    }
    
    private lazy var timeView: UIImageView = UIImageView(image: UIImage(named: "Time"))
    
    private lazy var timeLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
    }
    
    private lazy var idView: UIImageView = UIImageView(image: UIImage(named: "Icon201"))
    
    private lazy var idLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
    }
    
    private lazy var colorView: UIImageView = UIImageView()
    
    private lazy var grayView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private lazy var textView: UITextView = UITextView().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
    }
    
    private lazy var acknowlegeButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Acknowledged", for: .normal)
        $0.setTitleColor(UIColor(hex:"#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    private lazy var updateButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Update", for: .normal)
        $0.setTitleColor(UIColor(hex:"#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    private lazy var resolveButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Resolve", for: .normal)
        $0.setTitleColor(UIColor(hex:"#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(backView, iconView, titleLabel, stateLabel, brandView, brandLabel, addressView, addressLabel, timeView)
        addSubviews(timeLabel, idView, idLabel, colorView, grayView, textView, acknowlegeButton, updateButton, resolveButton)
        setViewConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
        }
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(15)
            make.top.equalTo(backView).offset(20)
            make.width.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(5)
        }
        stateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.trailing.equalTo(backView).inset(15)
        }
        brandView.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(15)
            make.top.equalTo(iconView.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        brandLabel.snp.makeConstraints { make in
            make.centerY.equalTo(brandView)
            make.leading.equalTo(brandView.snp.trailing).offset(5)
        }
        addressView.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(15)
            make.top.equalTo(brandView.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addressView)
            make.leading.equalTo(addressView.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(backView).inset(10)
        }
        timeView.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(15)
            make.top.equalTo(addressView.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeView)
            make.leading.equalTo(timeView.snp.trailing).offset(5)
        }
        colorView.snp.makeConstraints { make in
            make.trailing.equalTo(backView).inset(15)
            make.centerY.equalTo(timeView)
            make.width.height.equalTo(20)
        }
        idView.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(15)
            make.top.equalTo(timeView.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        idLabel.snp.makeConstraints { make in
            make.centerY.equalTo(idView)
            make.leading.equalTo(idView.snp.trailing).offset(5)
        }
        grayView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backView).inset(15)
            make.top.equalTo(idView.snp.bottom).offset(13)
            make.bottom.equalTo(acknowlegeButton.snp.top).offset(-12)
        }
        textView.snp.makeConstraints { make in
            make.edges.equalTo(grayView).inset(UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10))
        }
        acknowlegeButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(32)
            make.bottom.equalTo(backView.snp.bottom).inset(14)
            make.trailing.equalTo(updateButton.snp.leading).offset(-8)
        }
        updateButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(32)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backView.snp.bottom).inset(14)
        }
        resolveButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(32)
            make.bottom.equalTo(backView.snp.bottom).inset(14)
            make.leading.equalTo(updateButton.snp.trailing).offset(8)
        }
    }
    
    public func loadData() { // DDLiftModel
        titleLabel.text = "2#2#A001" // item.number
        stateLabel.text = tag == 1 ? "Alert" : (tag == 5 ? " Normal" : "Alerm")
        timeLabel.text = "09/11/2020 12:12" // DDAppInfo.dateStr(item.createtime)
        brandLabel.text = "SASU"//item.brand.isEmpty ? "-" : item.brand
        addressLabel.text = "Singapore 1224 street" // item.address.isEmpty ? "-" : item.address
        colorView.image = UIImage(named: "Icon31")
        idLabel.text = "HWASKDHSJKDH5552"
        textView.text = "The elevator IOT box needs monthly mainte"
    }

}
