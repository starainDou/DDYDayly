//
//  DDInstallationCell.swift
//  elevator
//
//  Created by ddy on 2023/1/29.
//

import Foundation
import Then
import SwiftyJSON

class DDInstallationCell: UITableViewCell {
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubviews(backView, iconView, titleLabel, stateLabel)
        contentView.addSubviews(brandView, brandLabel, addressView, addressLabel, timeView, timeLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(5)
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
            make.bottom.equalTo(backView).inset(25)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeView)
            make.leading.equalTo(timeView.snp.trailing).offset(5)
        }
    }
    
    public func loadData(json: JSON, tag: Int) {
        print("666 \(tag)")
        titleLabel.text = json["liftnumber"].stringValue
        stateLabel.text = tag == 0 ? "Not Installed" : (tag == 5 ? " Commissioned" : "Not Commissioned")
        timeLabel.text = DDAppInfo.dateStr(json["createtime"].stringValue)
        brandLabel.text = json["brand"].stringValue.isEmpty ? "-" : json["brand"].stringValue
        addressLabel.text = json["address"].stringValue.isEmpty ? "-" : json["address"].stringValue
    }
}
