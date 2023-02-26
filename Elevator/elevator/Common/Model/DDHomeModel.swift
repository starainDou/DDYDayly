//
//  DDHomeModel.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import UIKit

struct DDHomeModel {
    
    let icon: String
    
    let title: String
    
    var vc: String
    
    init(icon: String, title: String, vc: String) {
        self.icon = icon
        self.title = title
        self.vc = vc
    }
}
