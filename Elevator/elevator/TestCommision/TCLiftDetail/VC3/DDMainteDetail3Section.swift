//
//  DDMainteDetail3Section.swift
//  elevator
//
//  Created by ddy on 2023/2/26.
//

import UIKit

class DDMainteDetail3Section: UIView {

    private(set) lazy var timeLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    private(set) lazy var arrowButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ArrowTop"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(timeLabel, arrowButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(18)
            make.width.height.equalTo(26)
        }
    }
}
