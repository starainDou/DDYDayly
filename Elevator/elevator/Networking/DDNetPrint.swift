//
//  DDNetLogger.swift
//  elevator
//
//  Created by ddy on 2023/1/18.
//

import Foundation

// MARK: - 日志打印
/// 封装的日志输出功能（T表示不指定日志信息参数类型）
internal func DDNetPrint<T>(_ message:T, file:String = #file, function:String = #function, line:Int = #line) {
    DDNetLog(message, file, function, line)
}

// MARK - 私有方法
// MARK: 层级
fileprivate protocol DDLogLevel {
    func logDescription(level: Int) -> String
}

// MARK: 真正打印
fileprivate func DDNetLog<T>(_ message:T,_ file:String,_ function:String,_ line:Int) {

    let infoString = "[\(getTime()) DDNetWork \((file as NSString).lastPathComponent):\(line)]"
    if message is Dictionary<String, Any> {
        print("\(infoString)\n\((message as! Dictionary<String, Any>).logDescription(level: 0))")
    } else if message is Array<Any> {
        print("\(infoString)\n\((message as! Array<Any> ).logDescription(level: 0))")
    } else if message is CustomStringConvertible {
        print("\(infoString)\n\((message as! CustomStringConvertible).description)")
    } else {
        print("\(infoString)\n\(message)")
    }
}

// MARK: 获取时间
fileprivate func getTime() -> String {
    let timeFormatter = DateFormatter()
    // 2022-02-02 22:22:22.222
    timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss.SSS"
    return timeFormatter.string(from: Date()) as String
}

// MARK: - 要打印的数据的扩展
// MARK: 重写可选型description
extension Optional: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "Optional(null)"
        case .some(let obj):
            if let obj = obj as? CustomStringConvertible, obj is Dictionary<String, Any> {
                return "Optional:" + "\((obj as! Dictionary<String, Any>).logDescription(level: 0))"
            }
            if let obj = obj as? CustomStringConvertible, obj is Array<Any> {
                return "Optional:" + "\((obj as! Array<Any>).logDescription(level: 0))"
            }
            return  "Optional" + "(\(obj))"
        }
    }
}

// MARK: 字典
extension Dictionary: DDLogLevel {
    public var description: String {
        var str = ""
        str.append(contentsOf: "{\n")
        for (key, value) in self {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, s.unicodeStr))
            } else if value is Dictionary {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, (value as! Dictionary).description))
            } else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, (value as! Array<Any>).description))
            } else {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, "\(value)"))
            }
        }
        str.append(contentsOf: "}")
        return str
    }

    func logDescription(level: Int) -> String{
        var str = ""
        var tab = ""
        for _ in 0..<level {
            tab.append(contentsOf: "\t")
        }
        str.append(contentsOf: "{\n")
        for (key, value) in self {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "%@\t%@ = \"%@\",\n", tab, key as! CVarArg, s.unicodeStrWith(level: level)))
            } else if value is Dictionary {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, (value as! Dictionary).logDescription(level: level + 1)))
            } else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, (value as! Array<Any>).logDescription(level: level + 1)))
            } else {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, "\(value)"))
            }
        }
        str.append(contentsOf: String.init(format: "%@}", tab))
        return str
    }
}

// MARK: 数组
extension Array: DDLogLevel {

    public var description: String {
        var str = ""
        str.append(contentsOf: "[\n")
        for (_, value) in self.enumerated() {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "\t\"%@\",\n", s.unicodeStr))
            } else if value is Dictionary<String, Any> {
                str.append(contentsOf: String.init(format: "\t%@,\n", (value as! Dictionary<String, Any>).description))
            } else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "\t%@,\n", (value as! Array<Any>).description))
            } else {
                str.append(contentsOf: String.init(format: "\t%@,\n", "\(value)"))
            }
        }
        str.append(contentsOf: "]")
        return str
    }
    
    func logDescription(level: Int) -> String {
        var str = ""
        var tab = ""
        str.append(contentsOf: "[\n")
        for _ in 0..<level {
            tab.append(contentsOf: "\t")
        }
        for (_, value) in self.enumerated() {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "%@\t\"%@\",\n", tab, s.unicodeStrWith(level: level)))
            } else if value is Dictionary<String, Any> {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, (value as! Dictionary<String, Any>).logDescription(level: level + 1)))
            } else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, (value as! Array<Any>).logDescription(level: level + 1)))
            } else {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, "\(value)"))
            }
        }
        str.append(contentsOf: String.init(format: "%@]", tab))
        return str
    }
}

// MARK: 字符串
extension String {
    
    var unicodeStr: String {
        return self.unicodeStrWith(level: 1)
    }
    
    func unicodeStrWith(level: Int) -> String {
        if let data = data(using: .utf8), let id = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            if id is Dictionary<String, Any> {
                return (id as! Dictionary<String, Any>).logDescription(level: level + 1)
            } else if id is Array<Any> {
                return (id as! Array<Any>).logDescription(level: level + 1)
            }
        }
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        guard let tempData = tempStr3.data(using: String.Encoding.utf8) else { return self }
        let opt: PropertyListSerialization.ReadOptions = [.mutableContainers]
        guard let returnStr = try? PropertyListSerialization.propertyList(from: tempData, options: opt, format: nil) as? String else { return self }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}
