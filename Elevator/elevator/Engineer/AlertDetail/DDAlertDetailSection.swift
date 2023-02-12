//
//  DDAlertDetailSection.swift
//  elevator
//
//  Created by ddy on 2023/2/12.
//

import UIKit

class DDAlertDetailSection: UIView {

    private lazy var colorView: UIImageView = UIImageView()
    
    private lazy var deviceIdLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }

    private lazy var grayView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F3F3F3")
    }
    
    private lazy var textView: UITextView = UITextView().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private lazy var avatarView: UIImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22
    }
    
    private lazy var nameLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22
    }
    
    private lazy var dateLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private lazy var funcLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#1ECAA1")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private lazy var stackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(colorView, deviceIdLabel, avatarView, nameLabel, dateLabel, funcLabel, stackView)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        colorView.snp.makeConstraints { make in
            make.
        }
        deviceIdLabel.snp.makeConstraints { make in
            
        }
        avatarView.snp.makeConstraints { make in
            
        }
        nameLabel.snp.makeConstraints { make in
            
        }
        dateLabel.snp.makeConstraints { make in
            
        }
        funcLabel.snp.makeConstraints { make in
            
        }
        stackView.snp.makeConstraints { make in
            
        }
    }
}
