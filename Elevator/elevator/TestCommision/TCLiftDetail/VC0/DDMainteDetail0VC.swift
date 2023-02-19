//
//  DDMainteDetail0VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView
import SwiftyJSON

class DDMainteDetail0VC: UIViewController {
    
    private lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator  = false
    }

    private lazy var headerView: DDMainteHeaderView = DDMainteHeaderView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    private lazy var stateView: DDMainteStateView = DDMainteStateView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    private lazy var infoView: DDMainteInfoView = DDMainteInfoView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    private lazy var mapView: DDMainteMapView = DDMainteMapView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    var liftBaseJson: JSON = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubview(scrollView)
        scrollView.addSubviews(headerView, stateView, infoView, mapView)
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.width.equalTo(DDScreen.width - 30)
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(123)
        }
        stateView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(headerView.snp.bottom).offset(10)
        }
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(stateView.snp.bottom).offset(10)
        }
        mapView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(infoView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(mapView.snp.width).dividedBy(2)
        }
    }
    private func loadData() {
        //getStatusOfLift
    }
}

extension DDMainteDetail0VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
