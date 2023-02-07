//
//  DDInstallSegmentView.swift
//  elevator
//
//  Created by ddy on 2023/2/6.
//

import UIKit

class DDInstallSegmentView: UIView {

    private lazy var searchBackView: UIView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 14
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
    }
    
    private lazy var searchImgView: UIImageView = UIImageView(image: UIImage(named: "Search"))
    
    private(set) lazy var textField: UITextField = UITextField().then {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
        $0.placeholder = " lift ID"
        $0.returnKeyType = .done
        $0.autocorrectionType = .default
        $0.delegate = self
    }

    private(set) lazy var searchButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.setTitle("Search", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .selected)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private(set) lazy var notInButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.setTitle("Not-Ins", for: .normal)
        $0.setTitleColor(UIColor(hex: "#333333"), for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .selected)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.tag = 0
    }
    
    private(set) lazy var notComButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#DEDEE0")
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.setTitle("Not-Com", for: .normal)
        $0.setTitleColor(UIColor(hex: "#333333"), for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .selected)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.tag = 1
    }
    
    private(set) lazy var comButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#DEDEE0")
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.setTitle("Com", for: .normal)
        $0.setTitleColor(UIColor(hex: "#333333"), for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .selected)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.tag = 2
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(searchBackView, searchImgView, textField, searchButton, notInButton, notComButton, comButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        searchBackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.height.equalTo(28)
            make.trailing.equalTo(searchButton.snp.leading).offset(-9)
            make.top.equalToSuperview().inset(11)
        }
        searchImgView.snp.makeConstraints { make in
            make.centerY.equalTo(searchBackView)
            make.leading.equalTo(searchBackView).inset(9)
            make.width.height.equalTo(14)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(searchImgView.snp.trailing).offset(14)
            make.trailing.equalTo(searchBackView.snp.trailing).inset(14)
            make.top.bottom.equalTo(searchBackView)
        }
        searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(28)
            make.width.equalTo(72)
            make.centerY.equalTo(searchBackView)
        }
        notInButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 28))
            make.top.equalTo(searchBackView.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(16)
        }
        notComButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 28))
            make.top.equalTo(searchBackView.snp.bottom).offset(14)
            make.leading.equalTo(notInButton.snp.trailing).offset(8)
        }
        comButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 28))
            make.top.equalTo(searchBackView.snp.bottom).offset(14)
            make.leading.equalTo(notComButton.snp.trailing).offset(8)
        }
    }
    
}

extension DDInstallSegmentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
