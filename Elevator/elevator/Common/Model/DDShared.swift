//
//  DDShared.swift
//  elevator
//
//  Created by ddy on 2023/2/5.
//

import UIKit

class DDShared: NSObject {
    static let shared = DDShared()
    private override init() { }
    
    var user: DDUserModel?
    var lift: DDLiftModel?
    var cookie: String?
    var token: String?
    
    private(set) lazy var event: DDEvent = DDEvent()
    
    var homeItems: [DDHomeModel] {
        get {
            if user?.rolename == "Installer@STEE" {
                return [DDHomeModel(icon: "Repair", title: "Installtion", vc: DDQRCodeVC())]
            } else if user?.rolename == "Engineer@STEE" {
                return [DDHomeModel(icon: "Elevator", title: "Lift", vc: DDEngineerVC()),
                        DDHomeModel(icon: "History", title: "History", vc: DDQRCodeVC()),
                        DDHomeModel(icon: "FavouriteCyan", title: "Favourite", vc: DDQRCodeVC()),
                        DDHomeModel(icon: "Summary", title: "Summary of Lift Performances", vc: DDQRCodeVC())]
            } else if user?.rolename == "T&C@STEE" {
                return [DDHomeModel(icon: "Commissioning", title: "Test&Commissioning", vc: DDQRCodeVC())]
            } else {
                return [DDHomeModel(icon: "Elevator", title: "Lift", vc: DDEngineerVC()),
                        DDHomeModel(icon: "History", title: "History", vc: DDQRCodeVC()),
                        DDHomeModel(icon: "FavouriteCyan", title: "Favourite", vc: DDQRCodeVC()),
                        DDHomeModel(icon: "Summary", title: "Summary of Lift Performances", vc: DDQRCodeVC())]
            }
        }
    }
    
    func save(dict: [String: Any], for key: String) {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        UserDefaults.standard.set(str, forKey: key)
    }
    
    func getDict(for key: String) -> [String: Any]? {
        guard let data = UserDefaults.standard.string(forKey: key)?.data(using: .utf8) else { return nil }
        let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        return dict
    }
}
/*
 enum Role: String, CaseIterable {
     case tc = "T&C@STEE"
     case installer = "Installer@STEE"
     case engineer = "Engineer@STEE"
 }
 
 var role: Role {
     return DDUserModel.Role.init(rawValue: rolename) ?? DDUserModel.Role.tc
 }
 
 var homeItems: [DDHomeModel] = []
 */
