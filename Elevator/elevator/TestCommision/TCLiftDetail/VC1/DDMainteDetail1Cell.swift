//
//  DDMainteDetail1Cell.swift
//  elevator
//
//  Created by ddy on 2023/2/2.
//

import UIKit
import SwiftyJSON

class DDMainteDetail1Cell: UITableViewCell {

    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private lazy var stateView: UIImageView = UIImageView()
    
    private lazy var titleLabel: UILabel = UILabel().then  {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
    }
    
    private lazy var iconView: UIImageView = UIImageView()
    
    private lazy var reasonLabel: UILabel = UILabel().then  {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(hex: "#999999")
        $0.numberOfLines = 0
    }
    
    private lazy var stackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    private lazy var dateView: UIView = UIView()
    
    private lazy var numberLabel: UILabel = UILabel().then  {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(hex: "#999999")
        $0.numberOfLines = 0
    }
    
    private lazy var date1Label: UILabel = UILabel().then  {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(hex: "#999999")
        $0.numberOfLines = 0
    }
    
    private lazy var date2Label: UILabel = UILabel().then  {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(hex: "#999999")
        $0.numberOfLines = 0
    }
    
    private lazy var issueLabel: UILabel = UILabel().then  {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#7C80B8")
        $0.numberOfLines = 0
    }
    
    private lazy var alertLabel: UILabel = UILabel().then  {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
        $0.numberOfLines = 0
    }
    
    private lazy var timeLabel: UILabel = UILabel().then  {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#1ECAA1")
        $0.numberOfLines = 0
    }
    
    private lazy var resultLabel: UILabel = UILabel().then  {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#999999")
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubviews(backView)
        backView.addSubviews(stateView, titleLabel, iconView, stackView, timeLabel, resultLabel)
        stackView.addArrangedSubviews(reasonLabel, dateView, issueLabel, alertLabel)
        dateView.addSubviews(numberLabel, date1Label, date2Label)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        stateView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(23)
            make.top.equalToSuperview().inset(19)
            make.width.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(stateView.snp.trailing).offset(8)
            make.centerY.equalTo(stateView)
        }
        iconView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(stateView)
            make.width.height.equalTo(24)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(51)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(stateView.snp.bottom).offset(9)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(51)
            make.trailing.lessThanOrEqualTo(resultLabel.snp.leading)
            make.top.equalTo(stackView.snp.bottom).offset(15)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(14)
        }
        resultLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.trailing.equalToSuperview().inset(15)
        }
        reasonLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        dateView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        issueLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        alertLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        date1Label.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        date2Label.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(date1Label.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
    }
    
    public func loadData(_ json: JSON) {
        // DEBUG 蓝色   CRITICAL 黑色  MINOR 棕色   INFO黄色  MAJOR
        stateView.image = UIImage(named: "alert_\(json["severity"].stringValue.lowercased())") ?? UIImage(named: "alert_unkonwn")
        titleLabel.text = json["liftnumber"].stringValue
        iconView.image = UIImage(named: "Label") // severity  MINOR 棕色 Icon30  DEBUG蓝色
        reasonLabel.text = nil // "Car not leveled in floor 10"
        numberLabel.text = "\(json["eventTimes"].stringValue) Times"
        date1Label.text = DDAppInfo.dateStr(json["firstEventTime"].stringValue, dateFormat: "yyyy-MM-dd HH:mm:ss")
        date2Label.text = DDAppInfo.dateStr(json["lastEventTime"].stringValue, dateFormat: "yyyy-MM-dd HH:mm:ss")
        issueLabel.text = json["issue"].stringValue
        alertLabel.text = json["description"].stringValue
        timeLabel.text = DDAppInfo.dateStr(json["createtime"].stringValue, dateFormat: "yyyy-MM-dd HH:mm:ss")
        if json["status"].stringValue == "1" {
            resultLabel.text = "Ackonwledged"
            resultLabel.textColor = UIColor(hex:"#EFC41A")
        } else if json["status"].stringValue == "2" {
            resultLabel.text = "Resolved"
            resultLabel.textColor = UIColor(hex:"#EFC41A")
        } else if json["status"].stringValue == "3" {
            resultLabel.text = "Update"
            resultLabel.textColor = UIColor(hex:"#1ECAA1")
        } else {
            resultLabel.text = "Unackonwledged"
            resultLabel.textColor = UIColor(hex:"#FE5151")
        }// 0 未处理 1 已知晓 2 已处理 3已修改
    }

//    func test() {
//        stateView.image = UIImage(named: "Icon31")
//        titleLabel.text = jso
//        iconView.image = UIImage(named: "Label")
//        reasonLabel.text = "Car not leveled in floor 10"
//        numberLabel.text = "10 Times"
//        date1Label.text = "25/09/2020 06:48:45"
//        date2Label.text = "01/10/2020 03:28:49"
//        issueLabel.text = "Speed tolerance exceeded. Check controller set up and frequncy-inverter issues."
//        alertLabel.text = "Alert is raised, if the deviation between the rope tensions reached a given threshold."
//        timeLabel.text = "09/11 11:07:00"
//        resultLabel.text = "09/11 11:07:00"
//    }
}
