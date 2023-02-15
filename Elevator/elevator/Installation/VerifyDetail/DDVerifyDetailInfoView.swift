//
//  DDVerifyDetailInfoView.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit
import SwiftyJSON

class DDVerifyDetailInfoView: UIView {
    
    private(set) lazy var numberView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Lift Number"
        $0.textField.isEnabled = false
    }
    
    private(set) lazy var brandView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Brand"
    }
    
    private(set) lazy var dateView: DDDetailButtonView = DDDetailButtonView().then {
        $0.titleLabel.text = "Lift Installation Date"
        $0.rightButton.setImage(UIImage(named: "Calendar"), for: .normal)
    }
    
    private(set) lazy var addressView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Address"
    }
    private(set) lazy var modelView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Lift Model"
    }
    private(set) lazy var planView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Maintenance Plan"
    }
    private(set) lazy var sensorView: DDDetailButtonView = DDDetailButtonView().then {
        $0.titleLabel.text = "Sensor"
        $0.rightButton.setImage(UIImage(named: "QRScan"), for: .normal)
    }
    private(set) lazy var landingView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "landings"
    }
    private(set) lazy var termView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Contract Term"
    }
    private(set) lazy var profileView: DDDetailInputView = DDDetailInputView().then {
        $0.titleLabel.text = "Description"
    }
    private(set) lazy var locationView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Location"
    }
    private(set) lazy var tenantView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Tenant"
    }
    private(set) lazy var capacityView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Person Capacity"
    }
    private(set) lazy var ropesView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "No of Ropes"
    }
    private(set) lazy var ropingView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Roping System"
    }
    private(set) lazy var doorView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Door opening"
    }
    private(set) lazy var controlView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Car Control"
    }
    private(set) lazy var codeView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Use Code"
    }
    private(set) lazy var speedView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Speed"
    }
    private(set) lazy var driveView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Drive Type"
    }
    private(set) lazy var roomView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Motor Room Location"
    }
    private(set) lazy var shaftView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Type of shaft"
    }
    private(set) lazy var zoneView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Zoning of lift"
    }
    private(set) lazy var dewingView: DDDetailInputView = DDDetailInputView().then {
        $0.titleLabel.text = "Number of dewing units(DU)"
    }
    private(set) lazy var unitView: DDDetailInputView = DDDetailInputView().then {
        $0.titleLabel.text = "Any other lifts units(DU)"
    }
    
    private(set) lazy var nextButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.setTitle("Next", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.masksToBounds = true
        layer.cornerRadius = 8
        addSubviews(numberView, brandView, dateView, addressView, modelView, planView, sensorView, landingView, termView)
        addSubviews(profileView, locationView, tenantView, capacityView, ropesView, ropingView, doorView, controlView)
        addSubviews(codeView, speedView, driveView, roomView, shaftView, zoneView, dewingView, unitView, nextButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        numberView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalToSuperview().inset(22)
            make.height.equalTo(45)
        }
        brandView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(numberView.snp.bottom)
            make.height.equalTo(45)
        }
        dateView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(brandView.snp.bottom)
            make.height.equalTo(45)
        }
        addressView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(dateView.snp.bottom)
            make.height.equalTo(45)
        }
        modelView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(addressView.snp.bottom)
            make.height.equalTo(45)
        }
        planView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(modelView.snp.bottom)
            make.height.equalTo(45)
        }
        sensorView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(planView.snp.bottom)
            make.height.equalTo(45)
        }
        
        
        landingView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(sensorView.snp.bottom)
            make.height.equalTo(45)
        }
        termView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(landingView.snp.bottom)
            make.height.equalTo(45)
        }
        profileView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(termView.snp.bottom)
            make.height.equalTo(130)
        }
        locationView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(profileView.snp.bottom)
            make.height.equalTo(45)
        }
        tenantView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(locationView.snp.bottom)
            make.height.equalTo(45)
        }
        capacityView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(tenantView.snp.bottom)
            make.height.equalTo(45)
        }
        ropesView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(capacityView.snp.bottom)
            make.height.equalTo(45)
        }
        ropingView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(ropesView.snp.bottom)
            make.height.equalTo(45)
        }
        doorView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(ropingView.snp.bottom)
            make.height.equalTo(45)
        }
        controlView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(doorView.snp.bottom)
            make.height.equalTo(45)
        }
        codeView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(controlView.snp.bottom)
            make.height.equalTo(45)
        }
        speedView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(codeView.snp.bottom)
            make.height.equalTo(45)
        }
        driveView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(speedView.snp.bottom)
            make.height.equalTo(45)
        }
        roomView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(driveView.snp.bottom)
            make.height.equalTo(45)
        }
        shaftView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(roomView.snp.bottom)
            make.height.equalTo(45)
        }
        zoneView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(shaftView.snp.bottom)
            make.height.equalTo(45)
        }
        dewingView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(zoneView.snp.bottom)
            make.height.equalTo(130)
        }
        unitView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(dewingView.snp.bottom)
            make.height.equalTo(130)
        }
        nextButton.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.top.equalTo(unitView.snp.bottom).offset(36)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().inset(25)
        }
    }
    
    public func loadData(_ json: JSON?)  {
        numberView.textField.text = json?["liftnumber"].stringValue
        brandView.textField.text = json?["brand"].stringValue
        dateView.textLabel.text = DDAppInfo.dateStr(json?["installtime"].stringValue, dateFormat: "MM/dd/yyyy")
        addressView.textField.text = json?["address"].stringValue
        modelView.textLabel.text = json?["modelname"].stringValue
        planView.textLabel.text = json?["planname"].stringValue
        sensorView.textLabel.text = json?["deviceid"].stringValue
        landingView.textLabel.text = json?[""].stringValue
        termView.textField.text = json?[""].stringValue
        profileView.textView.text = json?[""].stringValue
        locationView.textField.text = json?[""].stringValue
        tenantView.textField.text = json?[""].stringValue
        capacityView.textField.text = json?[""].stringValue
        ropesView.textField.text = json?[""].stringValue
        ropingView.textLabel.text = json?[""].stringValue
        doorView.textLabel.text = json?[""].stringValue
        controlView.textLabel.text = json?[""].stringValue
        codeView.textLabel.text = json?[""].stringValue
        speedView.textField.text = json?[""].stringValue
        driveView.textField.text = json?[""].stringValue
        roomView.textField.text = json?[""].stringValue
        shaftView.textLabel.text = json?[""].stringValue
        zoneView.textLabel.text = json?[""].stringValue
        dewingView.textView.text = json?[""].stringValue
        unitView.textView.text = json?[""].stringValue
    }
}
