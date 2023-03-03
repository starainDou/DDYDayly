//
//  DDMainteDetail0VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView
import SwiftyJSON
import ProgressHUD

class DDMainteDetail0VC: UIViewController {
    
    private lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator  = false
        $0.keyboardDismissMode = .onDrag
    }

    private lazy var headerView: DDMainteHeaderView = DDMainteHeaderView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    private lazy var stateView: DDMainteStateView = DDMainteStateView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    private lazy var infoView: DDMainteInfoView = DDMainteInfoView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    private lazy var mapView: DDMainteMapView = DDMainteMapView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    var liftBaseJson: JSON = JSON()
    
    private var stateJson: JSON = JSON()
    
    private var liftDetailJson: JSON = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubview(scrollView)
        scrollView.addSubviews(headerView, stateView, infoView, mapView)
        setViewConstraints()
        loadData()
    }
    
    private func setViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.width.equalTo(DDScreen.width - 30)
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(123)
        }
        stateView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(headerView.snp.bottom).offset(10)
        }
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(stateView.snp.bottom).offset(10)
        }
        mapView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(infoView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(mapView.snp.width).dividedBy(2)
        }
    }
    
    private func refreshUI() {
        headerView.loadData(stateJson, baseJson: liftBaseJson)
        stateView.loadData(stateJson)
        infoView.loadData(liftDetailJson)
        mapView.loadData(liftDetailJson)
    }
    private func loadData() {
        //getStatusOfLift
        // getLiftStatus
        let liftNumber = liftBaseJson["liftnumber"].stringValue
        let leftId = liftBaseJson["id"].stringValue
        guard let userId = DDShared.shared.json?["user"]["id"].stringValue else { return }
        
//        
//        DDGet(target: .getStatusOfLift(id: liftNumber), success: { [weak self] result, msg in
//            print("正确 \(result) \(msg ?? "NoMsg")")
//            
//        }, failure: { [weak self] code, msg in
//            print("错误 \(code) \(msg ?? "NoMsg")")
//        
//        })
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.ddy.serialQueue")
        ProgressHUD.show(interaction: false)
        group.enter()
        queue.async {
            DDPost(target: .getLiftStatus(liftnumber: liftNumber, userid: userId), success: { [weak self] result, msg in
                print("正确 \(result) \(msg ?? "NoMsg")")
                self?.stateJson = JSON(result)["data"]
                group.leave()
            }, failure: { code, msg in
                print("错误 \(code) \(msg ?? "NoMsg")")
                group.leave()
            })
        }
        queue.async {
            DDPost(target: .getLiftDetail(liftId: leftId), success: { [weak self] result, msg in
                print("正确 \(result) \(msg ?? "NoMsg")")
                let json = JSON(result)["data"]
                self?.liftDetailJson = json
            }, failure: { code, msg in
                print("错误 \(code) \(msg ?? "NoMsg")")
            })
        }
        
        group.notify(queue: .main) {
            ProgressHUD.dismiss()
            self.refreshUI()
        }
        
        
//        DDGet(target: .getStatusOfLift(id: liftNumber), success: { [weak self] result, msg in
//            print("正确 \(result) \(msg ?? "NoMsg")")
//            ProgressHUD.dismiss()
//        }, failure: { [weak self] code, msg in
//            print("错误 \(code) \(msg ?? "NoMsg")")
//            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
//        })
        
        
    }
}


extension DDMainteDetail0VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

/*
 {
     code = 200;
     data =     {
         alarmdays = 7;
         breakdownProbability = 0;
         commissionDate = 1675995636113;
         lastSingleride = "<null>";
         liftlastdata =         {
             comstatus = 1;
             lasttime = 1665457320000000;
             status = Online;
         };
         liftstatus =         {
             breakdownProbability = "<null>";
             car = 7;
             cardoor = 7;
             drivingunit = 7;
             gearbox = 7;
             guides = 7;
             landingdoor = 7;
             motor = 7;
             suspensionsmeans = 7;
             wearwatcherdeviceitself = 7;
         };
         liveData =         {
             "_id" = 601591440275435;
             createtime = 1649387888204;
             currentFloor = "<null>";
             dataType = liveData;
             deviceId = "<null>";
             deviceType = "<null>";
             doorState = "<null>";
             protocolVersion = "<null>";
             rideState = "<null>";
         };
         loadData =         {
             "_id" = 3394749315256644;
             createtime = 1649387888204;
             currentPayload = "2.003926";
             dataType = liveData;
             deviceId = "<null>";
             deviceType = "<null>";
             protocolVersion = "<null>";
             timestamp = "2021-04-29T02:46:24Z";
             totalCarWeight = 0;
         };
         ropesensor = 1;
         sensorStatus = 5;
     };
     msg = "The request is successful";
 }
 */
