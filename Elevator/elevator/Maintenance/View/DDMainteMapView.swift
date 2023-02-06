//
//  DDMainteMapView.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import MapKit

class DDMainteMapView: UIView {

    private lazy var mapView: MKMapView = MKMapView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.mapType = .standard
        $0.isUserInteractionEnabled = false
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.masksToBounds = true
        layer.cornerRadius = 8
        addSubviews(mapView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.trailing.leading.top.bottom.equalToSuperview().inset(15)
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
