//
//  DDMainteDetailVC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import Then
import JXSegmentedView
import SwiftyJSON

class DDMainteDetailVC: UIViewController {
    
    var liftBaseJson: JSON = JSON()
    
    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Lift Details"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var segmentView: JXSegmentedView = JXSegmentedView().then {
        $0.delegate = self
        $0.dataSource = segmentDataSource
        $0.listContainer = containerView
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    private lazy var segmentDataSource = JXSegmentedTitleImageDataSource().then {
        $0.titles = ["", "", "", "", ""]
        $0.normalImageInfos = ["Icon174", "Profile", "Icon58", "Icon59", "Icon60"]
        $0.selectedImageInfos = ["Icon341", "Icon236", "Icon238", "Icon239", "Icon240"]
        $0.isItemSpacingAverageEnabled = true
        $0.itemWidth = 44
    }
    
    private lazy var containerView: JXSegmentedListContainerView = JXSegmentedListContainerView(dataSource: self)

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
            make.height.equalTo(44)
        }
        containerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom)
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }

}

extension DDMainteDetailVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
       
    }
}

extension DDMainteDetailVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentDataSource.dataSource.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return DDMainteDetail0VC().then { $0.liftBaseJson = self.liftBaseJson }
        } else if index == 1 {
            return DDMainteDetail1VC().then { $0.liftBaseJson = self.liftBaseJson }
        } else if index == 2 {
            return DDMainteDetail2VC().then { $0.liftBaseJson = self.liftBaseJson }
        } else if index == 3 {
            return DDMainteDetail3VC().then { $0.liftBaseJson = self.liftBaseJson }
        } else {
            return DDMainteDetail4VC().then { $0.liftBaseJson = self.liftBaseJson }
        }
    }
}
