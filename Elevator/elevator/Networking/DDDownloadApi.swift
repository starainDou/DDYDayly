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
    case getAppTcReport(fileName: String, liftNumber: String, mapImgBase64: String, dateVal: String)
    case uploadAllImagesOfLift([Data], [String])
}

extension DDDownloadApi {
    internal var handleResult: (url: String, params: [String: Any]) {
        var baseParams = Dictionary<String, Any>()
        switch self {
        case let .getAppTcReport(fileName, liftNumber, mapImgBase64, dateVal):
            baseParams["fileName"] = fileName
            baseParams["liftNumber"] = liftNumber
            baseParams["mapImgBase64"] = mapImgBase64
            baseParams["dateVal"] = dateVal
            return (DDBaseUrl + "/tcreport/getAppTcReport", baseParams)
            
        case let .uploadAllImagesOfLift(datas, names):
            
            return (DDBaseUrl + "/fileApp/uploadImageOfLift", baseParams)
        }
    }
    
    private func destination(url: String, name: String) -> DownloadDestination {
        
    }
    var destination: DownloadDestination {
        return { temporaryURL, response in
            return (self.localLocation, [.removePreviousFile, .createIntermediateDirectories])
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
        return .downloadParameters(parameters: handleResult.params, encoding: JSONEncoding.prettyPrinted, destination: <#T##DownloadDestination##DownloadDestination##(_ temporaryURL: URL, _ response: HTTPURLResponse) -> (destinationURL: URL, options: DownloadRequest.Options)#>)
    }
    
    public var headers: [String : String]? {
        guard let token = DDShared.shared.token, let cookie = DDShared.shared.cookie else { return nil }
        return ["Authorization": token, "Cookie": cookie]
    }
    
    public var description: String {
        return "api:\(self)\npath:\(handleResult.url)\n\nparams:\n\(handleResult.params)"
    }
}
