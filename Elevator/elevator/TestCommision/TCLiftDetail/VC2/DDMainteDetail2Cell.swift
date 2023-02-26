//
//  DDMainteDetail2Cell.swift
//  elevator
//
//  Created by ddy on 2023/2/2.
//

import UIKit
import SwiftyJSON
import DDYSwiftyExtension

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
    public func loadData(_ kpiJson: JSON, titles: [String], keys: [String], index: Int) {
        iconView.image = UIImage(named: "kpi_" + keys[index])
        profileLabel.text = titles[index]
        if index == 0 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "")
        } else if index == 1 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "")
        } else if index == 2 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:3, unit: "")
        } else if index == 3 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "km")
        } else if index == 4 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:3, unit: "%")
        } else if index == 5 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "kg")
        } else if index == 6 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "")
        } else if index == 7 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "%")
        } else if index == 8 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "%")
        } else if index == 9 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "%")
        } else if index == 10 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "")
        } else if index == 11 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "s")
        } else if index == 12 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "")
        } else if index == 13 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "")
        } else if index == 14 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "kg")
        } else if index == 15 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "%")
        } else if index == 16 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "kg")
        } else if index == 17 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "%")
        } else if index == 18 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "km")
        } else if index == 19 {
            numberLabel.text = value(json: kpiJson[keys[index]], round:2, unit: "")
        }
    }
    
    private func value(json: JSON, round: Int, unit: String) -> String {
        if let value = json.float {
            return "\(value.ddy_round(round))".ddy_zero + unit
        } else if let value = json.double {
            return "\(value.ddy_round(round))".ddy_zero + unit
        } else if let value = json.int {
            return "\(value)".ddy_zero + unit
        } else if let value = json.string {
            return value.ddy_zero + unit
        } else {
            return "-"
        }
    }
}
