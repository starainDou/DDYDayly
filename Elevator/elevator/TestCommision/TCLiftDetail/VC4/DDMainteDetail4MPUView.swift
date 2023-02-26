//
//  DDMainteDetail4MPUView.swift
//  elevator
//
//  Created by ddy on 2023/2/26.
//

import UIKit

class DDMainteDetail4MPUView: UIView {

    private lazy var titleLabel: UILabel = UILabel().then {
        $0.text = "Device Overview"
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubviews(titleLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(22)
        }
    }
}
