//
//  DDVerifyDetailInfoView.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit

class DDVerifyDetailInfoView: UIView {
    
    private lazy var mapView: UIView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.backgroundColor = .lightGray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.masksToBounds = true
        layer.cornerRadius = 8
        addSubviews(mapView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(65)
        }
    }
}
