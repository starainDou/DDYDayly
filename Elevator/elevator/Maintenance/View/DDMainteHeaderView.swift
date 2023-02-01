//
//  DDMainteHeaderView.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit

class DDMainteHeaderView: UIView {

    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "Icon72"))
    
    private lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
    }
    
    private lazy var wifiView: UIImageView = UIImageView(image: UIImage(named: "Wifi"))
    
    private lazy var stateLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(hex: "#1ECAA1")
    }
    
    private lazy var addressView: UIImageView = UIImageView(image: UIImage(named: "Time"))
    
    private lazy var addressLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
    }
    
    private lazy var timeView: UIImageView = UIImageView(image: UIImage(named: "Time"))
    
    private lazy var timeLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(iconView, titleLabel, wifiView, stateLabel, addressView, addressLabel, timeView, timeLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(5)
        }
        wifiView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(35)
            make.top.equalToSuperview().inset(20)
        }
        stateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(wifiView)
            make.top.equalTo(wifiView.snp.bottom).inset(3)
        }
        addressView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(iconView.snp.bottom).offset(17)
            make.width.height.equalTo(16)
        }
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addressView)
            make.leading.equalTo(addressView.snp.trailing).offset(5)
        }
        timeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(addressView.snp.bottom).offset(17)
            make.width.height.equalTo(16)
            make.bottom.equalToSuperview().inset(20)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeView)
            make.leading.equalTo(timeView.snp.trailing).offset(5)
        }
    }
}
