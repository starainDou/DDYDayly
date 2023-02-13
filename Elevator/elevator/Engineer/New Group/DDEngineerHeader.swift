//
//  DDEngineerHeader.swift
//  elevator
//
//  Created by ddy on 2023/2/11.
//

import UIKit
import MapKit
import Then

class DDEngineerHeader: UIView {
    
    private lazy var mapView: MKMapView = MKMapView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.mapType = .standard
        $0.isUserInteractionEnabled = false
    }
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        $0.layer.borderWidth = 0.6
    }
    
    private(set) lazy var backButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ArrowLGray"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private lazy var lineView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#999999")
    }
    
    private(set) lazy var searchButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("search for lifts", for: .normal)
        $0.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.contentHorizontalAlignment = .leading
    }
    
    private(set) lazy var bookButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "MapIcon"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private(set) lazy var locationButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "LocationTarget"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private lazy var segmentView: UIView = UIView().then {
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    private(set) lazy var alertButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Alert", for: .normal)
        $0.tag = 0
    }
    
    private(set) lazy var alermButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Alerm", for: .normal)
        $0.tag = 1
    }
    
    private(set) lazy var normalButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Normal", for: .normal)
        $0.tag = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(mapView, backView, backButton, lineView, searchButton, bookButton, locationButton, segmentView)
        segmentView.addSubviews(alertButton, alermButton, normalButton)
        setViewConstraints()
        selectIndex(0)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(35)
            make.height.equalTo(28)
            make.top.equalToSuperview().inset(DDScreen.statusBarHeight + 30)
        }
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(5)
            make.top.bottom.equalTo(backView)
            make.width.equalTo(backButton.snp.height)
        }
        lineView.snp.makeConstraints { make in
            make.top.bottom.equalTo(backView).inset(7)
            make.leading.equalTo(backButton.snp.trailing).offset(4)
            make.width.equalTo(1)
        }
        searchButton.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.trailing).offset(7)
            make.trailing.equalToSuperview().inset(14)
            make.top.bottom.equalTo(backView)
        }
        bookButton.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(35)
            make.trailing.equalToSuperview().inset(19)
            make.width.height.equalTo(34)
        }
        locationButton.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.bottom.equalTo(segmentView.snp.top).offset(-29)
            make.centerX.equalTo(bookButton)
        }
        segmentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        alertButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(64)
        }
        alermButton.snp.makeConstraints { make in
            make.leading.equalTo(alertButton.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(64)
        }
        normalButton.snp.makeConstraints { make in
            make.leading.equalTo(alermButton.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(64)
        }
    }
    public func selectIndex(_ index: Int) {
        [alertButton, alermButton, normalButton].forEach { button in
            button.setTitleColor(UIColor(hex: button.tag == index ? "#168991" : "#666666"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: button.tag == index ? .semibold : .regular)
        }
    }
    public func loadData(_ model: DDLiftModel) {
        let regionCenter = CLLocationCoordinate2DMake(CLLocationDegrees(32), CLLocationDegrees(118))
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: regionCenter, span: regionSpan)
        mapView.setRegion(region, animated: true)
        
        let annotion = MKPointAnnotation()
        annotion.coordinate = regionCenter
        mapView.addAnnotation(annotion)
    }

}