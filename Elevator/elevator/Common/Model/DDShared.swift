//
//  DDShared.swift
//  elevator
//
//  Created by ddy on 2023/2/5.
//

import UIKit
import SwiftyJSON // @_exported
import Moya
import ProgressHUD

class DDShared: NSObject {
    private static let LoginDataKey: String = "DDLoginDataKey"
    private static let DDOldUserKey: String = "DDOldUserKey"
    private static let DDDescriptKey: String = "DDDescriptKey"
    
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
            if json?["user"]["rolename"].string == "Installer@STEE" || json?["user"]["roleid"].int == 5 {
                return [DDHomeModel(icon: "Repair", title: "Installtion", vc: "DDQRCodeVC")]
            } else if json?["user"]["rolename"].string == "T&C@STEE" || json?["user"]["roleid"].int == 6 {
                return [DDHomeModel(icon: "Commissioning", title: "Test&Commissioning", vc: "DDTestVC")]
            } else if json?["user"]["rolename"].string == "Engineer@STEE" || json?["user"]["roleid"].int == 7 {
                return [DDHomeModel(icon: "Elevator", title: "Lift", vc: "DDEngineerVC1"),
                        DDHomeModel(icon: "History", title: "History", vc: "DDEngineerVC2"),
                        DDHomeModel(icon: "FavouriteCyan", title: "Favourite", vc: "DDEngineerVC3"),
                        DDHomeModel(icon: "Summary", title: "Summary of Lift Performances", vc: "DDSummaryVC")]
            } else {
                return [DDHomeModel(icon: "Elevator", title: "Lift", vc: "DDEngineerVC1"),
                        DDHomeModel(icon: "History", title: "History", vc: "DDEngineerVC2"),
                        DDHomeModel(icon: "FavouriteCyan", title: "Favourite", vc: "DDEngineerVC3"),
                        DDHomeModel(icon: "Summary", title: "Summary of Lift Performances", vc: "DDSummaryVC")]
            }
        }
    }
    
    func saveLoginData(_ dict: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        let str = String(data: data, encoding: String.Encoding.utf8)
        UserDefaults.standard.set(str, forKey: DDShared.LoginDataKey)
        UserDefaults.standard.synchronize()
    }
    
    func getLoginDict() -> [String: Any]? {
        guard let data = UserDefaults.standard.string(forKey: DDShared.LoginDataKey)?.data(using: .utf8) else { return nil }
        let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        return dict
    }
    
    func removeLoginDict() {
        UserDefaults.standard.removeObject(forKey: DDShared.LoginDataKey)
        UserDefaults.standard.synchronize()
    }
    
    private func dict2String(_ dict: [String: Any]) -> String? {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
    
    public func saveLift(image: UIImage?, key: String?) {
        guard let cacheKey = key else { return }
        liftImageCache[cacheKey] = image
        createPath("/LiftImages")
        let path = DDAppInfo.ducumentPath + "/LiftImages/" + "\(cacheKey).jpg"
        if let data = image?.jpegData(compressionQuality: 0.7) {
            try? data.write(to: URL(fileURLWithPath: path), options: .atomic)
        } else {
            try? FileManager.default.removeItem(atPath: path)
        }
        
    }
    
    public func saveLift(profile: String?, key: String?) {
        guard let cacheKey = key else { return }
        liftProfileCache[cacheKey] = profile
        if let str = profile, let saveStr = dict2String([cacheKey: str]) {
            UserDefaults.standard.set(saveStr, forKey: DDShared.DDDescriptKey)
        } else {
            UserDefaults.standard.removeObject(forKey: DDShared.DDDescriptKey)
        }
        UserDefaults.standard.synchronize()
    }
    
    public func getLiftProfile(_ key: String) -> String? {
        guard let data = UserDefaults.standard.string(forKey: DDShared.DDDescriptKey)?.data(using: .utf8) else { return nil }
        let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        return dict?[key]
    }
    
    private lazy var liftImageCache: [String: UIImage] = [:]
    private lazy var liftProfileCache: [String: String] = [:]
    
    public func liftImage(_ key: String?) -> UIImage? {
        guard let cacheKey = key else { return nil }
        if let image = liftImageCache[cacheKey] {
            return image
        } else if let image = UIImage(contentsOfFile: DDAppInfo.ducumentPath + "/LiftImages/" + "\(cacheKey).jpg") {
            liftImageCache[cacheKey] = image
            return image
        } else {
            return nil
        }
    }
    
    public func liftProfile(_ key: String?) -> String? {
        guard let cacheKey = key else { return nil }
        if let str = liftProfileCache[cacheKey] {
            return str
        } else if let str = getLiftProfile(cacheKey) {
            liftProfileCache[cacheKey] = str
            return str
        } else {
            return nil
        }
    }
    
    public func removePath(_ path: String) {
        let dir = DDAppInfo.ducumentPath + path
        try? FileManager.default.removeItem(atPath: dir)
    }
    
    public func createPath(_ path: String) {
        let dir = DDAppInfo.ducumentPath + path
        if !dirExist(dir) {
            let attributes = [FileAttributeKey.posixPermissions : 0o777]
            try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: attributes)
        }
    }
    
    public func dirExist(_ path: String) -> Bool {
        var exist = ObjCBool(false)
        let fileExist = FileManager.default.fileExists(atPath: path, isDirectory: &exist)
        return fileExist && exist.boolValue
    }
    
    func saveUserTag() {
        guard let id = json?["user"]["id"].string, let role = json?["user"]["rolename"].string else { return }
        UserDefaults.standard.set((id + "_" + role), forKey: DDShared.DDOldUserKey)
        UserDefaults.standard.synchronize()
    }
    
    func getUserTag() -> String? {
        return UserDefaults.standard.string(forKey: DDShared.DDOldUserKey)
    }
    
    func clearOldData() {
        guard let id = json?["user"]["id"].string, let role = json?["user"]["rolename"].string else { return }
        if (id + "_" + role) != getUserTag() {
            UserDefaults.standard.removeObject(forKey: DDShared.DDOldUserKey)
            UserDefaults.standard.removeObject(forKey: DDShared.DDDescriptKey)
            removePath("/LiftImages")
            saveUserTag()
        }
    }
}
