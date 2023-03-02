//
//  DDAlarmHistoryVC.swift
//  elevator
//
//  Created by ddy on 2023/3/2.
//

import UIKit
import Then
import JXSegmentedView
import SwiftyJSON

class DDAlarmHistoryVC: UIViewController {
    
    private lazy var navigationBar: DDAlarmNavigator = DDAlarmNavigator().then {
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        $0.searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
    }

    private lazy var segBackView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    private lazy var segmentView: JXSegmentedView = JXSegmentedView().then {
        $0.delegate = self
        $0.dataSource = segmentDataSource
        $0.listContainer = containerView
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    private lazy var segmentDataSource = JXSegmentedTitleDataSource().then {
        $0.titles = ["Alert", "Alarm"]
        $0.itemWidth = 44
        $0.isItemSpacingAverageEnabled = true
        $0.titleNormalFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.titleNormalColor = UIColor(hex: "#666666")
        $0.titleSelectedFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.titleSelectedColor = UIColor(hex: "#168991")
    }
    
    private lazy var containerView: JXSegmentedListContainerView = JXSegmentedListContainerView(dataSource: self)
    
    private lazy var sortButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "MapDown"), for: .normal)
        $0.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
        $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    private lazy var alertVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 0
        $0.alarmType = 2
    }
    
    private lazy var alarmVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 1
        $0.alarmType = 2
    }
    
    private lazy var normalVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 2
        $0.alarmType = 2
    }
    
    private var currentVC: DDEngineerSubVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, segBackView, segmentView, sortButton, containerView)
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        segBackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.height.equalTo(44)
        }
        segmentView.snp.makeConstraints { make in
            make.leading.top.equalTo(segBackView)
            make.trailing.equalTo(self.view.snp.centerX)
            make.height.equalTo(44)
        }
        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(segBackView)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        containerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(segBackView.snp.bottom)
        }
    }
    

    @objc private func backAction() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    @objc private func searchAction() {
        view.endEditing(true)
        currentVC?.searchWord = navigationBar.textFiled.text
    }
    
    @objc private func sortAction() {
        view.endEditing(true)
        DDListView.show(in: view, array: ["Default", "By Alphabet", "By Town Council"], action: { [weak self] (text, idx) in
            self?.currentVC?.sortType = idx
        })
    }
}

extension DDAlarmHistoryVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index == 0 {
            currentVC = alertVC
        } else if index == 1 {
            currentVC = alarmVC
        } else if index == 2 {
            currentVC = normalVC
        }
    }
}

extension DDAlarmHistoryVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentDataSource.dataSource.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return alertVC
        } else if index == 1 {
            return alarmVC
        } else {
            return normalVC
        }
    }
}
