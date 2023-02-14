//
//  DDSummaryVC.swift
//  elevator
//
//  Created by ddy on 2023/2/14.
//

import UIKit
import Then
import JXSegmentedView

extension JXSegmentedTitleDataSource: Then {}

class DDSummaryVC: UIViewController {

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Summary of Lift Performances"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var segmentView: JXSegmentedView = JXSegmentedView().then {
        $0.delegate = self
        $0.dataSource = segmentDataSource
        $0.listContainer = containerView
        $0.indicators = [indicator]
    }
    
    private lazy var segmentDataSource = JXSegmentedTitleDataSource().then {
        $0.titles = ["Issue", "Town"];
        $0.titleNormalFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.titleNormalFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.titleSelectedColor = UIColor(hex: "#168991")
        $0.titleNormalColor = UIColor(hex: "#666666")
        $0.isItemSpacingAverageEnabled = true
    }
    
    private lazy var indicator: JXSegmentedIndicatorLineView = JXSegmentedIndicatorLineView().then {
        $0.indicatorWidth = 20
        $0.indicatorHeight = 2
        $0.indicatorColor = UIColor(hex: "#168991")
    }
    
    private lazy var containerView:JXSegmentedListContainerView = JXSegmentedListContainerView(dataSource: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, segmentView, containerView)
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        segmentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.height.equalTo(40)
        }
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom)
        }
    }

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
}


extension DDSummaryVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
       
    }
}

extension DDSummaryVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentDataSource.dataSource.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return DDSammarySubVC().then { $0.summaryType = index + 1 }
    }
}


/*
 {
     "code": "200",
     "msg": "The request is successful",
     "data": {
         "total": 3,//summaryType:1(问题的总数),2(物业的总数)
         "values": [
             {
                 "issueTotal": 3,
                 "content": "CHEVALIER",//1:issue,2:town council
                 "values": [
                     {
                         "name": "Anomalous movement of the car detected. Please check for vandalism in the car, otherwise check alignment of rails and guides, check for worn guides", //summaryType:1(town council),2(issue)
                         "value": 1 //showType: 1(Qu),2(%)
                     },
                     {
                         "name": "Rope tension difference. Please check the rope tensioning.",
                         "value": 2
                     }
                 ]
             },
             {
                 "issueTotal": 1,
                 "content": "CWSERVICES",
                 "values": [
                     {
                         "name": "Device started up",
                         "value": 1
                     }
                 ]
             }
         ]
     }
 }

 */
