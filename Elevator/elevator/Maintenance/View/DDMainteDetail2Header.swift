//
//  DDMainteDetail2Header.swift
//  elevator
//
//  Created by ddy on 2023/2/2.
//

import UIKit

class DDMainteDetail2Header: UICollectionViewCell {
    
    private lazy var pieView: UIImageView = UIImageView(image: UIImage(named: "pieBg"))
    
    private lazy var pinView: UIImageView = UIImageView(image: UIImage(named: "pinBg"))
    
    private lazy var numberLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 38, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
        $0.text = "60%"
    }
    
    private lazy var quelityLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(hex: "#1ECAA1")
        $0.text = "60%"
    }
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(pieView, pinView, numberLabel, quelityLabel)
        setViewConstraints()
        setProgress()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")  }
    
    private func setViewConstraints() {
        pieView.snp.makeConstraints { make in
            make.width.equalTo(159)
            make.height.equalTo(88)
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(28)
        }
        pinView.snp.makeConstraints { make in
            make.width.equalTo(47)
            make.height.equalTo(14)
            make.trailing.equalTo(pieView.snp.centerX).offset(6)
            make.bottom.equalTo(pieView)
        }
        numberLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(pieView)
        }
        quelityLabel.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel)
            make.top.equalTo(numberLabel.snp.bottom).offset(4)
        }
    }
    
    func setProgress() {
        layoutIfNeeded()
        var transform = CGAffineTransform.identity
        let pinSize = pinView.bounds.size
        transform = transform.translatedBy(x: pinSize.width / 2 - 7, y: 0)
        transform = transform.rotated(by: 0.75 * CGFloat.pi)
        transform = transform.translatedBy(x: -pinSize.width / 2 + 7, y: 0)
        pinView.transform = transform
    }
}
// https://www.remove.bg/zh/upload
