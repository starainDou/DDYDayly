//
//  DDAlertUpdateVC.swift
//  elevator
//
//  Created by ddy on 2023/2/13.
//

import UIKit
import SwiftyJSON
import ProgressHUD
import ZLPhotoBrowser
import DDYSwiftyExtension
import IQKeyboardManagerSwift

class DDAlertUpdateVC: UIViewController {

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Update"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }
    
    private lazy var backView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private lazy var photo1View: DDAlertImageView = DDAlertImageView().then {
        $0.vc = self
    }
    
    private lazy var photo2View: DDAlertImageView = DDAlertImageView().then {
        $0.vc = self
    }
    
    private lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
        $0.text = "Resolved category"
    }
    
    private lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [remark1View, remark2View, remark3View]).then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    private lazy var remark1View: DDAlertSelectView = DDAlertSelectView().then  {
        $0.textLabel.text = "Nature of task"
        $0.arrowButton.addTarget(self, action: #selector(remark1Action), for: .touchUpInside)
        //$0.isHidden = true
    }
    
    private lazy var remark2View: DDAlertSelectView = DDAlertSelectView().then  {
        $0.textLabel.text = "Compaonent"
        $0.arrowButton.addTarget(self, action: #selector(remark2Action), for: .touchUpInside)
        $0.isHidden = true
    }
    
    private lazy var remark3View: DDAlertSelectView = DDAlertSelectView().then  {
        $0.textLabel.text = "Task"
        $0.arrowButton.addTarget(self, action: #selector(remark3Action), for: .touchUpInside)
        $0.isHidden = true
    }
    
    private lazy var grayView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F3F3F3")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private lazy var textView: IQTextView = IQTextView().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#F3F3F3")
        $0.placeholder = "Please Input Description"
    }
    
    private lazy var submitView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    private lazy var submitButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.setTitle("Submit", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
    var baseJson: JSON = JSON()
    
    var alarmState: Int = 0 // 1：ack,2:resolve,3:update
    
    var remark1Array: [JSON] = []
    var remark1SelectJson: JSON = JSON()
    var remark2Array: [JSON] = []
    var remark2SelectJson: JSON = JSON()
    var remark3Array: [JSON] = []
    var remark3SelectJson: JSON = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, scrollView, submitView, submitButton)
        scrollView.addSubviews(backView)
        backView.addSubviews(photo1View, photo2View, titleLabel, stackView, grayView, textView)
        setViewConstraints()
        loadRemark(row: 1, id: "0")
        configPhotoPicker()
    }
    
    private func setViewConstraints() {
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalTo(submitView.snp.top)
        }
        backView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        }
        photo1View.snp.makeConstraints { make in
            make.width.height.equalTo((DDScreen.width - 70) / 2)
            make.top.equalToSuperview().inset(19)
            make.leading.equalToSuperview().inset(15)
        }
        photo2View.snp.makeConstraints { make in
            make.leading.equalTo(photo1View.snp.trailing).offset(10)
            make.width.height.equalTo((DDScreen.width - 70) / 2)
            make.top.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(15)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(photo1View.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
        remark1View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        remark2View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        remark3View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        grayView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(19)
            make.height.equalTo(155)
            make.bottom.equalToSuperview().inset(40)
        }
        textView.snp.makeConstraints { make in
            make.edges.equalTo(grayView).inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        submitView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(62)
        }
        submitButton.snp.makeConstraints { make in
            make.center.equalTo(submitView)
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func remark1Action() {
        showList(row: 1, parentID: "0", jsonArray: remark1Array)
    }
    
    @objc private func remark2Action() {
        showList(row: 2, parentID: remark1SelectJson["id"].stringValue, jsonArray: remark2Array)
    }
    
    @objc private func remark3Action() {
        showList(row: 3, parentID: remark2SelectJson["id"].stringValue, jsonArray: remark3Array)
    }
    
    @objc private func submitAction() {
        guard let userId = DDShared.shared.json?["user"]["id"].stringValue else { return }
        guard let remark1Str = remark1SelectJson["name"].string, !remark1Str.isEmpty else {
            ProgressHUD.showFailed("Please select Nature of task", interaction: false, delay: 3)
            return
        }
        guard let remark2Str = remark2SelectJson["name"].string, !remark2Str.isEmpty else {
            ProgressHUD.showFailed("Please select Component", interaction: false, delay: 3)
            return
        }
        guard let remark3Str = remark3SelectJson["name"].string, !remark3Str.isEmpty else {
            ProgressHUD.showFailed("Please select Task", interaction: false, delay: 3)
            return
        }
        guard let desc = textView.text, !desc.isEmpty else {
            ProgressHUD.showFailed("Please Input Description", interaction: false, delay: 3)
            return
        }
        guard let image1 = photo1View.fileName, let image2 = photo2View.fileName else {
            ProgressHUD.showFailed("Please take photos", interaction: false, delay: 3)
            return
        }
        let images = image1 + "," + image2
        let id = baseJson["_id"].stringValue
        ProgressHUD.show(interaction: false)
        DDPost(target: .updateStatusOfAlarm(userid: userId, id: id, status: "\(alarmState)", desc: desc, natureOfTask: remark1Str, component: remark2Str, task: remark3Str, images: images), success: { [weak self] result, msg in
            ProgressHUD.showSuccess("Success")
            self?.backAction()
        }, failure: { code, msg in
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
    }
    
    private func loadRemark(row: Int, id: String, completion: (([JSON]?) -> Void)? = nil) {
        ProgressHUD.show(interaction: false)
        DDGet(target: .getAlarmRemark(parentId: id), success: { [weak self] result, msg in
            ProgressHUD.dismiss()
            let list = JSON(result)["data"].arrayValue
            if row == 1 {
                self?.remark1Array = list
            } else if row == 2 {
                self?.remark2Array = list
            } else if row == 3 {
                self?.remark3Array = list
            }
            completion?(list)
        }, failure: { code, msg in
            completion?(nil)
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
    }
    
    fileprivate func showSelectView(row: Int, list: [JSON]) {
        let array = list.compactMap { $0["name"].stringValue }
        DDListView.show(in: view, array: array) { [weak self] selectStr, index in
            if (row == 1) {
                self?.remark1SelectJson = list[index]
                self?.remark1View.textLabel.text = list[index]["name"].stringValue
                self?.remark2View.isHidden = false
                self?.remark2View.textLabel.text = "Compaonent"
                self?.remark2Array = []
                self?.remark2SelectJson = JSON()
                self?.remark3View.isHidden = true
                self?.remark3View.textLabel.text = "Task"
                self?.remark3Array = []
                self?.remark3SelectJson = JSON()
            } else if (row == 2) {
                self?.remark2SelectJson = list[index]
                self?.remark2View.textLabel.text = list[index]["name"].stringValue
                self?.remark3View.isHidden = false
                self?.remark3View.textLabel.text = "Task"
                self?.remark3Array = []
                self?.remark3SelectJson = JSON()
            } else if (row == 3) {
                self?.remark3SelectJson = list[index]
                self?.remark3View.textLabel.text = list[index]["name"].stringValue
            }
        }
    }
    
    fileprivate func showList(row: Int, parentID: String, jsonArray: [JSON]) {
        
        if !jsonArray.isEmpty {
            showSelectView(row: row, list: jsonArray)
        } else {
            loadRemark(row: row, id: parentID, completion: { [weak self] result in
                if let list = result, !list.isEmpty {
                    self?.showSelectView(row: row, list: list)
                } else {
                    ProgressHUD.showFailed("Request alarm remark list failed", interaction: false, delay: 3)
                }
            })
        }
    }
}

extension DDAlertUpdateVC {
    private func configPhotoPicker() {
        ZLPhotoUIConfiguration.default().navBarColor(UIColor(hex: "#1792AC"))
        ZLPhotoConfiguration.default().allowRecordVideo = false
        ZLPhotoConfiguration.default().allowSelectVideo = false
        ZLPhotoConfiguration.default().allowSelectGif = false
        ZLPhotoConfiguration.default().allowTakePhoto = true
        ZLPhotoConfiguration.default().allowMixSelect = false
        ZLPhotoConfiguration.default().maxSelectCount = 1
        ZLPhotoConfiguration.default().allowTakePhotoInLibrary = false
        ZLPhotoConfiguration.default().editAfterSelectThumbnailImage = true
        
        let config = ZLPhotoConfiguration.default().editImageConfiguration
        config.tools([.clip, .draw, .imageSticker, .textSticker, .mosaic, .filter, .adjust]).clipRatios([.wh1x1])
        ZLPhotoConfiguration.default().editImageConfiguration(config)
    }
}
