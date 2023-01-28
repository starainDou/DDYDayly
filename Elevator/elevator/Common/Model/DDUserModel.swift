//
//  DDUserModel.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import UIKit

class DDUserModel: NSObject {
    
    enum Role: String, CaseIterable {
        case tc = "tc"
        case installer = "installer"
        case engineer = "engineer"
        case lpms = "lpms"
        case town = "town"
    }
    
    var role: Role = .tc
    
    var sex: Int = 0
    
    var name: String = ""
    
    var avatar: String = ""
    
    var homeItems: [DDHomeModel] = []
}
