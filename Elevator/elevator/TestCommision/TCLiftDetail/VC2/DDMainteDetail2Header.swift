//
//  DDMainteDetail2Header.swift
//  elevator
//
//  Created by ddy on 2023/2/2.
//

import UIKit
import SwiftyJSON

class DDMainteDetail2Header: UICollectionViewCell {
    
    private var actionBlock: (() -> Void)?
    
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
    
    private lazy var downButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "DownloadCyan"), for: .normal)
        $0.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(pieView, pinView, numberLabel, quelityLabel, downButton)
        setViewConstraints()
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
        
        downButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(17)
            make.width.height.equalTo(30)
        }
    }
    
    public func loadData(_ json: JSON, action: (() -> Void)?) {
        layoutIfNeeded()
        actionBlock = action
        let progress = json["rideQuality"].floatValue
        var transform = CGAffineTransform.identity
        let pinSize = pinView.bounds.size
        transform = transform.translatedBy(x: pinSize.width / 2 - 7, y: 0)
        transform = transform.rotated(by: CGFloat(progress) * CGFloat.pi / 100.0)
        transform = transform.translatedBy(x: -pinSize.width / 2 + 7, y: 0)
        pinView.transform = transform
    }
    
    @objc private func downloadAction() {
        actionBlock?()
    }
}
// https://www.remove.bg/zh/upload
