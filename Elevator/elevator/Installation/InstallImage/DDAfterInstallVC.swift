//
//  DDAfterInstallVC.swift
//  elevator
//
//  Created by ddy on 2023/2/17.
//

import UIKit
import SwiftyJSON
import ProgressHUD
import Then
import Kingfisher

class DDAfterInstallVC: UIViewController {
    
    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Before Installation"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.itemSize = CGSize(width: (DDScreen.width - 50) / 2.0, height: (DDScreen.width - 70) / 2.0 + 75)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.ddy_register(cellClass: DDInstallImageCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        collectionView.ddy_registerSectionHeader(header: DDInstallImageSectionHeader.self)
        collectionView.ddy_registerSectionFooter(footer: DDInstallImageSectionFooter.self)
        return collectionView
    }()
    
    var liftJson: JSON?
    
    private lazy var dataArray: [JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, collectionView)
        setViewConstraints()
        loadData()
    }

    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom).offset(10)
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmAction() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.ddy.serialQueue")
        ProgressHUD.show(interaction: false)
        for section in dataArray {
            for json in section["items"].arrayValue {
                if let data = DDShared.shared.liftImage(cacheKey(json))?.jpegData(compressionQuality: 0.7) {
                    group.enter()
                    queue.async {
                        self.uploadImages(group: group, data: data, name: UUID().uuidString, json: json)
                    }
                }
            }
        }
        group.notify(queue: .main) {
            ProgressHUD.dismiss()
            self.saveInfo()
        }
    }
    
    private func uploadImages(group: DispatchGroup, data: Data, name: String, json: JSON) {
        DDUpload(target: .uploadImageOfLift(data, name), success: { [weak self] result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            self?.saveMessage(group: group, name: name, json: json)
        }, failure: { code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            group.leave()
        })
    }
    
    private func saveMessage(group: DispatchGroup, name: String, json: JSON) {
        let id = liftJson?["liftId"].stringValue ?? " "
        let type = json["type"].stringValue
        let subType = json["subType"].stringValue
        let liftNumber = json["liftnumber"].stringValue
        let profile = DDShared.shared.liftProfile(cacheKey(json)) ?? " "
        let before = json["before"].stringValue
        DDPost(target: .saveMessageOfImage(id: id, type: type, subType: subType, liftNumber: liftNumber, fileName: name, description: profile, before: before), success: { result, msg in
            print("正确 \(result) \(msg ?? "NoMsg")")
            group.leave()
        }, failure: { code, msg in
            print("错误 \(code) \(msg ?? "NoMsg")")
            group.leave()
        })
    }
    
    private func saveInfo() {
        let vc = DDAfterInstallVC()
        vc.liftJson = liftJson
        if let firstVC = navigationController?.viewControllers.first {
            navigationController?.setViewControllers([firstVC, vc], animated: true)
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func loadData() {
        var general = JSON(["title": "General", "items": []])
        general["items"].arrayObject?.append(JSON(["type":"0", "subType":"0", "before":"1", "title": "Landing Floor with Safety Barricade"]))
        general["items"].arrayObject?.append(JSON(["type":"0", "subType":"0", "before":"0", "title": "Landing Floor with Safety Barricade(After)"]))
        general["items"].arrayObject?.append(JSON(["type":"0", "subType":"1", "before":"1", "title": "Lift Button Panel"]))
        general["items"].arrayObject?.append(JSON(["type":"0", "subType":"1", "before":"0", "title": "Lift Button Panel(After)"]))
        
        var carTop = JSON(["title": "Car Top", "items": []])
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"0", "before":"1", "title": "Car Top"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"0", "before":"0", "title": "Car Top(After)"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"1", "before":"1", "title": "Main Processing Unit"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"1", "before":"0", "title": "Main Processing Unit(After)"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"2", "before":"1", "title": "4G Antenna"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"2", "before":"0", "title": "4G Antenna(After)"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"3", "before":"1", "title": "Gang Switch(Car TOP)"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"3", "before":"0", "title": "Gang Switch(Car TOP)(After)"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"4", "before":"1", "title": "PEU(s)(Car Top)"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"4", "before":"0", "title": "PEU(s)(Car Top)(After)"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"5", "before":"1", "title": "APS Unit"]))
        carTop["items"].arrayObject?.append(JSON(["type":"1", "subType":"5", "before":"0", "title": "APS Unit(After)"]))
        
        var carDoor1 = JSON(["title": "Car Door(2 doors-center opening)\nCar Door1", "items": []])
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"0", "before":"1", "title": "Door 1(Before)"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"0", "before":"0", "title": "Door 1(Before)(After)"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"1", "before":"1", "title": "Door 1 Right Panel Open Switch"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"1", "before":"0", "title": "Door 1 Right Panel Open Switch(After)"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"2", "before":"1", "title": "Door 1 Right Panel Close Switch"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"2", "before":"0", "title": "Door 1 Right Panel Close Switch(After)"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"3", "before":"1", "title": "Door 1 Left Panel Open Switch"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"3", "before":"0", "title": "Door 1 Left Panel Open Switch(After)"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"4", "before":"1", "title": "Door 1 Left Panel Close Switch"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"4", "before":"0", "title": "Door 1 Left Panel Close Switch(After)"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"5", "before":"1", "title": "Door1 Current Sensor"]))
        carDoor1["items"].arrayObject?.append(JSON(["type":"2", "subType":"5", "before":"0", "title": "Door1 Current Sensor(After)"]))
        
        var carDoor2 = JSON(["title": "Car Door2", "items": []])
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"0", "before":"1", "title": "Door 2(Before)"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"0", "before":"0", "title": "Door 2(Before)(After)"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"1", "before":"1", "title": "Door 2 Right Panel Open Switch"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"1", "before":"0", "title": "Door 2 Right Panel Open Switch(After)"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"2", "before":"1", "title": "Door 2 Right Panel Close Switch"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"2", "before":"0", "title": "Door 2 Right Panel Close Switch(After)"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"3", "before":"1", "title": "Door 2 Left Panel Open Switch"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"3", "before":"0", "title": "Door 2 Left Panel Open Switch(After)"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"4", "before":"1", "title": "Door 2 Left Panel Close Switch"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"4", "before":"0", "title": "Door 2 Left Panel Close Switch(After)"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"5", "before":"1", "title": "Door2 Current Sensor"]))
        carDoor2["items"].arrayObject?.append(JSON(["type":"3", "subType":"5", "before":"0", "title": "Door2 Current Sensor(After)"]))
        
        var shaftTop = JSON(["title": "Shaft Top / Machine Room", "items": []])
        shaftTop["items"].arrayObject?.append(JSON(["type":"4", "subType":"0", "before":"1", "title": "Shaft Top (Before)"]))
        shaftTop["items"].arrayObject?.append(JSON(["type":"4", "subType":"0", "before":"0", "title": "Shaft Top (Before)(After)"]))
        shaftTop["items"].arrayObject?.append(JSON(["type":"4", "subType":"0", "before":"1", "title": "PEU(s)(Shaft Top)"]))
        shaftTop["items"].arrayObject?.append(JSON(["type":"4", "subType":"0", "before":"0", "title": "PEU(s)(Shaft Top)(After)"]))
        shaftTop["items"].arrayObject?.append(JSON(["type":"4", "subType":"0", "before":"1", "title": "Gang Switch (Shaft Top)"]))
        shaftTop["items"].arrayObject?.append(JSON(["type":"4", "subType":"0", "before":"0", "title": "Gang Switch (Shaft Top)(After)"]))
        shaftTop["items"].arrayObject?.append(JSON(["type":"4", "subType":"0", "before":"1", "title": "Rope Sensors (Car Top)"]))
        shaftTop["items"].arrayObject?.append(JSON(["type":"4", "subType":"0", "before":"0", "title": "Rope Sensors (Car Top)(After)"]))
        shaftTop["items"].arrayObject?.append(JSON(["type":"4", "subType":"0", "before":"1", "title": "Motor Current Sensor"]))
        shaftTop["items"].arrayObject?.append(JSON(["type":"4", "subType":"0", "before":"0", "title": "Motor Current Sensor(After)"]))
        
        var apsBracket = JSON(["title": "APS Bracket", "items": []])
        apsBracket["items"].arrayObject?.append(JSON(["type":"5", "subType":"0", "before":"1", "title": "APS Bracket (Shaft Top)"]))
        apsBracket["items"].arrayObject?.append(JSON(["type":"5", "subType":"0", "before":"0", "title": "APS Bracket (Shaft Top)(After)"]))
        apsBracket["items"].arrayObject?.append(JSON(["type":"5", "subType":"1", "before":"1", "title": "APS Bracket (Shaft Bottom)"]))
        apsBracket["items"].arrayObject?.append(JSON(["type":"5", "subType":"1", "before":"0", "title": "APS Bracket (Shaft Bottom)(After)"]))
        
        var additional = JSON(["title": "Additional Images", "items": []])
        additional["items"].arrayObject?.append(JSON(["type":"6", "subType":"0", "before":"1", "title": "Free Text"]))
        additional["items"].arrayObject?.append(JSON(["type":"6", "subType":"0", "before":"0", "title": "Free Text(After)"]))
        
        dataArray = [general, carTop, carDoor1, carDoor2, shaftTop, apsBracket, additional]
        collectionView.reloadData()
    }
}

