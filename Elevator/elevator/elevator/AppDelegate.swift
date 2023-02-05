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
        window?.rootViewController = UINavigationController(rootViewController: DDLoginViewController())
        window?.makeKeyAndVisible()
    }
    
    private func configSDK() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 5
    }
    
    private func binding() {
        
        DDShared.shared.event.login.subscribe(onNext: { [weak self] (_) in
            self?.window?.rootViewController = UINavigationController(rootViewController: DDHomeVC())
        }).disposed(by: disposeBag)
        
        DDShared.shared.event.logout.subscribe(onNext: { [weak self] (_) in
            self?.window?.rootViewController = UINavigationController(rootViewController: DDLoginViewController())
        }).disposed(by: disposeBag)
    }
}

