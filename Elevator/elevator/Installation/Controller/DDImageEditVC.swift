//
//  DDImageEditVC.swift
//  elevator
//
//  Created by ddy on 2023/1/29.
//

import UIKit
import Then

class DDImageEditVC: UIViewController {

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Image Editing"
    }
    
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
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
    
    private lazy var textView: UITextView = UITextView().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private lazy var confirmButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Confirm", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, backView, tipLabel, imageView, cameraView, rectView, textView)
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
            make.top.equalTo(navigationBar.snp.bottom)
        }
        tipLabel.snp.makeConstraints { make in
            
        }
        imageView.snp.makeConstraints { make in
            
        }
        cameraView.snp.makeConstraints { make in
            
        }
        rectView.snp.makeConstraints { make in
            
        }
        textView.snp.makeConstraints { make in
            
        }
    }
}
