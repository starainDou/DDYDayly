//
//  DDCommisionHeader.swift
//  elevator
//
//  Created by ddy on 2023/1/31.
//

import UIKit

class DDCommisionHeader: UIView {
    
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "Icon72"))
    
    private(set) lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
    }
    
    private(set) lazy var stateLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(hex: "#1ECAA1")
    }
    
    private lazy var brandView: UIImageView = UIImageView(image: UIImage(named: "Crown"))
    
    private(set) lazy var brandLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
    }
    
    private lazy var addressView: UIImageView = UIImageView(image: UIImage(named: "Location"))
    
    private(set) lazy var addressLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
    }
    
    private lazy var timeView: UIImageView = UIImageView(image: UIImage(named: "Time"))
    
    private(set) lazy var timeLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews(iconView, titleLabel, stateLabel, brandView, brandLabel, addressView, addressLabel, timeView, timeLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(5)
        }
        stateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.trailing.equalToSuperview().inset(15)
        }
        brandView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(iconView.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        brandLabel.snp.makeConstraints { make in
            make.centerY.equalTo(brandView)
            make.leading.equalTo(brandView.snp.trailing).offset(5)
        }
        addressView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(brandView.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addressView)
            make.leading.equalTo(addressView.snp.trailing).offset(5)
        }
        timeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(addressView.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeView)
            make.leading.equalTo(timeView.snp.trailing).offset(5)
        }
    }
    
    public func loadData(item: DDVerifyModel) {
        titleLabel.text = item.title
        stateLabel.text = item.state
        timeLabel.text = item.time
    }
    
    public func test() {
        titleLabel.text = "2#2#A001"
        brandLabel.text = "SASU"
        addressLabel.text = "Singapore 1224 street"
        timeLabel.text = "09/11/2020 12:12"
    }

}
