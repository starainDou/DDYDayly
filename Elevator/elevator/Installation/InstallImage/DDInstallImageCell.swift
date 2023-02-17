//
//  DDInstallImageCell.swift
//  elevator
//
//  Created by ddy on 2023/1/31.
//

import UIKit
import Then
import SwiftUI
import SwiftyJSON

class DDInstallImageCell: UICollectionViewCell {
    
    enum Action {
        case take
        case delete
    }
    
    var actionBlock: ((DDInstallImageCell.Action) -> Void)?
    
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#1792AC") // #707B7B
        $0.layer.cornerRadius = 4
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor(hex: "#FFFFFF")
        $0.numberOfLines = 0
    }
    
    private lazy var imageView: UIImageView = UIImageView().then {
        $0.backgroundColor = UIColor(hex: "#EEEEEE")
    }
    
    private lazy var deleteButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "Delete"), for: .normal)
        $0.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }
    
    private lazy var takeButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "TakePhoto"), for: .normal)
        $0.addTarget(self, action: #selector(takeAction), for: .touchUpInside)
    }
    
    private lazy var profileLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#999999")
        $0.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        $0.numberOfLines = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(backView, titleLabel, imageView, deleteButton, takeButton, profileLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(36)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(5)
            make.trailing.lessThanOrEqualTo(backView).inset(5)
            make.centerY.equalTo(backView)
        }
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.equalTo(backView.snp.bottom)
            make.height.equalTo(imageView.snp.width)
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView)
            make.width.height.equalTo(24)
        }
        takeButton.snp.makeConstraints { make in
            make.center.equalTo(imageView)
            make.width.height.equalTo(28)
        }
        profileLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.trailing.lessThanOrEqualToSuperview().inset(4)
            make.top.equalTo(imageView.snp.bottom).offset(6)
        }
    }
    
    public func load(json: JSON, cacheKey: String) {
        titleLabel.text = json["title"].stringValue
        profileLabel.text = DDShared.shared.liftProfile(cacheKey)
        if let img = DDShared.shared.liftImage(cacheKey) {
            imageView.image = img
            takeButton.isHidden = true
            deleteButton.isHidden = false
        } else {
            imageView.image = nil
            takeButton.isHidden = false
            deleteButton.isHidden = true
        }
    }
    
    @objc private func takeAction() {
        actionBlock?(.take)
    }
    
    @objc private func deleteAction() {
        actionBlock?(.delete)
    }
}
