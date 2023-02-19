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
        
    }
}
