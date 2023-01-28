//
//  DDLoginViewController.swift
//  elevator
//
//  Created by ddy on 2023/1/16.
//

import UIKit

public extension UITableView {
    
    /// 注册cell
    @discardableResult
    func ddy_register(cells: [String: AnyClass]) -> UITableView {
        for (key, val) in cells {
            register(val, forCellReuseIdentifier: key)
        }
        return self
    }
    
    /// 注册cell
    @discardableResult
    func ddy_registers<T: UITableViewCell>(cells: [T.Type]) -> UITableView {
        for cell in cells {
            register(cell, forCellReuseIdentifier: String(describing: cell.self))
        }
        return self
    }
    
    /// 通过Cell类自动获取类名注册cell
    @discardableResult
    func ddy_register<T: UITableViewCell>(cellClass: T.Type) -> UITableView {
        register(cellClass, forCellReuseIdentifier: String(describing: T.self))
        return self
    }
    
    /// 通过Cell类获取复用cell
    func ddy_dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("未能通过 \(String(describing: T.self)) 取出 \(String(describing: cellClass))")
        }
        return cell
    }
    
    func ddy_zeroPadding() {
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0;
        }
        automaticallyAdjustsScrollIndicatorInsets = false
        contentInsetAdjustmentBehavior = .never
    }
}
