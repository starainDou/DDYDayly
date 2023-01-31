//
//  DDImageEditVC.swift
//  elevator
//
//  Created by ddy on 2023/1/29.
//

import UIKit
import Then
import IQKeyboardManagerSwift

class DDImageEditVC: UIViewController {

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Image Editing"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var backView: UIScrollView = UIScrollView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.bounces = false
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var tipLabel: UILabel = UILabel().then {
        $0.text = "APS Bracket (Shaft Top)"
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    private lazy var imageView: UIImageView = UIImageView().then {
        $0.backgroundColor = UIColor(hex: "#EEEEEE")
    }
    
    private lazy var cameraView: UIImageView = UIImageView(image: UIImage(named: "TakePhoto"))
    
    private lazy var rectView: UIView = UIView().then {
        $0.layer.borderColor = UIColor(hex: "#CCCCCC").cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 1
        $0.layer.masksToBounds = true
    }
    
    private lazy var textView: IQTextView = IQTextView().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.placeholder = "255 text length, 4 images per page"
        $0.placeholderTextColor = UIColor(hex: "#999999")
        $0.delegate = self
    }
    
    private lazy var confirmButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Confirm", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, backView)
        backView.addSubviews(tipLabel, imageView, cameraView, rectView, textView, confirmButton)
        setViewConstraints()
    }

    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom).offset(10)
        }
        tipLabel.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(15)
            make.top.equalTo(backView).inset(20)
        }
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backView).inset(20)
            make.top.equalTo(tipLabel.snp.bottom).offset(18)
            make.height.equalTo(imageView.snp.width)
        }
        cameraView.snp.makeConstraints { make in
            make.center.equalTo(imageView)
            make.width.height.equalTo(28)
        }
        rectView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backView).inset(20)
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.height.equalTo(rectView.snp.width)
        }
        textView.snp.makeConstraints { make in
            make.edges.equalTo(rectView).inset(UIEdgeInsets(top: 10, left: 13, bottom: 10, right: 13))
        }
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.width.equalTo(DDScreen.width - 20*2 - 15*2)
            make.height.equalTo(40)
            make.top.equalTo(rectView.snp.bottom).offset(45)
            make.bottom.equalToSuperview().inset(56)
        }
    }
    
    @objc private func confirmAction() {
        let vc = DDVerifyDetailVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
}


extension DDImageEditVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        if let selectRange = textView.markedTextRange, textView.position(from: selectRange.start, offset: 0) != nil {
            // 未输入完成，比如拼音输入，注音输入
        } else {
            if text.count > 255 {
                textView.text = String(text.prefix(255))
            }
        }
    }
}
