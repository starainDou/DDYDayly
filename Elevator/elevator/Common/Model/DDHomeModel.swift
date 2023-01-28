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
    
    var vc: UIViewController?
    
    init(icon: String, title: String) {
        self.icon = icon
        self.title = title
    }
}
