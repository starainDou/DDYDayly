//
//  DDAlertDetailHeader.swift
//  elevator
//
//  Created by ddy on 2023/2/12.
//

import UIKit
import SwiftyJSON
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
    
    private(set) lazy var textView: UITextView = UITextView().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
    }
    
    private lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [block1View, updateButton, block2View]).then {
        $0.axis = .vertical
    }
    
    private lazy var block1View: UIView = UIView()
    
    private lazy var block2View: UIView = UIView()
    
    private(set) lazy var acknowlegeButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Acknowledged", for: .normal)
        $0.setTitleColor(UIColor(hex:"#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    private(set) lazy var updateButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Update", for: .normal)
        $0.setTitleColor(UIColor(hex:"#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    private(set) lazy var resolveButton: UIButton = UIButton(type: .custom).then {
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
        addSubviews(timeLabel, idView, idLabel, colorView, grayView, textView, acknowlegeButton, stackView, resolveButton)
        setViewConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
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
            make.height.equalTo(85)
        }
        textView.snp.makeConstraints { make in
            make.edges.equalTo(grayView).inset(UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10))
        }
        acknowlegeButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(32)
            make.bottom.equalTo(backView.snp.bottom).inset(14)
            make.trailing.equalTo(updateButton.snp.leading).offset(-8)
        }
        stackView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.centerX.equalToSuperview().offset(10)
            make.top.equalTo(grayView.snp.bottom)
            make.bottom.equalTo(backView.snp.bottom)
        }
        block1View.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(12)
        }
        block2View.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(14)
        }
        updateButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        resolveButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(32)
            make.bottom.equalTo(backView.snp.bottom).inset(14)
            make.leading.equalTo(updateButton.snp.trailing).offset(8)
        }
    }
    
    public func loadData(_ json: JSON, tagIndex: Int) { // DDLiftModel
        stateLabel.text = tagIndex == 0 ? "Alert" : (tagIndex == 2 ? " Normal" : "Alarm")
        titleLabel.text = json["liftnumber"].stringValue // "2#2#A001" // item.number
        timeLabel.text = DDAppInfo.dateStr(json["createtime"].stringValue, dateFormat: "yyyy/MM/dd HH:mm") //"09/11/2020 12:12" //
        brandLabel.text =  json["brand"].stringValue// "SASU"//item.brand.isEmpty ? "-" : item.brand
        addressLabel.text = json["address"].stringValue // "Singapore 1224 street" // item.address.isEmpty ? "-" : item.address
        idLabel.text = json["deviceId"].stringValue // "HWASKDHSJKDH5552"
        textView.text = json["description"].stringValue // "The elevator IOT box needs monthly mainte"
        colorView.image = UIImage(named: "alert_\(json["severity"].stringValue.lowercased())") ?? UIImage(named: "alert_unkonwn")
    }

}
