//
//  DDLoginViewController.swift
//  elevator
//
//  Created by ddy on 2023/1/16.
//

import Foundation

public extension UICollectionView{
    
    /// 注册cell
    @discardableResult
    final func ddy_register(_ cells: [String: AnyClass]) -> UICollectionView {
        for (key, val) in cells {
            register(val, forCellWithReuseIdentifier: key)
        }
        return self
    }
    
    /// 通过Cell类自动获取类名注册cell
    @discardableResult
    func ddy_register<T: UICollectionViewCell>(cellClass: T.Type) -> UICollectionView {
        register(cellClass, forCellWithReuseIdentifier: String(describing: T.self))
        return self
    }
    
    /// 通过Cell类获取复用cell
    func ddy_dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("未能通过 \(String(describing: T.self)) 取出 \(String(describing: cellClass))")
        }
        return cell
    }
}
