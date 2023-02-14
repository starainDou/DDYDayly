//
//  DDAlertUpdateVC.swift
//  elevator
//
//  Created by ddy on 2023/2/13.
//

import UIKit

class DDAlertUpdateVC: UIViewController {

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Verify"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private lazy var photo1View: DDAlertImageView = DDAlertImageView()
    
    private lazy var photo2View: DDAlertImageView = DDAlertImageView()
    
    private lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
        $0.text = "Resolved category"
    }
    
    private lazy var natureView: DDAlertSelectView = DDAlertSelectView().then  {
        $0.textLabel.text = "Nature of taski"
        $0.arrowButton.addTarget(self, action: #selector(natureAction), for: .touchUpInside)
    }
    
    private lazy var componentView: DDAlertSelectView = DDAlertSelectView().then  {
        $0.textLabel.text = "Compaonent"
        $0.arrowButton.addTarget(self, action: #selector(componentAction), for: .touchUpInside)
    }
    
    private lazy var taskView: DDAlertSelectView = DDAlertSelectView().then  {
        $0.textLabel.text = "Task"
        $0.arrowButton.addTarget(self, action: #selector(taskAction), for: .touchUpInside)
    }
    
    private lazy var grayView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F3F3F3")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private lazy var textView: UITextView = UITextView().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#F3F3F3")
    }
    
    private lazy var submitView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    private lazy var submitButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.setTitle("Submit", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, scrollView, submitView, submitButton)
        scrollView.addSubviews(backView)
        backView.addSubviews(photo1View, photo2View, titleLabel, natureView, componentView, taskView, grayView, textView)
        setViewConstraints()
        textView.text = "Other supplementary instructions"
    }
    
    private func setViewConstraints() {
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalTo(submitView.snp.top)
        }
        backView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        }
        photo1View.snp.makeConstraints { make in
            make.width.height.equalTo((DDScreen.width - 70) / 2)
            make.top.equalToSuperview().inset(19)
            make.leading.equalToSuperview().inset(15)
        }
        photo2View.snp.makeConstraints { make in
            make.leading.equalTo(photo1View.snp.trailing).offset(10)
            make.width.height.equalTo((DDScreen.width - 70) / 2)
            make.top.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(15)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(photo1View.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        natureView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(32)
        }
        componentView.snp.makeConstraints { make in
            make.top.equalTo(natureView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(32)
        }
        taskView.snp.makeConstraints { make in
            make.top.equalTo(componentView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(32)
        }
        grayView.snp.makeConstraints { make in
            make.top.equalTo(taskView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(19)
            make.height.equalTo(155)
            make.bottom.equalToSuperview().inset(40)
        }
        textView.snp.makeConstraints { make in
            make.edges.equalTo(grayView).inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        submitView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(62)
        }
        submitButton.snp.makeConstraints { make in
            make.center.equalTo(submitView)
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func natureAction() {
        
    }
    
    @objc private func componentAction() {
        
    }
    
    @objc private func taskAction() {
        
    }
    @objc private func submitAction() {
        
    }
}
