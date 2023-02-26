//
//  DDMainteDetail2Cell.swift
//  elevator
//
//  Created by ddy on 2023/2/2.
//

import UIKit
import SwiftyJSON

class DDMainteDetail2Cell: UICollectionViewCell {
    
    private lazy var rectView: UIView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor(hex: "#EEEEEE").cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var iconView: UIImageView = UIImageView()
    
    private lazy var numberLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.textColor = UIColor(hex: "#333333")
    }
    private lazy var containerView: UIView = UIView()
    private lazy var profileLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor(hex: "#999999")
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(rectView, iconView, numberLabel, containerView, profileLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        rectView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(5)
        }
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(rectView).inset(7)
            make.top.equalTo(rectView).inset(11)
            make.width.height.equalTo(22)
        }
        numberLabel.snp.makeConstraints { make in
            make.trailing.equalTo(rectView).inset(8)
            make.centerY.equalTo(iconView).inset(11)
            make.width.height.equalTo(22)
        }
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(rectView)
            make.top.equalTo(iconView.snp.bottom)
        }
        profileLabel.snp.makeConstraints { make in
            make.trailing.equalTo(containerView).inset(8)
            make.leading.greaterThanOrEqualTo(containerView).inset(8)
            make.centerY.equalTo(containerView)
            make.top.greaterThanOrEqualTo(containerView)
            make.bottom.lessThanOrEqualTo(containerView)
        }
    }
    public func loadData(_ value: String, title:String, key: String) {
        iconView.image = UIImage(named: "kpi_" + key)
        numberLabel.text = value
        profileLabel.text = title
    }
}
