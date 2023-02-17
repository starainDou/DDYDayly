//
//  DDVerifyDetailVC.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit
import SwiftyJSON
import ProgressHUD
import CoreLocation
import MapKit
import CoreAudioTypes
import DDYSwiftyExtension

class DDVerifyDetailVC: UIViewController {

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Verify Lift Details"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var scrollView: UIScrollView = UIScrollView()
    
    private lazy var topView: DDVerifyDetailTopView = DDVerifyDetailTopView()
    
    private lazy var mapView: DDVerifyDetailMapView = DDVerifyDetailMapView()
    
    private lazy var infoView: DDVerifyDetailInfoView = DDVerifyDetailInfoView().then {
        $0.nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }
    
    public var sensorJson: JSON?
    public var liftBaseJson: JSON?
    public var liftJson: JSON?
    
    public var liftModelList: [JSON]?
    public var planList: [JSON]?
    
    private lazy var locationManager = CLLocationManager().then {
        $0.delegate = self
        $0.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        $0.distanceFilter = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, scrollView)
        scrollView.addSubviews(topView, mapView, infoView)
        setViewConstraints()
        setClosure()
        loadData()
    }
    
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
        topView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
            make.width.equalTo(DDScreen.width - 30)
            make.height.equalTo(123)
        }
        mapView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(223)
            make.top.equalTo(topView.snp.bottom).offset(10)
        }
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(35)
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func refreshView() {
        topView.loadData(liftJson)
        mapView.loadData(liftJson)
        infoView.json = liftJson
    }
    
    private func loadData() {
        guard let leftId = liftBaseJson?["id"].stringValue else { return }
        DDPost(target: .getLiftDetail(liftId: leftId), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            self?.liftJson = JSON(result)["data"]
            if self?.liftJson?["deviceid"].string == nil, let deviceid = self?.sensorJson?["deviceId"].string {
                self?.liftJson?["deviceid"].string = deviceid
            }
            self?.refreshView()
            self?.loadLiftModels()
        }, failure: { code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
    }
    
    private func loadLiftModels(_ completion: ((Bool) -> Void)? = nil) {
        guard let modelId = liftJson?["modelid"].string else {
            completion?(false)
            return
        }
        DDPost(target: .getLiftModelList(page: "1", limit: "20", modelId: modelId), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            self?.liftModelList = JSON(result)["data"]["rows"].arrayValue
            completion?(true)
        }, failure: { code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            completion?(false)
        })
    }
    private func loadPlans(_ completion: ((Bool) -> Void)? = nil) {
        guard let planId = liftJson?["planid"].string else {
            completion?(false)
            return
        }
        DDPost(target: .getPlanList(page: "1", limit: "20", planId: planId), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            self?.planList = JSON(result)["data"]["rows"].arrayValue
            completion?(true)
        }, failure: { code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            completion?(false)
        })
    }
    /*
     addSubviews(numberView, brandView, dateView, addressView, modelView, planView, sensorView, landingView, termView)
     addSubviews(profileView, locationView, tenantView, capacityView, ropesView, ropingView, doorView, controlView)
     addSubviews(codeView, speedView, driveView, roomView, shaftView, zoneView, dewingView, unitView, nextButton)
     */
    private func setClosure() {
        mapView.locationButton.addTarget(self, action: #selector(locationAction), for: .touchUpInside)
        infoView.dateView.rightButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        infoView.modelView.rightButton.addTarget(self, action: #selector(showLiftModelList), for: .touchUpInside)
        infoView.planView.rightButton.addTarget(self, action: #selector(showPlanList), for: .touchUpInside)
        infoView.sensorView.rightButton.addTarget(self, action: #selector(scanQRCode), for: .touchUpInside)
        infoView.landingView.rightButton.addTarget(self, action: #selector(labelAction), for: .touchUpInside)
        infoView.ropingView.rightButton.addTarget(self, action: #selector(ropingSystem), for: .touchUpInside)
        infoView.doorView.rightButton.addTarget(self, action: #selector(doorOpening), for: .touchUpInside)
        infoView.controlView.rightButton.addTarget(self, action: #selector(carControl), for: .touchUpInside)
        infoView.codeView.rightButton.addTarget(self, action: #selector(useCode), for: .touchUpInside)
        infoView.shaftView.rightButton.addTarget(self, action: #selector(typeOfShaft), for: .touchUpInside)
        infoView.zoneView.rightButton.addTarget(self, action: #selector(zoningOfLift), for: .touchUpInside)
    }
}

extension DDVerifyDetailVC: CLLocationManagerDelegate {
    @objc private func locationAction() {
        let authState: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authState = locationManager.authorizationStatus
        } else {
            authState = CLLocationManager.authorizationStatus()
        }
        switch authState {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            ProgressHUD.showFailed("Please open the location authorization in system setting", interaction: false, delay: 3)
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.startUpdatingLocation()
        @unknown default:
            ProgressHUD.showFailed("Location failed", interaction: false, delay: 3)
        }
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAction()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let coordinate = locations.first?.coordinate else { return }
        liftJson?["lat"].double = coordinate.latitude.ddy_round(6)
        liftJson?["lng"].double = coordinate.longitude.ddy_round(6)
        refreshView()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ProgressHUD.showFailed("Location failed", interaction: false, delay: 3)
    }
}

extension DDVerifyDetailVC {
    @objc fileprivate func showDatePicker() {
        DDDatePicker.show(in: view, sure: { [weak self] time in
            self?.liftJson?["installtime"].string = time
            self?.refreshView()
        })
    }
    @objc fileprivate func showLiftModelList() {
        func showView(_ list: [JSON]) {
            let array = list.compactMap { $0["modelname"].stringValue }
            DDListView.show(in: view, array: array) { [weak self] selectStr, index in
                self?.liftJson?["modelname"].string = selectStr
                self?.refreshView()
            }
        }
        if let list = liftModelList, !list.isEmpty {
            showView(list)
        } else {
            loadLiftModels { [weak self] result in
                if result, let list = self?.liftModelList, !list.isEmpty {
                    showView(list)
                } else {
                    ProgressHUD.showFailed("Request lift model list failed", interaction: false, delay: 3)
                }
            }
        }
    }
    
    @objc fileprivate func showPlanList() {
        func showView(_ list: [JSON]) {
            let array = list.compactMap { $0["planname"].stringValue }
            DDListView.show(in: view, array: array) { [weak self] selectStr, index in
                self?.liftJson?["planname"].string = selectStr
                self?.refreshView()
            }
        }
        if let list = planList, !list.isEmpty {
            showView(list)
        } else {
            loadPlans { [weak self] result in
                if result, let list = self?.planList, !list.isEmpty {
                    showView(list)
                } else {
                    ProgressHUD.showFailed("Request plan list failed", interaction: false, delay: 3)
                }
            }
        }
    }
    
    @objc fileprivate func scanQRCode() {
        let vc = DDQRCodeVC()
        vc.scanBlock = { [weak self] (json) in
            self?.liftJson?["deviceid"].string = json["deviceid"].stringValue
            self?.refreshView()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func labelAction() {
        guard let labelmapping = liftJson?["labelmapping"].stringValue else { return }
        let labels = JSON(parseJSON: labelmapping).arrayValue.compactMap { $0["label"].stringValue }
        var selectIndex = 0
        if let landing = liftJson?["landings"].stringValue, let index = labels.firstIndex(of: landing) {
            selectIndex = index
        }
        let vc = DDLabelVC()
        vc.loadData(labels, index: selectIndex)
        vc.selectBlock = { [weak self] (landings) in
            self?.liftJson?["landings"].string = landings
            self?.refreshView()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func ropingSystem() {
        let array = ["1:1", "2:1", "4:1"]
        DDListView.show(in: view, array: array) { [weak self] selectStr, index in
            self?.liftJson?["roping_system"].string = selectStr
            self?.refreshView()
        }
    }
    
    @objc fileprivate func doorOpening() {
        let array = ["Front Only - Side Opening",
                     "Front Only - Center Opening",
                     "2 doors - Side Opening",
                     "2 doors - Center Opening",
                     "3 doors - Side Opening",
                     "3 doors - Center Opening"]
        DDListView.show(in: view, array: array) { [weak self] selectStr, index in
            self?.liftJson?["door_opening"].string = selectStr
            self?.refreshView()
        }
    }
    
    @objc fileprivate func carControl() {
        let array = ["Simplex", "Duplex", "Multiple"]
        DDListView.show(in: view, array: array) { [weak self] selectStr, index in
            self?.liftJson?["car_control"].string = selectStr
            self?.refreshView()
        }
    }
    
    @objc fileprivate func useCode() {
        let array = ["Passenger", "Cargo", "Fireman", "Others"]
        DDListView.show(in: view, array: array) { [weak self] selectStr, index in
            self?.liftJson?["use_code"].string = selectStr
            self?.refreshView()
        }
    }
    
    @objc fileprivate func typeOfShaft() {
        let array = ["Reinforced Concrete", "Steel", "Shaftless", "Internal"]
        DDListView.show(in: view, array: array) { [weak self] selectStr, index in
            self?.liftJson?["type_of_lift_shaft"].string = selectStr
            self?.refreshView()
        }
    }
    
    @objc fileprivate func zoningOfLift() {
        let array = ["High zone", "Low zone", "One zone"]
        DDListView.show(in: view, array: array) { [weak self] selectStr, index in
            self?.liftJson?["zoning_of_lift"].string = selectStr
            self?.refreshView()
        }
    }
    
    @objc fileprivate func nextAction() {
        guard (liftJson?["deviceid"].string) != nil else {
            ProgressHUD.showFailed("Please input sensor", interaction: false , delay: 3)
            return
        }
        let vc = DDBeforeInstallVC()
        vc.liftJson = liftJson
        navigationController?.pushViewController(vc, animated: true)
    }
}

/*
 {
     code = 200;
     data =     {
         address = "Mairie de Chessy, Avenue Thibaud de Champagne, Chessy, Torcy, Seine-et-Marne, Ile-de-France, Metropolitan France, 77700, France";
         agecolor = "<null>";
         "any_other_lift_serving_these_du" = "<null>";
         "any_other_lifts_units" = "<null>";
         "aps_install_place" = "<null>";
         "aps_location" = "<null>";
         "aps_placement_location" = "<null>";
         base64Img = "<null>";
         batchno = LN00012;
         block = "<null>";
         brand = LN00012;
         brandcolor = "<null>";
         breakdownprobability = "<null>";
         capacity = "<null>";
         "car_control" = "<null>";
         component = "<null>";
         componenttype = "<null>";
         comstatus = "<null>";
         contractterm = 22;
         createtime = 1568888363000;
         "cross_beam_type" = "<null>";
         dashboardLiftAlarm = "<null>";
         description = 22;
         "device_status" = "<null>";
         deviceid = "<null>";
         deviceids = "<null>";
         "door_current_sensor" = "<null>";
         "door_opening" = "<null>";
         doorcurrentsensorinstallationmethod = "<null>";
         doormotortype = "<null>";
         "drive_type" = "<null>";
         floor = "<null>";
         fromDate = "<null>";
         id = 87286631d6ca4e688b012cd9cee7b734;
         installtime = 1568830740000;
         labelmapping = "[{\"label\":\"1\"},{\"label\":\"2\"},{\"label\":\"3\"},{\"label\":\"4\"}]";
         landings = 4;
         "last_replaced_by" = "<null>";
         "last_replaced_date" = "<null>";
         lastmaintenancetime = "<null>";
         lastupdatetime = 1638893266763;
         lat = "48.878767";
         liftName = "<null>";
         liftState = "<null>";
         liftState2 = "<null>";
         "lift_code" = "<null>";
         "lift_company" = "<null>";
         "lift_installation_date" = "<null>";
         "lift_model" = "<null>";
         "lift_shaft_type" = "<null>";
         "lift_type" = "<null>";
         liftage = "<null>";
         liftalarmstatus = "<null>";
         liftnumber = LN00012;
         liftstatus = "<null>";
         lng = "2.766571";
         location = "<null>";
         locationid = 2989e794e17341edb2345781e90b6699;
         "lpms_commission_date" = "<null>";
         "lpms_status" = "<null>";
         "maintenance_status" = "<null>";
         minscheduletype = "<null>";
         modelid = 108a6a70a27848f983e2b8c59dc3a877;
         modelname = "1\U5feb\U5feb\U5feb";
         "motor_room_location" = "<null>";
         "mpu_placement_method" = "<null>";
         mpuplacementlocation = "<null>";
         nextmaintenancetime = 1576655999000;
         "no_of_ropes" = "<null>";
         "number_of_dwelling_units" = "<null>";
         "number_of_dwelling_units_served" = "<null>";
         "number_of_landings_served" = "<null>";
         "person_capacity" = "<null>";
         "peu_power_source" = "<null>";
         plandescription = "<null>";
         planid = 0bf49399c6ad4485ba25182cabb9f7d1;
         planname = "Sample maintenance plan2";
         "postal_code" = "<null>";
         "power_source_to_peu" = "<null>";
         regionid = "<null>";
         regionidforsub = "<null>";
         regionname = "<null>";
         "rope_sensor_type" = "<null>";
         ropesensor = "<null>";
         ropesensortype = "<null>";
         "roping_system" = "<null>";
         sensors = "<null>";
         serialnumber = "<null>";
         showcolor = "<null>";
         speed = "<null>";
         status = 3;
         statuslevel = "<null>";
         storey = "<null>";
         street = "<null>";
         tenant = "<null>";
         toDate = "<null>";
         "town_council" = "<null>";
         "type_of_door_opening" = "<null>";
         "type_of_lift_shaft" = "<null>";
         "type_of_rope_sensor" = "<null>";
         "use_code" = "<null>";
         userid = "<null>";
         ward = "<null>";
         "zoning_of_lift" = "<null>";
     };
     msg = "The request is successful";
 }
 */
