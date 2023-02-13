//
//  DDAlertDetailVC.swift
//  elevator
//
//  Created by ddy on 2023/2/12.
//

import UIKit

class DDAlertDetailVC: UIViewController {
    
    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Alert Details"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var saveButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "FavourateLight"), for: .normal)
        $0.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    private lazy var scrollView: UIScrollView = UIScrollView()
    
    private lazy var headerView: DDAlertDetailHeader = DDAlertDetailHeader()
    
    private lazy var containerView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private lazy var stackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private lazy var dashView: DDDashLineView = DDDashLineView().then {
        $0.isHorizontal = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, scrollView)
        navigationBar.addSubview(saveButton)
        scrollView.addSubviews(headerView, containerView)
        containerView.addSubviews(dashView, stackView)
        setViewConstraints()
        loadData()
    }
    
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(6)
            make.width.height.equalTo(26)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(DDScreen.width)
            make.top.equalToSuperview().inset(15)
            make.height.equalTo(315)
        }
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(headerView.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
        }
        dashView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.top.equalToSuperview().inset(18)
            make.width.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveAction() {
        
    }
    
    private func loadData() {
        for index in 1...3 {
            let section = DDAlertDetailSection()
            section.loadData()
            stackView.addArrangedSubview(section)
            section.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.greaterThanOrEqualTo(50)
            }
        }
    }
}


extension DDAlertDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.ddy_dequeueReusableCell(DDVerifyCell.self, for: indexPath)
            //.then {
            // $0.loadData(item: dataArray[indexPath.row])
        //}
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

/*
 
 {
     "code": "200",
     "msg": "The request is successful",
     "data": {
         "_id": 6799463396035892,
         "severity": "MINOR",
         "createtime": 1658138326000,
         "message": "PEU connection to load weighing device broken",
         "description": "Alert is raised, if the connection to the PEU for load weighing has been lost",
         "deviceId": "HWW111400000502",
         "address": "100 Jurong East Street 21",
         "alarmLevel": null,
         "status": 1,
         "timestamp": 1653621553000,
         "liftnumber": "570254C",
         "brand": "CHEVALIER",
         "imgs": "",
         "files": null,
         "updateTimes": null,
         "eventTimes": null,
         "isFavourite": 0,
         "operateRecords": [
             {
                 "deviceId": "HWW111400000502",
                 "createTime": 1658138326000,
                 "severity": "MINOR",
                 "message": "PEU connection to load weighing device broken",
                 "description": "Alert is raised, if the connection to the PEU for load weighing has been lost",
                 "acknowledgeDesc": null,
                 "acknowledgedBy": "test1234567@STEE",
                 "acknowledgedUserId": 458,
                 "acknowledgedUserPortrait": "User_458.jpg",
                 "acknowledgeTime": 1658998495666,
                 "acknowledgedImgs": "1.jpg,2.jpg",
                 "updateDetails": [
                     {
                         "imgs": "lift_1658229796796.jpg,lift_1658229801626.jpg",
                         "updateby": "test9527@STEE",
                         "updateUserId": 392,
                         "userPortrait": "User_392.jpg",
                         "updatedesc": "aaasaaasaaaa",
                         "updatetime": 1658229825723,
                         "natureOfTask": "Adjustment/Replacment",
                         "component": "1100 Engine and Clutch",
                         "task": "1102 Replacement/Reworking of Engine"
                     },
                     {
                         "imgs": "lift_1658229895060.jpg,lift_1658229899546.jpg",
                         "updateby": "test9527@STEE",
                         "updateUserId": 392,
                         "userPortrait": "User_392.jpg",
                         "updatedesc": "123456789",
                         "updatetime": 1658229919218,
                         "natureOfTask": "Adjustment/Replacment",
                         "component": "1100 Engine and Clutch",
                         "task": "1102 Replacement/Reworking of Engine"
                     },
                     {
                         "imgs": "lift_1658297365312.jpg,lift_1658297368973.jpg",
                         "updateby": "qly3@STEE",
                         "updateUserId": 526,
                         "userPortrait": "User_526.jpg",
                         "updatedesc": "Test",
                         "updatetime": 1658297382816,
                         "natureOfTask": "Adjustment/Replacment",
                         "component": "1100 Engine and Clutch",
                         "task": "1102 Replacement/Reworking of Engine"
                     }
                 ],
                 "resolveDesc": null,
                 "resolvedBy": "test1234567@STEE",
                 "resolveUserId": 458,
                 "resolveUserPortrait": "User_458.jpg",
                 "resolvedTime": 1658998461090,
                 "resolvedImgs": "1.jpg,2.jpg"
             },
             {
                 "deviceId": "HWW111400000502",
                 "createTime": 1657865644656,
                 "severity": "CRITICAL",
                 "message": "PEU connection to load weighing device broken",
                 "description": "Alert is raised, if the deviation between the rope tensions reached a given threshold",
                 "acknowledgeDesc": "zzz",
                 "acknowledgedBy": "qly3@STEE",
                 "acknowledgedUserId": 526,
                 "acknowledgedUserPortrait": "User_526.jpg",
                 "acknowledgeTime": 1658917022863,
                 "acknowledgedImgs": null,
                 "updateDetails": null,
                 "resolveDesc": null,
                 "resolvedBy": null,
                 "resolveUserId": null,
                 "resolveUserPortrait": null,
                 "resolvedTime": null,
                 "resolvedImgs": null
             }
         ]
     }
 }
 
 */