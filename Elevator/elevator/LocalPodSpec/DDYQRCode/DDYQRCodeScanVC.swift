import UIKit

typealias DDYStringClosure = (_ str:String)->Void

class DDYQRCodeScanVC: UIViewController {

    // MARK:- 事件回调
    // MARK: 结果回掉
    var scanResult: DDYStringClosure?

    // MARK:- 懒加载
    // MARK: 扫描页面懒加载
    lazy var scanView: DDYQRCodeScanView = {
        let scanView = DDYQRCodeScanView.init(frame: UIScreen.main.bounds)
        return scanView
    }()

    // MARK: 扫描管理器懒加载
    lazy var qrcodeScanner: DDYQRCodeScanner = {
        let scanner = DDYQRCodeScanner()
        scanner.qrCodeDelegate = self
        return scanner
    }()

    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(scanView)
        setupClosure()
    }

    deinit {
        QRCodeDebugLog("DDYQRCodeScanVC deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        qrcodeScanner.ddyStartRunningSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        qrcodeScanner.ddyStopRunningSession()
    }

    // MARK:- 回调响应
    private func setupClosure() {
        weak var weakSelf = self
        scanView.backAction = { (Bool) -> Void in
            weakSelf?.backAction()
        }
        scanView.albumAction = { (Bool) -> Void in
            weakSelf?.qrcodeScanner.ddyQRCodeWithImagePicker(weakSelf)
        }
        scanView.lightAction = { (lightOpen: Bool) -> Void in
            DDYQRCodeScanner.turnOnTorchLight(lightOpen)
        }
        DDYQRCodeScanner.cameraAuth { (granted: Bool) in
            if granted == true {
                DispatchQueue.main.async {
                    weakSelf?.qrcodeScanner.ddyQRCode(weakSelf!.view, CGRect(x: 0, y: 0, width: 1, height: 1))
                }
            } else {
                QRCodeDebugLog("请开启相机权限")
                // KNBProgressHUD.shared.show("请开启相机权限")
            }
        }
    }
    
    @objc fileprivate func backAction() {
        if navigationController?.popViewController(animated: true) == nil {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension DDYQRCodeScanVC: DDYQRCodeScannerDelegate {
    
    func ddyQRCodeScanResult(_ resultStr: String?, _ errorCode: Int, _ errorMessage: String) {
        if errorCode == -1 {

        } else if errorCode == -2 {
//            KNBProgressHUD.shared.show("未发现有效二维码")
            QRCodeDebugLog("未发现有效二维码")
        } else if errorCode == 0 {
            QRCodeDebugLog("\(String(resultStr!))")
            if scanResult != nil {
                DDYQRCodeScanner.playSound(withResource: "DDYQRCode.bundle/ScanSuccess.caf")
                scanResult!(resultStr!)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.backAction()
                })
            } else {
                QRCodeDebugLog("未实现scanResult闭包回调")
            }
        }
    }

    func ddyQRCodeBrightnessValue(_ brightnessValue: Double) {
        DispatchQueue.main.async {
            QRCodeDebugLog("光强brightnessValue:\(brightnessValue)")
            if brightnessValue>0 && self.scanView.lightHidden==false && self.scanView.lightSelect==false {
                self.scanView.lightHidden = true
            } else if brightnessValue<0 && self.scanView.lightHidden==true {
                self.scanView.lightHidden = false
            } else {
                QRCodeDebugLog("其他状态维持原样，如开灯即使光强大于0也不能隐藏")
            }
        }
    }
}

func QRCodeDebugLog<M>(_ message: M) {
    if _isDebugAssertConfiguration() {
        print("\(message)")
    }
}


