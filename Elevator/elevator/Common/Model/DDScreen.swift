//
//  DDScreen.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import UIKit

struct DDScreen {
    /// mainScreen的bounds
    static let bounds: CGRect = UIScreen.main.bounds
    /// mainScreen的size
    static let size: CGSize = UIScreen.main.bounds.size
    /// mainScreen的width
    static let width: CGFloat = UIScreen.main.bounds.size.width
    /// mainScreen的height
    static let height: CGFloat = UIScreen.main.bounds.size.height
    /// 状态栏高度
    static let statusBarHeight: CGFloat = {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 47.0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }()
}
