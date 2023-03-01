//
//  DDMainteDetail3Header.swift
//  elevator
//
//  Created by ddy on 2023/2/28.
//

import UIKit

class DDMainteDetail3Header: UIView {

    private lazy var titleLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.text = "Single ride"
    }
    
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "UpDown"))
    
    private(set) lazy var nameLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F3F3F3")
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private(set) lazy var textLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private(set) lazy var timeButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "Calendar"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(titleLabel, iconView, nameLabel, backView, textLabel, timeButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints()  {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(23)
            make.top.equalToSuperview().inset(23)
        }
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(23)
            make.top.equalTo(titleLabel.snp.bottom).offset(19)
            make.width.height.equalTo(20)
            make.bottom.equalToSuperview().inset(15)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(8)
        }
        backView.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.leading.equalTo(nameLabel.snp.trailing).offset(20)
            make.trailing.equalTo(timeButton.snp.leading).offset(-4)
            make.height.equalTo(25)
        }
        textLabel.snp.makeConstraints { make in
            make.center.equalTo(backView)
        }
        timeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(iconView)
            make.width.height.equalTo(26)
        }
    }
}
