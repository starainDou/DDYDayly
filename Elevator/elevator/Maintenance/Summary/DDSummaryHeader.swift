//
//  DDSummaryHeader.swift
//  elevator
//
//  Created by ddy on 2023/2/14.
//

import UIKit
import SwiftyJSON

class DDSummaryHeader: UIView {

    private(set) lazy var leftLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font =  UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.text = "ALL"
    }
    
    private(set) lazy var rightLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#FE5151")
        $0.font =  UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    private lazy var dashLineView: DDDashLineView = DDDashLineView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(leftLabel, rightLabel, dashLineView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        leftLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }
        dashLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
