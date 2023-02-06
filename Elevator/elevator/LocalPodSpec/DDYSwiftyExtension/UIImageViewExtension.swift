//
//  UIColorExtension.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import Foundation

public extension UIImageView {
    // func ddy_registerSectionFooter<T: UICollectionReusableView>(footer: T.Type) -> UICollectionView
    @discardableResult
    func ddy_tap(_ target: Any?, action: Selector, gestureBlock: ((UITapGestureRecognizer) -> Void)? = nil) -> UIImageView {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        gestureBlock?(tap)
        addGestureRecognizer(tap)
        return self
    }
}
