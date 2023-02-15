//
//  DDVerifyDetailTopView.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit
import SwiftyJSON

class DDVerifyDetailTopView: UIView {
    
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "UpDown"))

    private lazy var titleLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    private lazy var addressView: UIImageView = UIImageView(image: UIImage(named: "Location"))
    
    private lazy var addressLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private lazy var timeView: UIImageView = UIImageView(image: UIImage(named: "Time"))
    
    private lazy var timeLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private lazy var wifiView: UIImageView = UIImageView(image: UIImage(named: "Wifi"))
    
    private lazy var wifiLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#168991")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.masksToBounds = true
        layer.cornerRadius = 8
        addSubviews(iconView, titleLabel, addressView, addressLabel, timeView, timeLabel, wifiView, wifiLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.top.equalToSuperview().inset(20)
            make.width.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(6)
            make.centerY.equalTo(iconView)
        }
        addressView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.top.equalTo(iconView.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        addressLabel.snp.makeConstraints { make in
            make.leading.equalTo(addressView.snp.trailing).offset(6)
            make.centerY.equalTo(addressView)
            make.trailing.lessThanOrEqualTo(wifiView.snp.leading).offset(-10)
        }
        timeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.top.equalTo(addressView.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeView.snp.trailing).offset(6)
            make.centerY.equalTo(timeView)
        }
        wifiView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(35)
            make.top.equalToSuperview().inset(20)
        }
        wifiLabel.snp.makeConstraints { make in
            make.top.equalTo(wifiView.snp.bottom).offset(4)
            make.centerX.equalTo(wifiView)
        }
    }
    
    public func loadData(_ json: JSON?) {
        titleLabel.text = json?["liftnumber"].stringValue
        addressLabel.text = json?["address"].stringValue
        timeLabel.text = DDAppInfo.dateStr(json?["createtime"].stringValue)
        wifiLabel.text = "on-line"
    }
}
