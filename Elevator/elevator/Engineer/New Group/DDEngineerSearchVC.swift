//
//  DDEngineerSearchVC.swift
//  elevator
//
//  Created by ddy on 2023/2/12.
//

import UIKit
import SwiftyJSON
import ProgressHUD

class DDEngineerSearchVC: UIViewController {

    private lazy var headerView: DDEngineerSearchHeader = DDEngineerSearchHeader()
    
    private lazy var scrollVew: UIScrollView = UIScrollView().then {
        $0.isScrollEnabled = false
    }
    
    private lazy var alertVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 1
    }
    
    private lazy var alarmVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 3
    }
    
    private lazy var normalVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(headerView, scrollVew)
        scrollVew.addSubviews(alertVC.view, alarmVC.view, normalVC.view)
        addChildren(alarmVC, alarmVC, normalVC)
        setViewConstraints()
        setClosure()
        loadData()
    }
    
    private func setViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(110 + DDScreen.statusBarHeight)
        }
        scrollVew.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        alertVC.view.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(scrollVew)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
            make.width.equalTo(DDScreen.width)
        }
        alarmVC.view.snp.makeConstraints { make in
            make.width.equalTo(DDScreen.width)
            make.height.centerY.equalTo(alertVC.view)
            make.leading.equalTo(alertVC.view.snp.trailing)
        }
        normalVC.view.snp.makeConstraints { make in
            make.width.equalTo(DDScreen.width)
            make.height.centerY.equalTo(alertVC.view)
            make.leading.equalTo(alarmVC.view.snp.trailing)
            make.trailing.equalTo(scrollVew)
        }
    }
    
    private func setClosure() {
        headerView.alertButton.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
        headerView.alarmButton.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
        headerView.normalButton.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
        headerView.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        headerView.searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
    }
    
    @objc private func selectAction(_ button: UIButton) {
        view.endEditing(true)
        headerView.selectIndex(button.tag)
        scrollVew.setContentOffset(CGPoint(x: DDScreen.width * CGFloat(button.tag), y: 0), animated: true)
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func searchAction() {
        guard let text = headerView.textField.text, !text.isEmpty else {
            ProgressHUD.showFailed("Please input content", interaction: false, delay: 3)
            return
        }
        
    }
    public func loadData() {
        
    }
}
