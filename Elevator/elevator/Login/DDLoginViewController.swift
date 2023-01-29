//
//  DDLoginViewController.swift
//  elevator
//
//  Created by ddy on 2023/1/16.
//

import UIKit
import Then
import SnapKit
import DDYSwiftyExtension
import IQKeyboardManagerSwift

class DDLoginViewController: UIViewController {

    private lazy var topImageView: UIImageView = UIImageView(image: UIImage(named: "Picture"))

    private lazy var loginLabel: UILabel = UILabel().then {
        $0.text = "LOGIN"
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private lazy var nameTipLabel: UILabel = UILabel().then {
        $0.text = "User Name"
        $0.textColor = UIColor(hex: "#999999")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private lazy var nameBackView: UIView = UIView().then {
        $0.backgroundColor  = UIColor(hex: "#FFFFFF")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#EEEEEE").cgColor
    }
    
    private lazy var nameTextField: UITextField = UITextField().then {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
        $0.placeholder = "User Name"
        $0.keyboardType = .asciiCapable
        $0.textContentType = .username
        $0.returnKeyType = .done
        $0.autocorrectionType = .default
        $0.delegate = self
    }
    
    private lazy var pswdTipLabel: UILabel = UILabel().then {
        $0.text = "Password"
        $0.textColor = UIColor(hex: "#999999")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private lazy var pswdBackView: UIView = UIView().then {
        $0.backgroundColor  = UIColor(hex: "#FFFFFF")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#EEEEEE").cgColor
    }
    
    private lazy var pswdTextField: UITextField = UITextField().then {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
        $0.placeholder = "Password"
        $0.keyboardType = .asciiCapable
        $0.textContentType = .password
        $0.returnKeyType = .done
        $0.autocorrectionType = .default
        $0.isSecureTextEntry = true
        $0.delegate = self
    }
    
    private lazy var pswdShowButton: UIButton = UIButton().then {
        $0.setImage(UIImage(named: "EyeOpen"), for: .normal)
        $0.setImage(UIImage(named: "EyeClose"), for: .selected)
        $0.addTarget(self, action: #selector(showAction(_:)), for: .touchUpInside)
        $0.contentEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
    }
    
    private lazy var loginButton: UIButton = UIButton().then {
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.setTitle("Login", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(topImageView, loginLabel, nameTipLabel, nameBackView, nameTextField)
        view.addSubviews(pswdTipLabel, pswdBackView, pswdTextField, pswdShowButton, loginButton)
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        topImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(52)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(38)
            make.top.equalTo(topImageView.snp.bottom).offset(45)
        }
        nameTipLabel.snp.makeConstraints { make in
            make.leading.equalTo(loginLabel)
            make.top.equalTo(loginLabel.snp.bottom).offset(30)
        }
        nameBackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(38)
            make.top.equalTo(nameTipLabel.snp.bottom).offset(7)
            make.height.equalTo(42)
        }
        nameTextField.snp.makeConstraints { make in
            make.edges.equalTo(nameBackView).inset(UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        }
        
        pswdTipLabel.snp.makeConstraints { make in
            make.leading.equalTo(loginLabel)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
        pswdBackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(38)
            make.top.equalTo(pswdTipLabel.snp.bottom).offset(7)
            make.height.equalTo(42)
        }
        pswdTextField.snp.makeConstraints { make in
            make.leading.equalTo(pswdBackView).inset(12)
            make.trailing.equalTo(pswdBackView).inset(32)
            make.top.bottom.equalTo(pswdBackView)
        }
        pswdShowButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(pswdBackView)
        }
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(38)
            make.top.equalTo(pswdTextField.snp.bottom).offset(30)
            make.height.equalTo(42)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @objc private func showAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        pswdTextField.togglePasswordVisibility()
    }
    
    @objc private func loginAction(_ button: UIButton) {
        let vc = DDHomeVC()
        vc.loadData(user: DDUserModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension DDLoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == nameTextField) {
            nameBackView.backgroundColor  = UIColor(hex: "#F1F5FF")
        } else {
            pswdBackView.backgroundColor  = UIColor(hex: "#F1F5FF")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == nameTextField) {
            nameBackView.backgroundColor  = UIColor(hex: "#FFFFFF")
        } else {
            pswdBackView.backgroundColor  = UIColor(hex: "#FFFFFF")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
