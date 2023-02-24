//
//  DDDocumentPreviewVC.swift
//  elevator
//
//  Created by ddy on 2023/2/24.
//

import UIKit
import QuickLook

class DDDocumentPreviewVC: UIViewController {
    
    private lazy var files: [QLPreviewItem] = []
    
    private lazy var navigationBar: DDNavigationBar = DDNavigationBar().then {
        $0.titleLabel.text = "Before Installation"
        $0.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private lazy var previewVC: QLPreviewController = QLPreviewController().then {
        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var tipLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        $0.textColor = UIColor.lightGray
        $0.text = "Data Error"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F1F5FF")
        view.addSubviews(navigationBar, previewVC.view, tipLabel)
        addChild(previewVC)
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(DDScreen.statusBarHeight + 44)
        }
        previewVC.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    public func loadData(_ filePath: String,_ fileName: String) {
        let item = URL(fileURLWithPath: filePath) as QLPreviewItem
        navigationBar.titleLabel.text = fileName
        if QLPreviewController.canPreview(item) {
            files.append(item)
            tipLabel.isHidden = true
            previewVC.reloadData()
        }  else {
            DDShared.shared.removePath(filePath)
            tipLabel.isHidden = false
        }
    }
}


extension DDDocumentPreviewVC: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return files.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return files[index]
    }
}
