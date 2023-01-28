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
    }
    
    private(set) lazy var titleLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#FFFFFF")
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(backButton, titleLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            
        }
        titleLabel.snp.makeConstraints { make in
            
        }
    }
}
