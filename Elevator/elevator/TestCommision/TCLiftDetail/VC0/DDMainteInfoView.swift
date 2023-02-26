//
//  DDMainteInfoView.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import SwiftyJSON

class DDMainteInfoView: UIView {

    private lazy var numberView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Lift Number"
    }
    private lazy var brandView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Brand"
    }
    private lazy var dateView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Lift Installation Date"
    }
    private lazy var batchView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Batchno"
    }
    private lazy var addressView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Address"
    }
    private lazy var modelView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Lift Model"
    }
    private lazy var planView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Maintenance Plan"
    }
    private lazy var sensorView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Sensor"
    }
    private lazy var landingView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "landings"
    }
    private lazy var termView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Contract Term"
    }
    private lazy var profileView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Description"
    }
    private lazy var locationView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Location"
    }
    private lazy var tenantView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Tenant"
    }
    private lazy var capacityView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Person Capacity"
    }
    private lazy var rosesView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "No of Ropes"
    }
    private lazy var ropingView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Roping System"
    }
    private lazy var doorView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Door opening"
    }
    private lazy var carView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Car Control"
    }
    private lazy var codeView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Use Code"
    }
    private lazy var speedView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Speed"
    }
    private lazy var driveView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Drive Type"
    }
    private lazy var roomView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Motor Room Location"
    }
    private lazy var councilView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Town Council"
    }
    private lazy var shaftView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Type of shaft"
    }
    private lazy var zoningView: DDMainteItemInfoView = DDMainteItemInfoView().then {
        $0.titleLabel.text = "Zoning of lift"
        $0.shapeLayer.removeFromSuperlayer()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(numberView, brandView, dateView, batchView, addressView, modelView, planView, sensorView)
        addSubviews(landingView, termView, profileView, locationView, tenantView, capacityView, rosesView, ropingView)
        addSubviews(doorView, carView, codeView, speedView, driveView, roomView, councilView, shaftView, zoningView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    private func setViewConstraints() {
        numberView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        brandView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(numberView.snp.bottom)
        }
        dateView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(brandView.snp.bottom)
        }
        batchView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(dateView.snp.bottom)
        }
        addressView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(batchView.snp.bottom)
        }
        modelView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(addressView.snp.bottom)
        }
        planView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(modelView.snp.bottom)
        }
        sensorView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(planView.snp.bottom)
        }
        landingView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sensorView.snp.bottom)
        }
        termView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(landingView.snp.bottom)
        }
        profileView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(termView.snp.bottom)
        }
        locationView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(profileView.snp.bottom)
        }
        tenantView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(locationView.snp.bottom)
        }
        capacityView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(tenantView.snp.bottom)
        }
        rosesView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(capacityView.snp.bottom)
        }
        ropingView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(rosesView.snp.bottom)
        }
        doorView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(ropingView.snp.bottom)
        }
        carView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(doorView.snp.bottom)
        }
        codeView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(carView.snp.bottom)
        }
        speedView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(codeView.snp.bottom)
        }
        driveView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(speedView.snp.bottom)
        }
        roomView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(driveView.snp.bottom)
        }
        councilView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(roomView.snp.bottom)
        }
        shaftView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(councilView.snp.bottom)
        }
        zoningView.snp .makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(shaftView.snp.bottom)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    public func loadData(_ json: JSON) {
        numberView.infoLabel.text = json["liftnumber"].stringValue
        brandView.infoLabel.text = json["brand"].stringValue
        dateView.infoLabel.text = DDAppInfo.dateStr(json["installtime"].stringValue, dateFormat: "yyyy-MM-dd")
        batchView.infoLabel.text = json["batchno"].stringValue
        addressView.infoLabel.text = json["address"].stringValue
        modelView.infoLabel.text = json["modelname"].stringValue
        planView.infoLabel.text = json["planname"].stringValue
        sensorView.infoLabel.text = json["deviceid"].stringValue
        landingView.infoLabel.text = json["landings"].stringValue
        termView.infoLabel.text = json["contractterm"].stringValue
        profileView.infoLabel.text = json["description"].stringValue
        locationView.infoLabel.text = json["location"].stringValue
        tenantView.infoLabel.text = json["tenant"].stringValue
        capacityView.infoLabel.text = json["person_capacity"].stringValue
        rosesView.infoLabel.text = json["no_of_ropes"].stringValue
        ropingView.infoLabel.text = json["roping_system"].stringValue
        doorView.infoLabel.text = json["type_of_door_opening"].stringValue
        carView.infoLabel.text = json["car_control"].stringValue
        codeView.infoLabel.text = json["use_code"].stringValue
        speedView.infoLabel.text = json["speed"].stringValue
        driveView.infoLabel.text = json["drive_type"].stringValue
        roomView.infoLabel.text = json["motor_room_location"].stringValue
        councilView.infoLabel.text = json["town_council"].stringValue
        shaftView.infoLabel.text = json["type_of_lift_shaft"].stringValue
        zoningView.infoLabel.text = json["zoning_of_lift"].stringValue
    }
}
