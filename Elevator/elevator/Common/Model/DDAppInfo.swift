//
//  DDAppInfo.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit

struct DDAppInfo {
    
    static let infoDictionary = Bundle.main.infoDictionary
    /// App 名称
    static let displayName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Smart Left"
    /// Bundle Identifier
    static let bundleId:String = Bundle.main.bundleIdentifier!
    /// App 版本号
    static let version:String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    /// Bulid 版本号
    static let buildNumber : String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    /// ios 版本
    static let systemVersion:String = UIDevice.current.systemVersion
    /// 设备 udid
    static let identifierNumber = UIDevice.current.identifierForVendor
    /// 设备名称
    static let systemName = UIDevice.current.systemName
    /// 设备型号
    static let model = UIDevice.current.model
    /// 设备区域化型号
    static let localizedModel = UIDevice.current.localizedModel
    
    static func timeStamp() -> String {
        return String(Int(Date().timeIntervalSince1970 * 1000))
    }

    static func dateStr(_ timeStamp: String?, dateFormat: String = "MM/dd/yyyy HH:mm:ss") -> String? {
        guard let timeStamp = timeStamp else { return nil }
        let dateString = timeStamp.count > 10 ? String(timeStamp.prefix(10)) : timeStamp
        guard dateString.count == 10, let dateDouble = Double(dateString) else { return nil }
        let date = Date(timeIntervalSince1970: dateDouble)
        return DateFormatter().then { $0.dateFormat = dateFormat }.string(from: date)
    }
    
    static func base64Img(_ imageStr:String) -> UIImage? {
        
        guard let data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters) else { return nil }
        return UIImage(data: data)
    }

}
