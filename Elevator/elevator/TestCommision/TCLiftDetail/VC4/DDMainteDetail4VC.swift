//
//  DDMainteDetail4VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView
import SwiftyJSON

class DDMainteDetail4VC: UIViewController {
    
    var liftBaseJson: JSON = JSON()
    
    private lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var topView: DDMainteDetail4TopView = DDMainteDetail4TopView()
    
    private lazy var mapView: DDMainteDetail4MapView = DDMainteDetail4MapView()
    
    private lazy var infoView: DDMainteDetail4InfoView = DDMainteDetail4InfoView()
    
    private lazy var mpuView: DDMainteDetail4MPUView = DDMainteDetail4MPUView()
    
    private lazy var peu0View: DDMainteDetail4PEU0View = DDMainteDetail4PEU0View()
    
    private lazy var peu1View: DDMainteDetail4PEU1View = DDMainteDetail4PEU1View()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubviews(topView, mapView, infoView, mpuView, peu0View, peu1View)
        setViewConstraints()
        mapView.loadData(liftBaseJson)
    }

    private func setViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
        }
        topView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(DDScreen.width - 30)
            make.top.equalToSuperview()
        }
        mapView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(15)
        }
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mapView.snp.bottom).offset(15)
        }
        mpuView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(infoView.snp.bottom).offset(15)
        }
        peu0View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mpuView.snp.bottom).offset(15)
        }
        peu1View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(peu0View.snp.bottom).offset(15)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}

extension DDMainteDetail4VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
