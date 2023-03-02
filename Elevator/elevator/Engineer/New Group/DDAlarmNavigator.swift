//
//  DDAlarmNavigator.swift
//  elevator
//
//  Created by ddy on 2023/3/2.
//

import UIKit

class DDAlarmNavigator: UIView {

    private(set) lazy var backButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ArrowLeft"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
    }
    
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        $0.layer.borderWidth = 0.6
    }

    private lazy var searchView: UIImageView = UIImageView(image: UIImage(named: "Search"))
    
    private(set) lazy var textFiled: UITextField = UITextField().then {
        $0.placeholder = "search for lifts"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
        $0.returnKeyType = .search
    }
    
    private(set) lazy var searchButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Search", for: .normal)
        $0.setTitleColor(UIColor(hex: "1792AC"), for: .normal)
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#1792AC")
        addSubviews(backButton, backView, searchButton, searchView, textFiled)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalTo(backView)
            make.leading.equalToSuperview().inset(10)
        }
        backView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(28)
            make.leading.equalTo(backButton.snp.trailing).offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
        }
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(28)
            make.centerY.equalTo(backView)
            make.trailing.equalToSuperview().inset(15)
        }
        searchView.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(5)
            make.width.height.equalTo(18)
            make.centerY.equalTo(backView)
        }
        textFiled.snp.makeConstraints { make in
            make.leading.equalTo(searchView.snp.trailing).offset(5)
            make.trailing.equalTo(backView).inset(10)
            make.bottom.height.equalTo(backView)
        }
    }
}
