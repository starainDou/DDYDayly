//
//  UIColorExtension.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import Foundation

public extension UIView {
    
    func addSubviews(_ subviews: UIView...) {
        for subView in subviews {
            addSubview(subView)
        }
    }
}
