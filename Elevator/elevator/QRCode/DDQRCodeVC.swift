//
//  DDQRCodeVC.swift
//  elevator
//
//  Created by ddy on 2023/1/18.
//

import UIKit
import IQKeyboardManagerSwift
import DDYQRCode
import ProgressHUD
import SwiftyJSON

class DDQRCodeVC: UIViewController {
    
    public var scanBlock: ((JSON) -> Void)?
    
    private lazy var qrcodeView: DDQRCodeView = DDQRCodeView()
    
    // MARK: 扫描管理器懒加载
    private lazy var qrcodeScanner: DDYQRCodeScanner = {
        let scanner = DDYQRCodeScanner()
        scanner.qrCodeDelegate = self
        return scanner
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        qrcodeScanner.ddyStartRunningSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrcodeScanner.ddyStopRunningSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(qrcodeView)
        keyboardObserver()
        setupClosure()
    }
    
    // MARK:- 回调响应
    private func setupClosure() {
        qrcodeView.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        qrcodeView.lightButton.addTarget(self, action: #selector(lightAction(_:)), for: .touchUpInside)
        qrcodeView.confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        qrcodeView.inputTextField.addTarget(self, action: #selector(inputTextFieldDidChange(_:)), for: .editingChanged)
        DDYQRCodeScanner.cameraAuth { [weak self] (granted: Bool) in
            if granted == true {
                self?.qrcodeScanner.ddyQRCode(self!.view, CGRect(x: 0, y: 0, width: 1, height: 1))
                self?.qrcodeScanner.ddyStartRunningSession()
            } else {
                self?.showAuthAlert()
            }
        }
    }
    
    @objc private func inputTextFieldDidChange(_ textField: UITextField) {
        guard let str = textField.text, str.isEmpty == false else {
            return
        }
        let charSet = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        let newStr = str.trimmingCharacters(in: charSet.inverted)
        textField.text = newStr.count > 20 ? String(newStr.prefix(20)) : newStr
    }
    
    private func showAuthAlert() {
        DDYQRCodeScanner.showAuthAlert(DDAppInfo.displayName, "Camera", self)
    }
    
    @objc fileprivate func backAction() {
        if navigationController?.popViewController(animated: true) == nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func lightAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        DDYQRCodeScanner.turnOnTorchLight(button.isSelected)
    }
    
    @objc fileprivate func confirmAction() {
        view.endEditing(true)
        guard let text = qrcodeView.inputTextField.text, !text.isEmpty else {
            ProgressHUD.showFailed("Please enter the number", interaction: false, delay: 3)
            return;
        }
        let lastTime = DateFormatter().then { $0.dateFormat = "MM/dd/yyyy HH:mm:ss" }.string(from: Date())
        let json = JSON(["deviceId": text, "timeStamp": DDAppInfo.timeStamp(), "status":"0", "lastUpdateTime": lastTime])
        if (scanBlock != nil) {
            scanBlock?(json)
            backAction()
        } else {
            let vc = DDVerifyVC().then { $0.sensorJson = json }
            if var vcs = navigationController?.viewControllers, let index = vcs.firstIndex(of: self) {
                vcs.remove(at: index)
                vcs.append(vc)
                navigationController?.setViewControllers(vcs, animated: true)
            } else {
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func keyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(_ notification: Notification) {
        if qrcodeView.inputTextField.isFirstResponder == true {
            qrcodeScanner.ddyStopRunningSession()
        }
    }
    
    @objc func keyBoardWillHide(_ notification: Notification) {
        if qrcodeView.inputTextField.isFirstResponder == true {
            qrcodeScanner.ddyStartRunningSession()
        }
    }
}


extension DDQRCodeVC: DDYQRCodeScannerDelegate {
    
    func ddyQRCodeScanResult(_ resultStr: String?, _ errorCode: Int, _ errorMessage: String) {
        if errorCode == -1 {

        } else if errorCode == -2 {

        } else if errorCode == 0 {
            DispatchQueue.main.async {
                guard let text = resultStr, self.qrcodeView.inputTextField.text != text else { return }
                self.qrcodeView.inputTextField.text = text
            }
        }
    }
}
