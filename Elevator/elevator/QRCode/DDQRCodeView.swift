//
//  DDQRCodeView.swift
//  elevator
//
//  Created by ddy on 2023/1/18.
//

import UIKit
import Then
import SnapKit

class DDQRCodeView: UIView {
    
    public var bottomConstraint: Constraint? = nil
    
    private(set) lazy var backButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: ""), for: .normal)
    }
    
    private(set) lazy var lightButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: ""), for: .normal)
        $0.setImage(UIImage(named: ""), for: .selected)
    }
    
    private(set) lazy var tipLabel: UILabel = UILabel().then {
        $0.text = "Position QR code in this frame"
        $0.textColor = UIColor(hex: "#FFFFFF")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var scanLineView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "DDYQRCode.bundle/ScanGrid")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = UIColor(hex: "#168A8D")
    }
    
    private lazy var inputBackView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private lazy var inputTextField: UITextField = UITextField().then {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(hex: "#168A8D")]
        $0.attributedPlaceholder = NSAttributedString.init(string: "Please enter the number", attributes: attributes)
        $0.textColor = UIColor(hex: "#168A8D")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private(set) lazy var confirmButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "1792AC")
        $0.setTitle("Confirm", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    // #168A8D 14
    // #1792AC #FFFFFF 14  44 38 74  Confirm
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        addSubviews(backButton, lightButton, tipLabel, scanLineView, inputBackView)
        inputBackView.addSubviews(inputTextField, confirmButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(60)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        lightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(80)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        tipLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(120)
        }
        scanLineView.snp.makeConstraints { make in
            make.width.height.equalTo(240)
            make.centerX.equalToSuperview()
            make.top.equalTo(tipLabel.snp.bottom).offset(20)
        }
        inputBackView.snp.makeConstraints { make in
            bottomConstraint = make.bottom.equalToSuperview().inset(80).constraint
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(44)
        }
        inputTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(confirmButton.snp.leading).offset(-10)
        }
        confirmButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 74, height: 38))
            make.trailing.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
    }
}
