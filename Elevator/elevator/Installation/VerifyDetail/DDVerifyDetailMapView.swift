//
//  DDVerifyDetailMapView.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit
import MapKit
import SwiftyJSON

class DDVerifyDetailMapView: UIView {
    
    private lazy var mapView: MKMapView = MKMapView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.mapType = .standard
        $0.isUserInteractionEnabled = false
    }
    
    private(set) lazy var locationButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "LocationTarget"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    private lazy var coordinateView: DDDetailItemView = DDDetailItemView().then {
        $0.shapeLayer.removeFromSuperlayer()
        $0.titleLabel.text = "Geospatial coordinate"
        $0.textField.isEnabled = false
    }
    
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "UpDown"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.masksToBounds = true
        layer.cornerRadius = 8
        addSubviews(mapView, coordinateView, iconView, locationButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(65)
        }
        coordinateView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }
        iconView.snp.makeConstraints { make in
            make.center.equalTo(mapView)
            make.width.height.equalTo(20)
        }
        
        locationButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.bottom.equalTo(mapView.snp.bottom).inset(15)
            make.trailing.equalTo(mapView.snp.trailing).inset(5)
        }
    }
    
    public func loadData(_ json: JSON?) {
        let lat: Double = json?["lat"].doubleValue ?? 0
        let lng: Double = json?["lng"].doubleValue ?? 0
        let regionCenter = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lng)) // 32 118
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: regionCenter, span: regionSpan)
        mapView.setRegion(region, animated: true)
        coordinateView.textField.text = "\(lat)/\(lng)"
        
//        let annotion = MKPointAnnotation()
//        annotion.coordinate = regionCenter
//        mapView.addAnnotation(annotion)
    }
}

/*
 let lat: Double = Double(model?.lat ?? "0") ?? 0.0
 let lng: Double = Double(model?.lng ?? "0") ?? 0.0
 let regionCenter = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lng))
 let regionSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
 let region = MKCoordinateRegion(center: regionCenter, span: regionSpan)
 mapView.setRegion(region, animated: true)
 
 let annotion = MKPointAnnotation()
 annotion.coordinate = regionCenter
 mapView.addAnnotation(annotion)
 */

// https://jiuaidu.com/jianzhan/979082/
