//
//  DDSammaryCell.swift
//  elevator
//
//  Created by ddy on 2023/2/14.
//

import UIKit
import SwiftyJSON

class DDSammaryCell: UITableViewCell {

    private(set) lazy var leftLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#168991")
        $0.font =  UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private(set) lazy var rightLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font =  UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubviews(leftLabel, rightLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        leftLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(35)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.lessThanOrEqualTo(DDScreen.width - 110)
        }
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }
    }
    public func loadData(_ json: JSON) {
        leftLabel.text = json["name"].stringValue
        rightLabel.text = json["value"].stringValue
    }
}
