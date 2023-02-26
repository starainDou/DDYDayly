//
//  DDSummarySectionHeader.swift
//  elevator
//
//  Created by ddy on 2023/2/14.
//

import UIKit
import SwiftyJSON

class DDSummarySectionHeader: UIView {
    
    private var actionBlock: (() -> Void)?
    
    private lazy var stackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private lazy var titleLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font =  UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private lazy var arrowButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: ""), for: .normal)
        $0.setImage(UIImage(named: ""), for: .selected)
        $0.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }

    private(set) lazy var leftLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font =  UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private(set) lazy var rightLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font =  UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(stackView, arrowButton, rightLabel)
        stackView.addArrangedSubviews(titleLabel, leftLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(80)
            make.bottom.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(DDScreen.width - 110)
        }
        arrowButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalTo(titleLabel)
        }
        leftLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(DDScreen.width - 110)
        }
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalTo(leftLabel)
        }
    }
    
    public func loadData(_ json: JSON, isSelected: Bool, action: (() -> Void)?) {
        titleLabel.text = json["content"].stringValue
        arrowButton.isSelected = isSelected
        leftLabel.text = "ALL"
        rightLabel.text = json["total"].stringValue
        leftLabel.isHidden = !isSelected
        actionBlock = action
    }
    
    @objc private func tapAction() {
        actionBlock?()
    }

}
