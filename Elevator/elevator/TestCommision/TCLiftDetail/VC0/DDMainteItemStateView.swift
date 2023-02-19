//
//  DDMainteItemStateView.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import SwiftyJSON

class DDMainteItemStateView: UIView {

    private(set) lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
    }
    
    private(set) lazy var stateView: UIImageView = UIImageView()
    
    private(set) lazy var textLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(titleLabel, stateView, textLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(23)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(stateView.snp.leading).offset(-3)
        }
        stateView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(19)
        }
        textLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }
    }

}
