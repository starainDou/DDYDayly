//
//  DDImageEditVC.swift
//  elevator
//
//  Created by ddy on 2023/1/29.
//

import UIKit
import Then
import IQKeyboardManagerSwift
import ZLPhotoBrowser
import ProgressHUD

class DDImageEditVC: UIViewController {
    
    var takeBlock: ((UIImage, String) -> Void)?

    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Image Editing"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var backView: UIScrollView = UIScrollView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.bounces = false
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }
    
    private lazy var tipLabel: UILabel = UILabel().then {
        $0.text = "APS Bracket (Shaft Top)"
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    private lazy var imageView: UIImageView = UIImageView().then {
        $0.backgroundColor = UIColor(hex: "#EEEEEE")
    }
    
    private lazy var cameraButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "TakePhoto"), for: .normal)
        $0.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    private lazy var deleteButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "Delete"), for: .normal)
        $0.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }
    private lazy var rectView: UIView = UIView().then {
        $0.layer.borderColor = UIColor(hex: "#CCCCCC").cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 1
        $0.layer.masksToBounds = true
    }
    
    private lazy var textView: IQTextView = IQTextView().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.placeholder = "255 text length, 4 images per page"
        $0.placeholderTextColor = UIColor(hex: "#999999")
        $0.delegate = self
    }
    
    private lazy var confirmButton: UIButton = UIButton(type: .custom).then {
        $0.setTitle("Confirm", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = UIColor(hex: "#168991")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, backView)
        backView.addSubviews(tipLabel, imageView, cameraButton, rectView, textView, confirmButton)
        setViewConstraints()
        configPhotoPicker()
    }

    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom).offset(10)
        }
        tipLabel.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(15)
            make.top.equalTo(backView).inset(20)
        }
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backView).inset(20)
            make.top.equalTo(tipLabel.snp.bottom).offset(18)
            make.height.equalTo(imageView.snp.width)
        }
        cameraButton.snp.makeConstraints { make in
            make.center.equalTo(imageView)
            make.width.height.equalTo(48)
        }
        rectView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backView).inset(20)
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.height.equalTo(rectView.snp.width)
        }
        textView.snp.makeConstraints { make in
            make.edges.equalTo(rectView).inset(UIEdgeInsets(top: 10, left: 13, bottom: 10, right: 13))
        }
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.width.equalTo(DDScreen.width - 20*2 - 15*2)
            make.height.equalTo(40)
            make.top.equalTo(rectView.snp.bottom).offset(45)
            make.bottom.equalToSuperview().inset(56)
        }
    }
    
    @objc private func confirmAction() {
        guard let img = imageView.image else {
            ProgressHUD.showFailed("Please add one image", interaction: false, delay: 3)
            return
        }
        guard let profile = textView.text, !profile.isEmpty else {
            ProgressHUD.showFailed("Please input descroption", interaction: false, delay: 3)
            return
        }
        takeBlock?(img, profile)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
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
        ZLPhotoConfiguration.default().showClipDirectlyIfOnlyHasClipTool = true
        
        let config = ZLPhotoConfiguration.default().editImageConfiguration
        //config.tools([.clip]).clipRatios([.wh1x1])
        config.tools([.clip, .draw, .imageSticker, .textSticker, .mosaic, .filter, .adjust]).clipRatios([.wh1x1])
        ZLPhotoConfiguration.default().editImageConfiguration(config)
    }
    
    @objc private func selectAction() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] action in
            self?.cameraAction()
        }))
        sheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { [weak self] action in
            self?.albumAction()
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
    
    @objc private func deleteAction() {
        load(image: nil)
    }
    
    private func albumAction() {
        let album = ZLPhotoPreviewSheet()
        album.selectImageBlock = { [weak self] (imageModel, isOriginal) in
            self?.load(image: imageModel.first?.image)
        }
        album.showPhotoLibrary(sender: self)
    }
    
    private func cameraAction() {
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { [weak self] (image, videoUrl) in
            self?.load(image: image)
        }
        showDetailViewController(camera, sender: nil)
    }
    
    public func load(image: UIImage?) {
        if let img = image {
            imageView.image = img
            deleteButton.isHidden = false
            cameraButton.isHidden = true
        } else {
            imageView.image = nil
            deleteButton.isHidden = true
            cameraButton.isHidden = false
        }
    }
    
    public func load(profile: String?) {
        textView.text = profile ??  ""
    }
}


extension DDImageEditVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        if let selectRange = textView.markedTextRange, textView.position(from: selectRange.start, offset: 0) != nil {
            // 未输入完成，比如拼音输入，注音输入
        } else {
            if text.count > 500 {
                textView.text = String(text.prefix(500))
            }
        }
    }
}
