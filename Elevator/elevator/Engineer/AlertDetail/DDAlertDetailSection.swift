//
//  DDAlertDetailSection.swift
//  elevator
//
//  Created by ddy on 2023/2/12.
//

import UIKit
import SwiftyJSON
import Kingfisher

class DDAlertDetailSection: UIView {
    
    private lazy var dotView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#3E2AFF")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 3
    }

    private lazy var colorView: UIImageView = UIImageView()
    
    private lazy var deviceIdLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }

    private lazy var grayView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F3F3F3")
    }
    
    private lazy var textView: UITextView = UITextView().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#F3F3F3")
    }
    
    private lazy var avatarView: UIImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22
    }
    
    private lazy var nameLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    private lazy var dateLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private lazy var funcLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#1ECAA1")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private lazy var stackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private lazy var dashView: DDDashLineView = DDDashLineView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(dotView, colorView, deviceIdLabel, grayView, textView, avatarView, nameLabel, dateLabel, funcLabel, stackView, dashView)
        setViewConstraints() 
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        dotView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
            make.width.height.equalTo(6)
        }
        colorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(33)
            make.centerY.equalTo(dotView)
            make.width.height.equalTo(20)
        }
        deviceIdLabel.snp.makeConstraints { make in
            make.centerY.equalTo(colorView)
            make.leading.equalTo(colorView.snp.trailing).offset(11)
        }
        grayView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(33)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(colorView.snp.bottom).offset(11)
            make.height.equalTo(80)
        }
        textView.snp.makeConstraints { make in
            make.edges.equalTo(grayView).inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        avatarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(33)
            make.top.equalTo(grayView.snp.bottom).offset(40)
            make.width.height.equalTo(44)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(8)
            make.bottom.equalTo(avatarView.snp.centerY).offset(-2)
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(nameLabel)
        }
        funcLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(8)
            make.top.equalTo(avatarView.snp.centerY).offset(3)
        }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(33)
        }
        dashView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(33)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom)
        }
    }
    
    public func loadData(_ json: JSON) {
        colorView.image = UIImage(named: "alert_\(json["severity"].stringValue.lowercased())") ?? UIImage(named: "alert_unkonwn")
        deviceIdLabel.text = json["deviceId"].stringValue
        DDWebImage.setAvatar(json["acknowledgedUserPortrait"].stringValue, imageView: avatarView)
        avatarView.backgroundColor = .lightGray // acknowledgedUserPortrait resolveUserPortrait
        nameLabel.text = json["acknowledgedBy"].stringValue // "Bob";
        funcLabel.text = json["acknowledgeDesc"].stringValue // "Acknowledged"
        dateLabel.text = DDAppInfo.dateStr(json["acknowledgeTime"].stringValue, dateFormat: "yyyy/MM/dd HH:mm:ss") // "09/11 10:06:00"
        textView.text = json["message"].stringValue // "Lifts with rope tension issue"
        
        for updateDetail in json["updateDetails"].arrayValue {
            let item = DDAlertDetailItem()
            item.loadData(updateDetail)
            stackView.addArrangedSubview(item)
            item.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.greaterThanOrEqualTo(50)
            }
        }
    }
}
