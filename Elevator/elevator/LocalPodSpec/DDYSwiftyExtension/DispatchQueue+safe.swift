//
//  DispatchQueue+safe.swift
//  game_werewolf
//
//  Created by doudianyu on 2020/9/21.
//  Copyright © 2020 orangelab. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    private static var token: DispatchSpecificKey<()> = {
        let key = DispatchSpecificKey<()>()
        DispatchQueue.main.setSpecific(key: key, value: ())
        return key
    }()

    /// 判断是否主队列
    static var ddy_isMainQueue: Bool {
        return DispatchQueue.getSpecific(key: token) != nil
    }
    
    /// 较为安全的主线程主队列执行
    /// - Parameter closure: 要执行的代码段
    func ddy_safeAsync(_ closure: @escaping () -> Void) {
        if self === DispatchQueue.main && Thread.isMainThread {
            closure()
        } else {
            async { closure() }
        }
    }}
