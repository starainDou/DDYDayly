//
//  DDCommisionFooter.swift
//  elevator
//
//  Created by ddy on 2023/1/31.
//

import UIKit

class DDCommisionFooter: UIView {

    private lazy var imageView: UIImageView = UIImageView(image: UIImage(named: ""))
    
    private lazy var selectButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: ""), for: .normal)
        $0.setImage(UIImage(named: ""), for: .selected)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    private lazy var tipLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#999999")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews(imageView, selectButton, tipLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(33)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 146, height: 120))
        }
        selectButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(17)
            make.width.height.equalTo(23)
        }
        tipLabel.snp.makeConstraints { make in
            make.centerY.equalTo(selectButton)
            make.leading.equalTo(selectButton.snp.trailing)
        }
    }
    
}
