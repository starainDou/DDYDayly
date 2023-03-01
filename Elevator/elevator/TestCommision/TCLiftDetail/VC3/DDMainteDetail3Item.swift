//
//  DDMainteDetail3Item.swift
//  elevator
//
//  Created by ddy on 2023/2/5.
//

import UIKit

class DDMainteDetail3Item: UIView {

    private(set) lazy var iconView: UIImageView = UIImageView()
    
    private(set) lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
    }

    private(set) lazy var textLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
    }
    
    private lazy var dashLineView: DDDashLineView = DDDashLineView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(iconView, titleLabel, textLabel, dashLineView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(12)
        }
        textLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(23)
        }
        dashLineView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(textLabel).inset(23)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
