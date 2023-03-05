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
import ProgressHUD

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

class DDEngineerVC: UIViewController {
    
    private let titles: [String]  =  ["Alert", "Alarm", "Normal"]
    
    let headerHeight = 270
    
    let segbackHeight = 44
    
    private lazy var headerView: DDEngineerHeader = DDEngineerHeader().then {
        $0.back1Button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        $0.back2Button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        $0.bookButton.addTarget(self, action: #selector(booktAction(_:)), for: .touchUpInside)
        $0.locationButton.addTarget(self, action: #selector(locationAction), for: .touchUpInside)
        $0.searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        $0.textFiled.delegate = self
    }
    
    private lazy var pageView: JXPagingListRefreshView = JXPagingListRefreshView(delegate: self).then {
        $0.pinSectionHeaderVerticalOffset = Int(DDScreen.statusBarHeight + 44)
    }
    
    private lazy var segBackView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: DDScreen.width, height: 44)).then {
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
        $0.listContainer = pageView.listContainerView
        $0.indicators = [JXSegmentedIndicatorLineView().then { indicator in
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            indicator.indicatorColor = UIColor(hex: "#168991")
        }]
    }
    private lazy var segmentDataSource = JXSegmentedTitleDataSource().then {
        $0.titles = titles
        $0.isItemSpacingAverageEnabled = true
        $0.titleNormalFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.titleNormalColor = UIColor(hex: "#666666")
        $0.titleSelectedFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.titleSelectedColor = UIColor(hex: "#168991")
    }

    private lazy var alertVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 0
        $0.alarmType = 1
    }
    
    private lazy var alarmVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 1
        $0.alarmType = 1
    }
    
    private lazy var normalVC: DDEngineerSubVC = DDEngineerSubVC().then {
        $0.tagIndex = 2
        $0.alarmType = 1
    }
    
    private lazy var locationManager = CLLocationManager().then {
        $0.delegate = self
        $0.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        $0.distanceFilter = 50
    }
    
    private lazy var locationJson: JSON = JSON()
    
    private var currentVC: DDEngineerSubVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(pageView)
        segBackView.addSubviews(segmentView, sortButton)
        setViewConstraints()
        loadData()
        locationAction()
        currentVC = alertVC
    }
    
    private func setViewConstraints() {
        pageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        segmentView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(segBackView.snp.centerX).offset(50)
        }
        sortButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
    }
    
    @objc private func booktAction(_ button: UIButton) {
        view.endEditing(true)
        let originPoint = CGPoint(x: button.frame.minX, y: button.frame.maxY)
        let targetPoint = headerView.convert(originPoint, to: view)
        DDAlarmColorView.show(in: view, point: targetPoint)
    }
    
    private func loadData() {
        headerView.loadData(JSON())
    }
    
    @objc private func backAction() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func searchAction() {
        view.endEditing(true)
        currentVC?.searchWord = headerView.textFiled.text
    }
    
    @objc private func sortAction() {
        view.endEditing(true)
        DDListView.show(in: view, array: ["Default", "By Alphabet", "By Town Council"], action: { [weak self] (text, idx) in
            self?.currentVC?.sortType = idx
        })
    }
}

extension DDEngineerVC: CLLocationManagerDelegate {
    @objc private func locationAction() {
        view.endEditing(true)
        let authState: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authState = locationManager.authorizationStatus
        } else {
            authState = CLLocationManager.authorizationStatus()
        }
        switch authState {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            ProgressHUD.showFailed("Please open the location authorization in system setting", interaction: false, delay: 3)
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.startUpdatingLocation()
        @unknown default:
            ProgressHUD.showFailed("Location failed", interaction: false, delay: 3)
        }
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAction()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let coordinate = locations.first?.coordinate else { return }
        locationJson["lat"].double = coordinate.latitude.ddy_round(6)
        locationJson["lng"].double = coordinate.longitude.ddy_round(6)
        headerView.loadData(locationJson)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ProgressHUD.showFailed("Location failed", interaction: false, delay: 3)
    }
}

extension DDEngineerVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction()
        return true
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


extension DDEngineerVC: JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return headerHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return segbackHeight
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segBackView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
            return alertVC
        } else if index == 1 {
            return alarmVC
        } else {
            return normalVC
        }
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        headerView.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)
    }
}
