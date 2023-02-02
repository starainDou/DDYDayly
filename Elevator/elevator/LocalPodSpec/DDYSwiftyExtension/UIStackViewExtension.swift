//
//  UIColorExtension.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import Foundation

public extension UIStackView {
    
    func addArrangedSubviews(_ subviews: UIView...) {
        for subView in subviews {
            addArrangedSubview(subView)
        }
    }
}
