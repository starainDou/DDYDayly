//
//  DDDownloadApi.swift
//  elevator
//
//  Created by ddy on 2023/2/21.
//

import UIKit
import Moya

public enum DDDownloadApi {
    /// 下载T&C report
    case getTcReport(fileName: String, liftNumber: String, mapImgBase64: String, dateVal: String)
    /// 下载KPI report
    case kpiNew(fileName: String, liftNumber: String, dateVal: String, flag: String)
}

extension DDDownloadApi {
    internal var handleResult: (url: String, params: [String: Any], destination: DownloadDestination) {
        var baseParams = Dictionary<String, Any>()
        switch self {
        case let .getTcReport(fileName, liftNumber, mapImgBase64, dateVal):
            baseParams["fileName"] = fileName
            baseParams["liftNumber"] = liftNumber
            baseParams["mapImgBase64"] = mapImgBase64
            baseParams["dateVal"] = dateVal
            let destination =  destination(path: "/getAppTcReport/", name: fileName)
            return (DDBaseUrl + "/tcreport/getTcReport", baseParams, destination)
            
        case let .kpiNew(fileName, liftNumber, dateVal, flag):
            baseParams["fileName"] = fileName
            baseParams["liftNumber"] = liftNumber
            baseParams["dateVal"] = dateVal
            baseParams["flag"] = flag
            let destination =  destination(path: "/kpiNew/", name: fileName)
            return (DDBaseUrl + "/report/kpiNew", baseParams, destination)
        }
    }
    
    private func destination(path: String, name: String) -> DownloadDestination {
        DDShared.shared.createPath(path)
        let localPath = DDAppInfo.ducumentPath + path + name
        return { temporaryURL, response in
            return (URL(fileURLWithPath: localPath), [.removePreviousFile, .createIntermediateDirectories])
        }
    }
}

/// 遵循Moya TargetType 协议
extension DDDownloadApi: TargetType {
    public var baseURL: URL {
        return URL(string: handleResult.url.replacingOccurrences(of: " ", with: ""))!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    public var task: Task {
        return .downloadParameters(parameters: handleResult.params, encoding: JSONEncoding.prettyPrinted, destination: handleResult.destination)
    }
    
    public var headers: [String : String]? {
        guard let token = DDShared.shared.token, let cookie = DDShared.shared.cookie else { return nil }
        return ["Authorization": token, "Cookie": cookie, "Content-Type": "application/json; charset=utf-8"]
    }
    
    public var description: String {
        return "api:\(self)\npath:\(handleResult.url)\n\nparams:\n\(handleResult.params)"
    }
}
