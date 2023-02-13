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
        $0.textColor = UIColor(hex: "")
    }
    
    private(set) lazy var arrowButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: ""), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
            make.centerY.equalToSuperview()
        }
        arrowButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
        }
    }
}
