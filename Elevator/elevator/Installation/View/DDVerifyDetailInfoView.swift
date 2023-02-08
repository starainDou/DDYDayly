//
//  DDVerifyDetailInfoView.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit

class DDVerifyDetailInfoView: UIView {
    
    private lazy var numberView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Lift Number"
    }
    
    private lazy var brandView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Brand"
    }
    
    private lazy var dateView: DDDetailButtonView = DDDetailButtonView().then {
        $0.titleLabel.text = "Lift Installation Date"
        $0.rightButton.setImage(UIImage(named: "Calendar"), for: .normal)
    }
    
    private lazy var addressView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Address"
    }
    private lazy var modelView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Lift Model"
    }
    private lazy var planView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Maintenance Plan"
    }
    private lazy var sensorView: DDDetailButtonView = DDDetailButtonView().then {
        $0.titleLabel.text = "Sensor"
        $0.rightButton.setImage(UIImage(named: "QRScan"), for: .normal)
    }
    private lazy var landingView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "landings"
    }
    private lazy var termView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Contract Term"
    }
    private lazy var profileView: DDDetailInputView = DDDetailInputView().then {
        $0.titleLabel.text = "Description"
    }
    private lazy var locationView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Location"
    }
    private lazy var tenantView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Tenant"
    }
    private lazy var capacityView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Person Capacity"
    }
    private lazy var ropesView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "No of Ropes"
    }
    private lazy var ropingView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Roping System"
    }
    private lazy var doorView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Door opening"
    }
    private lazy var controlView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Car Control"
    }
    private lazy var codeView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Use Code"
    }
    private lazy var speedView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Speed"
    }
    private lazy var driveView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Drive Type"
    }
    private lazy var roomView: DDDetailItemView = DDDetailItemView().then {
        $0.titleLabel.text = "Motor Room Location"
    }
    private lazy var shaftView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Type of shaft"
    }
    private lazy var zoneView: DDDetailMenuView = DDDetailMenuView().then {
        $0.titleLabel.text = "Zoning of lift"
    }
    private lazy var dewingView: DDDetailInputView = DDDetailInputView().then {
        $0.titleLabel.text = "Number of dewing units(DU)"
    }
    private lazy var unitView: DDDetailInputView = DDDetailInputView().then {
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
    
    public func loadData(_ model: DDLiftModel?) {
        
    }
}