extension DDAfterInstallVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray[section]["items"].arrayValue.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: DDScreen.width - 30, height: (section == 2 ? 66 : 46))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == dataArray.count - 1 {
            return CGSize(width: DDScreen.width - 30, height: 80)
        } else {
            return CGSize.zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.ddy_dequeueReusableHeader(DDInstallImageSectionHeader.self, for: indexPath)
            header.titleLabel.text = dataArray[indexPath.section]["title"].stringValue
            return header
        } else if (kind == UICollectionView.elementKindSectionFooter && indexPath.section == 6) {
            let footer = collectionView.ddy_dequeueReusableFooter(DDInstallImageSectionFooter.self, for: indexPath)
            footer.confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
            return footer
        }
        return UICollectionReusableView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.ddy_dequeueReusableCell(DDInstallImageCell.self, for: indexPath)
        let json = dataArray[indexPath.section]["items"].arrayValue[indexPath.item]
        cell.load(json: json, cacheKey: cacheKey(json))
        cell.actionBlock = { [weak self] (action) in
            if action == .delete {
                self?.deleteAction(json: json)
            } else {
                self?.takeAction(json: json)
            }
        }
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    private func deleteAction(json: JSON) {
        let cacheKey = cacheKey(json)
        DDShared.shared.saveLift(image: nil, key: cacheKey)
        DDShared.shared.saveLift(profile: nil, key: cacheKey)
        collectionView.reloadData()
    }
    
    private func takeAction(json: JSON) {
        let vc = DDImageEditVC()
        let cacheKey = cacheKey(json)
        vc.load(image: DDShared.shared.liftImage(cacheKey))
        vc.load(profile: DDShared.shared.liftProfile(cacheKey))
        vc.takeBlock = { [weak self] (img, profile) in
            DDShared.shared.saveLift(image: img, key: cacheKey)
            DDShared.shared.saveLift(profile: profile, key: cacheKey)
            self?.collectionView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func cacheKey(_ json: JSON) -> String {
        let liftId = liftJson?["liftnumber"].string ?? ""
        let key = liftId + "_" + json["before"].stringValue + "_" + json["type"].stringValue + "_" + json["subType"].stringValue
        return "key" + (DDAppInfo.md5(key) ?? key)
    }
}
