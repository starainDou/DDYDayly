//
//  UIColorExtension.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import Foundation

public extension Double {
    /// 要保留的小数个数
    func ddy_round(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}

public extension Float {
    /// 要保留的小数个数
       func ddy_round(_ places:Int) -> Float {
           let divisor = pow(10.0, Float(places))
           return (self * divisor).rounded() / divisor
       }
}
