//
//  DDSummarySectionFooter.swift
//  elevator
//
//  Created by ddy on 2023/2/14.
//

import UIKit

class DDSummarySectionFooter: UIView {

    private lazy var dashLineView: DDDashLineView = DDDashLineView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(dashLineView)
        dashLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
