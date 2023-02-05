//
//  DDHomeHeaderView.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import UIKit

class DDHomeHeaderView: UIView {

    private lazy var backImageView: UIImageView = UIImageView(image: UIImage(named: "BeiJing"))
    
    private lazy var avatarView: UIImageView = UIImageView(image: UIImage(named: "AvatarDefault"))
    
    private(set) lazy var nameLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#FFFFFF")
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private(set) lazy var roleLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#FFFFFF")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        addSubviews(backImageView, avatarView, nameLabel, roleLabel)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        avatarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(30)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(avatarView.snp.centerY).offset(-3)
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
        }
        roleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.centerY).offset(3)
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
        }
    }
}
