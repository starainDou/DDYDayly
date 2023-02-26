//
//  DDMainteStateView.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import SwiftyJSON

class DDMainteStateView: UIView {

    private lazy var carDoorView: DDMainteItemStateView = DDMainteItemStateView().then {
        $0.titleLabel.text = "Car Door"
    }
    private lazy var landingView: DDMainteItemStateView = DDMainteItemStateView().then {
        $0.titleLabel.text = "Landing Door"
    }
    private lazy var driveView: DDMainteItemStateView = DDMainteItemStateView().then {
        $0.titleLabel.text = "Driving unit"
    }
    private lazy var motorView: DDMainteItemStateView = DDMainteItemStateView().then {
        $0.titleLabel.text = "Motor"
    }
    private lazy var gearboxView: DDMainteItemStateView = DDMainteItemStateView().then {
        $0.titleLabel.text = "Gearbox"
    }
    private lazy var guidesView: DDMainteItemStateView = DDMainteItemStateView().then {
        $0.titleLabel.text = "Guides"
    }
    private lazy var carView: DDMainteItemStateView = DDMainteItemStateView().then {
        $0.titleLabel.text = "Car"
    }
    private lazy var meansView: DDMainteItemStateView = DDMainteItemStateView().then {
        $0.titleLabel.text = "Suspension means"
    }
    private lazy var deviceView: DDMainteItemStateView = DDMainteItemStateView().then {
        $0.titleLabel.text = "WEARwatcher devicce"
    }
    private lazy var breakView: DDMainteItemStateView = DDMainteItemStateView().then {
        $0.titleLabel.text = "Breakdown Probability"
        $0.stateView.isHidden = true
        $0.textLabel.isHidden = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(carDoorView, landingView, driveView, motorView, gearboxView, guidesView, carView, meansView, deviceView, breakView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    private func setViewConstraints() {
        carDoorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(42)
        }
        landingView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(carDoorView.snp.bottom)
            make.height.equalTo(42)
        }
        driveView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(landingView.snp.bottom)
            make.height.equalTo(42)
        }
        motorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(driveView.snp.bottom)
            make.height.equalTo(42)
        }
        gearboxView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(motorView.snp.bottom)
            make.height.equalTo(42)
        }
        guidesView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(gearboxView.snp.bottom)
            make.height.equalTo(42)
        }
        carView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(guidesView.snp.bottom)
            make.height.equalTo(42)
        }
        meansView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(carView.snp.bottom)
            make.height.equalTo(42)
        }
        deviceView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(meansView.snp.bottom)
            make.height.equalTo(42)
        }
        breakView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(deviceView.snp.bottom)
            make.height.equalTo(42)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    public func loadData(_ json: JSON) {
        // 11好像是灰色，2是红色，1是黑色，3是橙色，5是蓝色
        updateImg(json["liftstatus"]["cardoor"].stringValue, imgView: carDoorView.stateView)
        updateImg(json["liftstatus"]["landingdoor"].stringValue, imgView: landingView.stateView)
        updateImg(json["liftstatus"]["drivingunit"].stringValue, imgView: driveView.stateView)
        updateImg(json["liftstatus"]["motor"].stringValue, imgView: motorView.stateView)
        updateImg(json["liftstatus"]["gearbox"].stringValue, imgView: gearboxView.stateView)
        updateImg(json["liftstatus"]["guides"].stringValue, imgView: guidesView.stateView)
        updateImg(json["liftstatus"]["car"].stringValue, imgView: carView.stateView)
        updateImg(json["liftstatus"]["wearwatcherdeviceitself"].stringValue, imgView: meansView.stateView)
        updateImg(json["liftstatus"]["cardoor"].stringValue, imgView: deviceView.stateView)
        if let str = json["liftstatus"]["breakdownProbability"].string {
            breakView.textLabel.text = str + "%"
        } else {
            breakView.textLabel.text = "-"
        }
    }
    
    public func updateImg(_ tag: String, imgView: UIImageView) {
        if tag == "1" {
            imgView.image = UIImage(named: "alert_critical")
        } else if tag == "2" {
            imgView.image = UIImage(named: "alert_major")
        } else if tag == "3" {
            imgView.image = UIImage(named: "alert_minor")
        } else if tag == "4" {
            imgView.image = UIImage(named: "alert_info")
        } else if tag == "5" {
            imgView.image = UIImage(named: "alert_debug")
        } else if tag == "6" {
            imgView.image = UIImage(named: "alert_clear")
        } else if tag == "11" {
            imgView.image = UIImage(named: "alert_unkonwn")
        } else if tag == "12" {
            imgView.image = UIImage(named: "alert_ok")
        } else {
            imgView.image = UIImage(named: "Tick")
        }
    }
}
