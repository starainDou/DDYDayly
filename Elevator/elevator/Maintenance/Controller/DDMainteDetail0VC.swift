//
//  DDMainteDetail0VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView

class DDMainteDetail0VC: UIViewController {
    
    private lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator  = false
    }

    private lazy var headerView: DDMainteHeaderView = DDMainteHeaderView()
    
    private lazy var infoView: DDMainteInfoView = DDMainteInfoView()
    
    private lazy var mapView: DDMainteMapView = DDMainteMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubviews(headerView, infoView, mapView)
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
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(headerView.snp.bottom).offset(10)
        }
        mapView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(infoView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

extension DDMainteDetail0VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
