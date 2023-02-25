//
//  DDEngineerSearchHeader.swift
//  elevator
//
//  Created by ddy on 2023/2/11.
//

import UIKit

class DDEngineerSearchHeader: UIView {

    private(set) lazy var backButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ArrowLeft"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
    }
    
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    }

    private lazy var searchView: UIImageView = UIImageView(image: UIImage(named: ""))
    
    private(set) lazy var textField: UITextField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
        $0.placeholder = "search for lifts"
    }
    
    private(set) lazy var searchButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Search", for: .normal)
        $0.setTitleColor(UIColor(hex: "1792AC"), for: .normal)
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private lazy var segmentView: UIView = UIView().then {
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    private(set) lazy var alertButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Alert", for: .normal)
        $0.tag = 0
    }
    
    private(set) lazy var alarmButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Alarm", for: .normal)
        $0.tag = 1
    }
    
    private(set) lazy var normalButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Normal", for: .normal)
        $0.tag = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#1792AC")
        addSubviews(backButton, backView, searchView, textField, searchButton, segmentView)
        segmentView.addSubviews(alertButton, alarmButton, normalButton)
        setViewConstraints()
        selectIndex(0)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        backView.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.leading.equalTo(backButton.snp.trailing)
            make.trailing.equalTo(searchButton.snp.leading).offset(-12)
            make.bottom.equalTo(segmentView.snp.top).offset(-7)
        }
        searchView.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.leading.equalTo(backView).inset(9)
            make.centerY.equalTo(backView)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(searchView.snp.trailing).offset(14)
            make.top.bottom.equalTo(backView)
            make.trailing.equalTo(backView.snp.trailing).inset(14)
        }
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(72)
            make.height.equalTo(28)
        }
        segmentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        alertButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(64)
        }
        alarmButton.snp.makeConstraints { make in
            make.leading.equalTo(alertButton.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(64)
        }
        normalButton.snp.makeConstraints { make in
            make.leading.equalTo(alarmButton.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(64)
        }
    }
    
    public func selectIndex(_ index: Int) {
        [alertButton, alarmButton, normalButton].forEach { button in
            button.setTitleColor(UIColor(hex: button.tag == index ? "#168991" : "#666666"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: button.tag == index ? .semibold : .regular)
        }
    }
}
