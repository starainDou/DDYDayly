//
//  DDNavigationBar.swift
//  elevator
//
//  Created by ddy on 2023/1/18.
//

import UIKit

class DDNavigationBar: UIView {

    private(set) lazy var backButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ArrowLeft"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
    }
    
    private(set) lazy var titleLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#FFFFFF")
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#1792AC")
        addSubviews(backButton, titleLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(12)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
    }
}
