//
//  DDAppInfo.swift
//  elevator
//
//  Created by ddy on 2023/1/30.
//

import UIKit
import CommonCrypto
import CryptoKit

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
    
    static func base64ToImage(_ imageStr:String) -> UIImage? {
        guard let data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters) else { return nil }
        return UIImage(data: data)
    }
    
    static func imageToBase64(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        return data.base64EncodedString(options: .lineLength64Characters)
    }
    
    public static func md5(_ string: String, lower: Bool = true) -> String? {
        if #available(iOS 13.0, *) {
            guard let data = string.data(using: .utf8) else { return nil }
            let digest = Insecure.MD5.hash(data: data)
            return digest.map { String(format: (lower ? "%02hhx" : "%02hhX"), $0) }.joined()
        } else {
            guard let cStr = string.cString(using: .utf8) else { return nil }
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(cStr,(CC_LONG)(strlen(cStr)), buffer)
            let md5String = NSMutableString();
            for i in 0 ..< 16 {
                md5String.appendFormat((lower ? "%02x" : "%02X"), buffer[i])
            }
            free(buffer)
            return md5String as String
        }
    }
    
    public static var ducumentPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
}
