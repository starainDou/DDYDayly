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
import JXSegmentedView
import Then

class DDEngineerVC: UIViewController {
    
    private lazy var headerView: DDEngineerHeader = DDEngineerHeader()
    
    private lazy var segBackView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 4
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
    }
    
    private lazy var sortButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "MapDown"), for: .normal)
        $0.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
        $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    private lazy var segmentView: JXSegmentedView = JXSegmentedView().then {
        $0.delegate = self
        $0.dataSource = segmentDataSource
        $0.listContainer = containerView
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.indicators = [JXSegmentedIndicatorLineView().then { indicator in
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        }]
    }
    private lazy var segmentDataSource = JXSegmentedTitleDataSource().then {
        $0.titles = ["Alert", "Alarm", "Normal"]
        $0.isItemSpacingAverageEnabled = true
        $0.titleNormalFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.titleNormalColor = UIColor(hex: "#666666")
        $0.titleSelectedFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.titleSelectedColor = UIColor(hex: "#168991")
    }
    
    private lazy var containerView: JXSegmentedListContainerView = JXSegmentedListContainerView(dataSource: self)

    private lazy var alertVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 1
    }
    
    private lazy var alarmVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 3
    }
    
    private lazy var normalVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 5
    }
    
    private var currentVC: DDEngineerSubVC?
    
    var alarmType: Int = 0 {
        didSet {
            alertVC.alarmType = alarmType
            alarmVC.alarmType = alarmType
            normalVC.alarmType = alarmType
        }
    }
    
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
        view.addSubviews(headerView, segBackView, containerView)
        segBackView.addSubviews(segmentView, sortButton)
        setViewConstraints()
        setClosure()
        loadData()
    }
    
    private func setViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(250 + DDScreen.statusBarHeight)
        }
        segBackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(headerView.snp.bottom).offset(-10)
        }
        containerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(segBackView.snp.bottom)
        }
        segmentView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(segBackView.snp.centerX).offset(20)
        }
        sortButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
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
        guard let vc = currentVC else { return }
        currentVC?.sortType = !vc.sortType
    }
}

extension DDEngineerVC: JXSegmentedViewDelegate {
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

extension DDEngineerVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentDataSource.dataSource.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return alertVC
        } else if index == 1 {
            return alarmVC
        } else if index == 2 {
            return normalVC
        }
    }
}
