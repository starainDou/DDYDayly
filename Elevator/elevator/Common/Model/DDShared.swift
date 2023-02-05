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
    
    var _token: String?
    var token: String? {
        set {
           _token = newValue
            UserDefaults.standard.set(newValue, forKey: "DDToken")
        }
        get {
            return _token ?? UserDefaults.standard.string(forKey: "DDToken")
        }
    }
    
    private(set) lazy var event: DDEvent = DDEvent()
    
    var homeItems: [DDHomeModel] {
        get {
            if user?.rolename == "Installer@STEE" {
                return [DDHomeModel(icon: "Repair", title: "Installtion")]
            } else if user?.rolename == "Engineer@STEE" {
                return [DDHomeModel(icon: "Commissioning", title: "Test&Commissioning")]
            } else {
                return [DDHomeModel(icon: "Elevator", title: "Lift"),
                        DDHomeModel(icon: "History", title: "History"),
                        DDHomeModel(icon: "FavouriteCyan", title: "Favourite"),
                        DDHomeModel(icon: "Summary", title: "Summary of Lift Performances")]
            }
        }
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
