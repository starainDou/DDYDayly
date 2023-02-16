//
//  DDShared.swift
//  elevator
//
//  Created by ddy on 2023/2/5.
//

import UIKit
@_exported import SwiftyJSON

class DDShared: NSObject {
    static let LogDataKey: String = "DDLoginData"
    
    static let shared = DDShared()
    private override init() { }
    
    var json: JSON?
    
    var cookie: String? {
        get {
            if let jsonInfo = json {
                return "iPlanetDirectoryPro=" + jsonInfo["sessionToken"].stringValue
            } else {
                return nil
            }
        }
    }
    
    var token: String? {
        get {
            if let jsonInfo = json {
                return jsonInfo["token"].stringValue
            } else {
                return nil
            }
        }
    }
    
    //var user: DDUserModel?
    var lift: DDLiftModel?
//    var cookie: String?
//    var token: String?
    
    private(set) lazy var event: DDEvent = DDEvent()
    
    var homeItems: [DDHomeModel] {
        get {
            if json?["user"]["rolename"].stringValue == "Installer@STEE" {
                return [DDHomeModel(icon: "Repair", title: "Installtion", vc: DDQRCodeVC())]
            } else if json?["user"]["rolename"].stringValue == "Engineer@STEE" {
                return [DDHomeModel(icon: "Elevator", title: "Lift", vc: DDEngineerVC()),
                        DDHomeModel(icon: "History", title: "History", vc: DDQRCodeVC()),
                        DDHomeModel(icon: "FavouriteCyan", title: "Favourite", vc: DDQRCodeVC()),
                        DDHomeModel(icon: "Summary", title: "Summary of Lift Performances", vc: DDQRCodeVC())]
            } else if json?["user"]["rolename"].stringValue == "T&C@STEE" {
                return [DDHomeModel(icon: "Commissioning", title: "Test&Commissioning", vc: DDQRCodeVC())]
            } else {
                return [DDHomeModel(icon: "Elevator", title: "Lift", vc: DDEngineerVC()),
                        DDHomeModel(icon: "History", title: "History", vc: DDSummaryVC()),
                        DDHomeModel(icon: "FavouriteCyan", title: "Favourite", vc: DDQRCodeVC()),
                        DDHomeModel(icon: "Summary", title: "Summary of Lift Performances", vc: DDSummaryVC())]
            }
        }
    }
    
    func save(dict: [String: Any], for key: String) {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        UserDefaults.standard.set(str, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getDict(for key: String) -> [String: Any]? {
        guard let data = UserDefaults.standard.string(forKey: key)?.data(using: .utf8) else { return nil }
        let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        return dict
    }
    
    func remove(for key:String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func dict2String(_ dict: [String: Any]) -> String? {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
}
