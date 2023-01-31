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
    
    /// 通过sectionHeader类自动获取类名注册sectionHeader
    @discardableResult
    func ddy_registerSectionHeader<T: UICollectionReusableView>(header: T.Type) -> UICollectionView {
        let kind: String = UICollectionView.elementKindSectionHeader
        register(header, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: T.self))
        return self
    }
    /// 通过sectionFooter类自动获取类名注册sectionFooter
    @discardableResult
    func ddy_registerSectionFooter<T: UICollectionReusableView>(footer: T.Type) -> UICollectionView {
        let kind: String = UICollectionView.elementKindSectionFooter
        register(footer, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: T.self))
        return self
    }
    /// 通过sectionHeader类获取复用sectionHeader
    func ddy_dequeueReusableHeader<T: UICollectionReusableView>(_ header: T.Type, for indexPath: IndexPath) -> T {
        let kind: String = UICollectionView.elementKindSectionHeader
        let resuseID: String = String(describing: T.self)
        guard let header = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: resuseID, for: indexPath) as? T else {
            fatalError("未能通过 \(String(describing: T.self)) 取出 \(String(describing: header))")
        }
        return header
    }
    
    /// 通过sectionFooter类获取复用sectionFooter
    func ddy_dequeueReusableFooter<T: UICollectionReusableView>(_ footer: T.Type, for indexPath: IndexPath) -> T {
        let kind: String = UICollectionView.elementKindSectionFooter
        let resuseID: String = String(describing: T.self)
        guard let footer = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: resuseID, for: indexPath) as? T else {
            fatalError("未能通过 \(String(describing: T.self)) 取出 \(String(describing: footer))")
        }
        return footer
    }
}
