//
//  DDNetManager.swift
//  elevator
//
//  Created by ddy on 2023/1/18.
//

import Foundation
import Moya
import ProgressHUD

// internal let DDBaseUrl: String = "https://dev.agiliot.io/cms/api"
internal let DDBaseUrl: String = "https://smartlift.agiliot.io/cms/api"
//https://smartlift.agiliot.io:8443"//"https://dev.agiliot.io:8443"

fileprivate extension TargetType {
    var info: String {
        switch self.task {
        case let .requestParameters(parameters, _):
            return "\(self)\n\(self.baseURL.absoluteString)\n\(parameters)"
        default:
            return "\(self)\n\(self.baseURL.absoluteString)\n\(self.task)"
        }
    }
}

// MARK: 设置请求参数[缓存/超时/内容类型等]
fileprivate let DDNetProvider = MoyaProvider<MultiTarget>(requestClosure: { (endpoint: Endpoint, done: @escaping MoyaProvider.RequestResultClosure) in
    guard var urlRequest = try? endpoint.urlRequest() else { return }
    urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    urlRequest.timeoutInterval = 30
    urlRequest.allHTTPHeaderFields = ["Content-Type": "text/html; charset=utf-8"]
    done(.success(urlRequest))
})

// MARK: 结果统一处理
fileprivate func handleResult(target:TargetType, moyaResult: Result<Moya.Response, MoyaError>, success: @escaping DDNetSuccess, failure:@escaping DDNetFailure) {
    
    switch moyaResult {
    case .success(let response):
        do {
            let responseJson = try moyaResult.get().mapJSON()
            if let responseDict = responseJson as? Dictionary<String, Any> {
                let code = responseDict["code"]
                let responseCode: String = (code is Int) ? String(code as! Int) : (code as? String ?? "")
                if responseCode == "200" {
                    success(responseDict, responseDict["msg"] as? String)
                } else {
                    // 自定义错误码[10014:token无效 10017:强制更新]
                    failure(responseCode, responseDict["msg"] as? String)
                }
                DDNetPrint("\(target.info)\nresponseJson:\n\(responseJson)\nresponseDictionary:\n\(responseDict)")
            } else {
                failure("-998", "Data error") // 顶层必须字典
                DDNetPrint("\(target.info)\nresponseJson:\n\(responseJson)")
            }
        } catch {
            // 网络有响应，但不正确[404:资源未找到，401:请求未授权等]
            failure("\(response.statusCode)", error.localizedDescription)
            DDNetPrint("\(target.info)\nerror:\(response.statusCode) \(error.localizedDescription)")
            if response.statusCode == 200 {
//                DDShared.shared.user = nil
//                DDShared.shared.token = ""
//                DDShared.shared.event.logInOrOut.onNext(false)
//                ProgressHUD.showFailed("Session has timed out", interaction: false, delay: 3)
            }
        }
    case .failure(let moyaError):
        // 无网络、超时、意外等无响应
        if let moyaErrorResponse = moyaError.response {
            failure("\(moyaErrorResponse.statusCode)", "Request Failed")
        } else {
            failure("-999", "Request Failed")
        }
        DDNetPrint("\(target.info)\nerror:\(moyaError.errorDescription ?? "网络问题，请求失败")")
    }
}

public typealias DDNetSuccess = (_ result: Dictionary<String, Any>, _ msg: String?) -> ()
public typealias DDNetFailure = (_ code: String,_ msg: String?) -> ()
public typealias DDNetProgress = (_ progress: Double) -> Void


@discardableResult
public func DDGet(target: DDGetApi, success: @escaping DDNetSuccess, failure :@escaping DDNetFailure) -> Cancellable {
    return DDNetProvider.request(MultiTarget(target)) { (moyaResult) in
        handleResult(target: target, moyaResult: moyaResult, success: success, failure: failure)
    }
}

@discardableResult
public func DDPost(target: DDPostApi, success: @escaping DDNetSuccess, failure:@escaping DDNetFailure) -> Cancellable {
    return DDNetProvider.request(MultiTarget(target)) { (moyaResult) in
        handleResult(target: target, moyaResult: moyaResult, success: success, failure: failure)
    }
}

@discardableResult
public func DDUpload(target: DDUploadApi, progress: @escaping DDNetProgress, success: @escaping DDNetSuccess, failure:@escaping DDNetFailure) -> Cancellable {
    DDNetProvider.request(MultiTarget(target), progress: { (responseProgress) in
        progress(responseProgress.progress)
    }, completion: { (moyaResult) in
        handleResult(target: target, moyaResult: moyaResult, success: success, failure: failure)
    })
}
