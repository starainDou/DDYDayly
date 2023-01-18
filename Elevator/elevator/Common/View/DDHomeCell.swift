//
//  DDHomeCell.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import UIKit
import Then
import SnapKit
import DDYSwiftyExtension

class DDHomeCell: UITableViewCell {
    
    private lazy var backView: UIView = UIView().then { 
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private lazy var iconView: UIImageView = UIImageView()
    
    private lazy var titleLabel: UILabel  = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    private lazy var arrowView: UIImageView = UIImageView(image: UIImage(named: "ArrowRight"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubviews(backView, iconView, titleLabel, arrowView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(75)
        }
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(25)
            make.centerY.equalTo(backView)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(15)
            make.centerY.equalTo(backView)
        }
        arrowView.snp.makeConstraints { make in
            make.trailing.equalTo(backView).inset(12)
            make.centerY.equalTo(backView)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
    }
    
    public func loadData(item: DDHomeModel) {
        iconView.image = UIImage(named: item.icon)
        titleLabel.text = item.title
    }
}
