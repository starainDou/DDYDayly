//
//  DDVerifyDetailMapVC.swift
//  elevator
//
//  Created by ddy on 2023/2/15.
//

import UIKit
import SwiftyJSON
import MapKit
import CoreLocation

class DDVerifyDetailMapVC: UIViewController {

    
    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Select Address"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var sureButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Sure", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    private lazy var mapView: MKMapView = MKMapView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.mapType = .standard
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var oldButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "UpDown"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        $0.addTarget(self, action: #selector(oldAction), for: .touchUpInside)
    }
    
    private(set) lazy var locationButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "LocationTarget"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        $0.addTarget(self, action: #selector(locationAction), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, mapView, oldButton, locationButton)
        navigationBar.addSubview(sureButton)
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        mapView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
        sureButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(navigationBar.backButton)
        }
        oldButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
        }
        locationButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    

    public func loadData(_ json: JSON?) {
        let lat: Double = json?["lat"].doubleValue ?? 0
        let lng: Double = json?["lng"].doubleValue ?? 0
        let regionCenter = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lng)) // 32 118
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: regionCenter, span: regionSpan)
        mapView.setRegion(region, animated: true)
        
//        let annotion = MKPointAnnotation()
//        annotion.coordinate = regionCenter
//        mapView.addAnnotation(annotion)
    }
    
    @objc private func sureAction() {
        
    }
    @objc private func oldAction() {
        
    }
    @objc private func locationAction() {
        
    }
}
