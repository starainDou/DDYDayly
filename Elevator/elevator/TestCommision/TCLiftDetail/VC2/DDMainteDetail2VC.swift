//
//  DDMainteDetail2VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView
import SwiftyJSON
import ProgressHUD
import CryptoKit

class DDMainteDetail2VC: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.ddy_register(cellClass: DDMainteDetail2Header.self)
        collectionView.ddy_register(cellClass: DDMainteDetail2Cell.self)
        collectionView.layer.cornerRadius = 6
        collectionView.layer.masksToBounds = true
        return collectionView
    }()
    
    var liftBaseJson: JSON = JSON()
    
    private lazy var kpiJson: JSON = JSON()
    
    private lazy var titleArray = ["Total trips", "Total cycles",
                                   "Trips Per Day", "Total mileage",
                                   "Duty cycle", "Load per Trips",
                                   "Tensioning alarm", "Trips with rated alarm",
                                   "Trips with overload alarm", "Shaft effciency",
                                   "Trips with wrong leveling", "Door time",
                                   "Number of Door cycles per trips", "Empty car Trips",
                                   "Empty car Weight", "Rope tensionging difference percent",
                                   "Rope tensionging difference kilogram", "Energy per floor",
                                   "Energy loss per floor", "Traction"]
    
    private lazy var keyArray: [String] = ["totaltrips", "totalcycles",
                                          "avgTripsPerDay", "totalmileage",
                                          "dutyCycle", "avgLoadPerTrip",
                                          "tensionAlarms", "ratedAlarms",
                                          "overloadedAlarms", "hoistwayEffciency",
                                          "missedLeveling", "avgDoorCycleTime",
                                          "avgDoorCyclesPerTrip", "emptyCarTrips",
                                          "emptyCarWeight", "ropeTensioningDifferencePercent",
                                          "ropeTensioningDifferenceKilogram", "energyReqForAvgLoadedCarPerAvgFloor",
                                          "energyLossThroughFrictionPerAvgFloor", "traction"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex:"#F1F5FF")
        view.addSubviews(collectionView)
        setViewConstraints()
        loadData()
    }
    
    private func setViewConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15))
        }
    }
    
    private func loadData() {
        let liftNumber = liftBaseJson["liftnumber"].stringValue
        
        
//        DDGet(target: .getStatusOfLift(id: liftNumber), success: { [weak self] result, msg in
//            print("正确 \(result) \(msg ?? "NoMsg")")
//            ProgressHUD.dismiss()
//            self?.kpiJson = JSON(result)["data"]["kpis"]
//            self?.collectionView.reloadData()
//        }, failure: { [weak self] code, msg in
//            print("错误 \(code) \(msg ?? "NoMsg")")
//            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
//        })
        DDPost(target: .getKpisByLiftId(liftId: liftNumber), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            ProgressHUD.dismiss()
            self?.kpiJson = JSON(result)["data"]["kpis"]
            self?.collectionView.reloadData()
        }, failure: { [weak self] code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
    }
    
    fileprivate func loadPdf() {
        let liftNum = liftBaseJson["liftnumber"].stringValue
        let fileName = "KPI-" + liftNum + ".pdf"
        let dateVal = DDAppInfo.dateStr(DDAppInfo.timeStamp(), dateFormat: "yyyy-MM") ?? ""
        let path = DDAppInfo.ducumentPath + "/kpiNew/" + fileName
        guard !FileManager.default.fileExists(atPath: path) else { return previewPdf(path, fileName) }
        ProgressHUD.show("Downloading")
        DDDownload(target: .kpiNew(fileName: fileName, liftNumber: liftNum, dateVal: dateVal, flag: "1"), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            if FileManager.default.fileExists(atPath: path) {
                ProgressHUD.dismiss()
                self?.previewPdf(path, fileName)
            } else {
                ProgressHUD.showFailed("Fail", interaction: false, delay: 3)
            }
        }, failure: { [weak self] code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            if FileManager.default.fileExists(atPath: path) {
                ProgressHUD.dismiss()
                self?.previewPdf(path, fileName)
            } else {
                ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
            }
        })
    }
    
    fileprivate func previewPdf(_ path: String,_ fileName: String) {
        let vc = DDDocumentPreviewVC()
        vc.loadData(path, fileName)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DDMainteDetail2VC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : keyArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: DDScreen.width - 30, height: 150)
        } else {
            return CGSize(width: (DDScreen.width - 66) / 2.0, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? UIEdgeInsets.zero : UIEdgeInsets(top: 0, left: 7, bottom: 5, right: 7)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.ddy_dequeueReusableCell(DDMainteDetail2Header.self, for: indexPath)
            cell.loadData(kpiJson, action: { [weak self] in
                self?.loadPdf()
            })
            return cell
        } else {
            let cell = collectionView.ddy_dequeueReusableCell(DDMainteDetail2Cell.self, for: indexPath)
            let key = keyArray[indexPath.item]
            let title = titleArray[indexPath.item]
            cell.loadData(kpiJson[key].stringValue, title: title, key: key)
            return cell
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
}

extension DDMainteDetail2VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}


/*
 {
     "code": "200",
     "msg": "The request is successful",
     "data": {
         "kpis": {
             "deviceId": "HWW014600000076",
             "deviceType": null,
             "protocolVersion": null,
             "_id": null,
             "dataType": "statisticsElevator",
             "timestamp": null,
             "avgTripsPerDay": 281.33694,
             "rideQuality": 61.636276,
             "dutyCycle": 4.6128044,
             "avgLoadPerTrip": 0,
             "tensionAlarms": 3.4384634,
             "ratedAlarms": 0,
             "hoistwayEffciency": 100,
             "missedLeveling": 6.876927,
             "avgDoorCycleTime": 8.46589,
             "avgDoorCyclesPerTrip": 1.2452,
             "emptyCarTrips": 100,
             "avgTripsPerDayStatus": null,
             "rideQualityStatus": null,
             "dutyCycleStatus": null,
             "avgLoadPerTripStatus": null,
             "tensioningAlarmStatus": null,
             "ratedAlarmsStatus": null,
             "hoistwayEffciencyStatus": null,
             "missedLevellingStatus": null,
             "avgDoorCycleTimeStatus": null,
             "avgDoorCyclesPerTripStatus": null,
             "emptyCarTripsStatus": null,
             "emptyCarWeight": "1140",
             "emptyCarWeightStatus": null,
             "ropeTensioningDifferencePercent": "4",
             "ropeTensioningDifferenceKilogram": "5",
             "ropeTensioningDifferenceStatus": null,
             "energyReqForAvgLoadedCarPerAvgFloor": "3.484864",
             "energyReqForAvgLoadedCarPerAvgFloorStatus": null,
             "energyLossThroughFrictionPerAvgFloor": "0.0",
             "energyLossThroughFrictionPerAvgFloorStatus": null,
             "traction": "0.0",
             "tractionStatus": null,
             "overloadedAlarms": "0.0",
             "overloadedAlarmsStatus": null,
             "totaltrips": 25234,
             "totalcycles": 31657,
             "totalmileage": 391570,
             "avgSpeed": null,
             "liftnumber": null,
             "dataBackJsonStr": null,
             "sensorType": null,
             "raw": null,
             "domain": null,
             "gatewayId": null,
             "networkType": null,
             "direction": null,
             "createtime": null,
             "avgDoorCyclePerTripStatus": null,
             "protocolType": null,
             "tenantId": null,
             "time": null
         }
     }
 }
 */
