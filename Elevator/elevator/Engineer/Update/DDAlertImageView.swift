//
//  DDAlertImageView.swift
//  elevator
//
//  Created by ddy on 2023/2/13.
//

import UIKit

class DDAlertImageView: UIView {

    private lazy var imgView: UIImageView = UIImageView()
    
    private(set) lazy var addButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "TakePhoto"), for: .normal)
    }
    private(set) lazy var deleteButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "Delete"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#F3F3F3")
        layer.masksToBounds = true
        layer.cornerRadius = 4
        addSubviews(imgView, addButton, deleteButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(28)
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
}
