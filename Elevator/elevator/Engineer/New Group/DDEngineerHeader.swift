//
//  DDEngineerHeader.swift
//  elevator
//
//  Created by ddy on 2023/2/11.
//

import UIKit
import MapKit
import Then
import SwiftyJSON

class DDEngineerHeader: UIView {
    
    private let navigationBarFrame = CGRect(x: 0, y: 0, width: DDScreen.width, height: DDScreen.statusBarHeight + 44)
    
    private lazy var navigatorBar: UIView = UIView(frame: navigationBarFrame)
    
    private lazy var mapView: MKMapView = MKMapView().then {
        $0.mapType = .standard
        $0.isUserInteractionEnabled = false
    }
    
    private(set) lazy var back1Button: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ArrowLeft"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
    }
    
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        $0.layer.borderWidth = 0.6
    }
    
    private lazy var backStackView: UIStackView = UIStackView(arrangedSubviews: [back1Button, backBlockView]).then {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    private lazy var backBlockView: UIView = UIView()
    
    private lazy var searchStackView: UIStackView = UIStackView(arrangedSubviews: [searchBlockView, searchButton]).then {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    private lazy var searchBlockView: UIView = UIView()
    
    private lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [back2Button, lineView, searchView]).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private(set) lazy var back2Button: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ArrowLGray"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private lazy var lineView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#999999")
    }
    
    private lazy var searchView: UIImageView = UIImageView(image: UIImage(named: ""))
    
    private(set) lazy var textFiled: UITextField = UITextField().then {
        $0.placeholder = "search for lifts"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
        $0.returnKeyType = .search
    }
    
    private(set) lazy var searchButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Search", for: .normal)
        $0.setTitleColor(UIColor(hex: "1792AC"), for: .normal)
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private(set) lazy var bookButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "MapIcon"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private(set) lazy var locationButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "LocationTarget"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: DDScreen.width, height: 250 + DDScreen.statusBarHeight))
        addSubviews(mapView, bookButton, locationButton, navigatorBar)
        navigatorBar.addSubviews(backStackView, backView, searchStackView)
        backView.addSubviews(stackView, textFiled)
        setViewConstraints()
        changeState(isChange: false)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bookButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(DDScreen.statusBarHeight + 44 + 35)
            make.trailing.equalToSuperview().inset(19)
            make.width.height.equalTo(34)
        }
        locationButton.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.bottom.equalToSuperview().inset(30)
            make.centerX.equalTo(bookButton)
        }
        backStackView.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalToSuperview().inset(10)
        }
        back1Button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        backBlockView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 28))
        }
        backView.snp.makeConstraints { make in
            make.bottom.equalTo(navigatorBar.snp.bottom).inset(7)
            make.height.equalTo(28)
            make.leading.equalTo(backStackView.snp.trailing)
            make.trailing.equalTo(searchStackView.snp.leading)
        }
        searchStackView.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalToSuperview().inset(15)
        }
        searchBlockView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 28))
        }
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(28)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.height.equalToSuperview()
        }
        textFiled.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.height.equalToSuperview()
        }
        back2Button.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
        lineView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(14)
        }
        searchView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
    }
    
    public func changeState(isChange: Bool) {
        back1Button.isHidden = !isChange
        searchButton.isHidden = !isChange
        back2Button.isHidden = isChange
        lineView.isHidden = isChange
    }

    public func loadData(_ json: JSON?) {
        let lat: Double = json?["lat"].doubleValue ?? 0
        let lng: Double = json?["lng"].doubleValue ?? 0
        let regionCenter = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lng)) // 32 118
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: regionCenter, span: regionSpan)
        mapView.setRegion(region, animated: true)
        
//        let annotion = MKPointAnnotation()
//        annotion.coordinate = regionCenter
//        mapView.addAnnotation(annotion)
    }
    func scrollViewDidScroll(contentOffsetY: CGFloat) {
        var frame = navigationBarFrame
        frame.origin.y = contentOffsetY
        navigatorBar.frame = frame
        let alpha = min(max(0, contentOffsetY), frame.size.height) / 60.0
        navigatorBar.backgroundColor =  UIColor(hex: "#1792AC").withAlphaComponent(alpha)
        changeState(isChange: alpha >  0.7)
    }
}
