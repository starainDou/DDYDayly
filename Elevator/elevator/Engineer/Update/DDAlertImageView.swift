//
//  DDAlertImageView.swift
//  elevator
//
//  Created by ddy on 2023/2/13.
//

import UIKit
import ZLPhotoBrowser
import ProgressHUD

class DDAlertImageView: UIView {

    private(set) lazy var imgView: UIImageView = UIImageView()
    
    private(set) lazy var addButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "TakePhoto"), for: .normal)
        $0.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
    }
    private(set) lazy var deleteButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "Delete"), for: .normal)
        $0.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }
    
    var fileName: String?
    
    weak var vc: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#F3F3F3")
        layer.masksToBounds = true
        layer.cornerRadius = 4
        addSubviews(imgView, addButton, deleteButton)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(28)
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    @objc private func deleteAction() {
        load(image: nil)
    }
    
    public func load(image: UIImage?) {
        if let img = image {
            imgView.image = img
            deleteButton.isHidden = false
            addButton.isHidden = true
        } else {
            imgView.image = nil
            deleteButton.isHidden = true
            addButton.isHidden = false
        }
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
        vc?.present(sheet, animated: true, completion: nil)
    }
    
    private func albumAction() {
        guard let currentVC = vc else { return }
        let album = ZLPhotoPreviewSheet()
        album.selectImageBlock = { [weak self] (imageModel, isOriginal) in
            self?.uploadImage(image: imageModel.first?.image)
        }
        album.showPhotoLibrary(sender: currentVC)
    }
    
    private func cameraAction() {
        guard let currentVC = vc else { return }
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { [weak self] (image, videoUrl) in
            self?.uploadImage(image: image)
        }
        currentVC.showDetailViewController(camera, sender: nil)
    }
    
    private func uploadImage(image: UIImage?) {
        guard let data = image?.jpegData(compressionQuality: 0.7) else {
            ProgressHUD.showFailed("The image parse failed, please retry", interaction: false, delay: 3)
            return
        }
        let name = UUID().uuidString + ".jpg"
        ProgressHUD.show(interaction: false)
        DDUpload(target: .uploadImageOfLift(data, name), success: { [weak self] result, msg in
            ProgressHUD.showSuccess("Success")
            self?.load(image: image)
            self?.fileName = name
        }, failure: { [weak self] code, msg in
            ProgressHUD.showFailed(msg ?? "Fail", interaction: false, delay: 3)
        })
    }
}
