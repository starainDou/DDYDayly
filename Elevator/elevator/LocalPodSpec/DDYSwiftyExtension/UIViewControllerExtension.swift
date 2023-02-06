//
//  UIColorExtension.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import Foundation

public extension UIViewController {
    func addChildren(_ children: UIViewController...) {
        for child in children {
            addChild(child)
        }
    }
}
