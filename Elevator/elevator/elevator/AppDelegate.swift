//
//  AppDelegate.swift
//  elevator
//
//  Created by ddy on 2023/1/16.
//

import UIKit
import IQKeyboardManagerSwift
import ProgressHUD
import RxSwift
import DDYSwiftyExtension
import SwiftyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configSDK()
        configView()
        binding()
        return true
    }
    
    private func configView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        checkLogin()
    }
    
    private func configSDK() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 5
        
        UILabel.ddySwizzleMethod()
    }
    
    private func binding() {
        DDShared.shared.event.logInOrOut.observe(on: ConcurrentMainScheduler.instance).subscribe(onNext: { [weak self] (value) in
            let vc = value ? DDHomeVC() : DDLoginViewController()
            self?.window?.rootViewController = UINavigationController(rootViewController: vc)
        }).disposed(by: disposeBag)
    }
    
    private func checkLogin() {
        let json = JSON(DDShared.shared.getDict(for: "DDLoginData") ?? [:])["data"]
        if json["user"].dictionaryValue.isEmpty || json["token"].stringValue.isEmpty || json["sessionToken"].stringValue.isEmpty  {
            window?.rootViewController = UINavigationController(rootViewController: DDHomeVC()) // DDLoginViewController()
        } else {
            DDShared.shared.user = DDUserModel(json["user"])
            DDShared.shared.token = json["token"].stringValue
            DDShared.shared.cookie = "iPlanetDirectoryPro=" + json["sessionToken"].stringValue
            window?.rootViewController = UINavigationController(rootViewController: DDHomeVC())
        }
    }
}

