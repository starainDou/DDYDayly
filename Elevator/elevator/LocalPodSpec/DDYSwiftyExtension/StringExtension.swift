//
//  UIColorExtension.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import Foundation

public extension String {
    var urlEncode: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    var ddy_zero: String {
        if replacingOccurrences(of: "0", with: "").replacingOccurrences(of: ".", with: "") == "" {
            return "0"
        } else {
            return self
        }
    }
}
