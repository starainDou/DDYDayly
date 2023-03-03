//
//  DDAlertSelectView.swift
//  elevator
//
//  Created by ddy on 2023/2/13.
//

import UIKit

class DDAlertSelectView: UIView {

    private(set) lazy var textLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
        $0.numberOfLines = 0
    }
    
    private(set) lazy var arrowButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ArrowBottom"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 405, bottom: 5, right: 5)
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#F3F3F3")
        layer.masksToBounds = true
        layer.cornerRadius = 4
        addSubviews(textLabel, arrowButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        textLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(10)
            make.height.greaterThanOrEqualTo(15)
            make.trailing.lessThanOrEqualToSuperview().inset(30)
        }
        arrowButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(420)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
        }
    }
}
