//
//  DDVerifyDetailVC.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit
import SwiftyJSON
import ProgressHUD

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
    
    public var liftJson: JSON?
    
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
    
    @objc private func nextAction() {
        let vc = DDInstallImageVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func refreshView() {
        topView.loadData(liftJson)
        mapView.loadData(liftJson)
        infoView.loadData(liftJson)
    }
    
    private func loadData() {
        guard let leftId = liftJson?["id"].stringValue else { return }
        DDPost(target: .getLiftDetail(liftId: leftId), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            self?.liftJson = JSON(result)["data"]
            self?.refreshView()
        }, failure: { code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
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
