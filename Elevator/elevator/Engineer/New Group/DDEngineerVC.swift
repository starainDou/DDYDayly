//
//  DDEngineerVC.swift
//  elevator
//
//  Created by ddy on 2023/2/11.
//

import UIKit
import MapKit
import DDYSwiftyExtension
import SwiftyJSON

class DDEngineerVC: UIViewController {
    
    private lazy var headerView: DDEngineerHeader = DDEngineerHeader()
    
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
    
    var alarmType: Int = 0 {
        didSet {
            alertVC.alarmType = alarmType
            alarmVC.alarmType = alarmType
            normalVC.alarmType = alarmType
        }
    }
    
    private lazy var sortType: Int = 1
    
    init(_ type: Int) {
        super.init(nibName: nil, bundle: nil)
        alarmType = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(headerView, scrollVew)
        scrollVew.addSubviews(alertVC.view, alarmVC.view, normalVC.view)
        addChildren(alertVC, alarmVC, normalVC)
        setViewConstraints()
        setClosure()
        loadData()
    }
    
    private func setViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(310 + DDScreen.statusBarHeight)
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
        headerView.sortButton.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
        headerView.searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
    }
    
    @objc private func selectAction(_ button: UIButton) {
        view.endEditing(true)
        headerView.selectIndex(button.tag)
        scrollVew.setContentOffset(CGPoint(x: DDScreen.width * CGFloat(button.tag), y: 0), animated: true)
    }
    
    private func loadData() {
        headerView.loadData(JSON())
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func searchAction() {
        let vc = DDEngineerSearchVC(alarmType)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func sortAction() {
        
    }
}
