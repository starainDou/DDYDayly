//
//  DDVerifyDetailMapView.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit
import MapKit

class DDVerifyDetailMapView: UIView {
    
    private lazy var mapView: MKMapView = MKMapView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.mapType = .standard
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var coordinateView: DDDetailItemView = DDDetailItemView().then {
        $0.shapeLayer.removeFromSuperlayer()
        $0.titleLabel.text = "Geospatial coordinate"
        $0.textField.text = "29.21577/142.56"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.masksToBounds = true
        layer.cornerRadius = 8
        addSubviews(mapView, coordinateView)
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
    }
    
    public func loadData(_ model: DDLiftModel?) {
        let regionCenter = CLLocationCoordinate2DMake(CLLocationDegrees(32), CLLocationDegrees(118))
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: regionCenter, span: regionSpan)
        mapView.setRegion(region, animated: true)
        
        let annotion = MKPointAnnotation()
        annotion.coordinate = regionCenter
        mapView.addAnnotation(annotion)
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
