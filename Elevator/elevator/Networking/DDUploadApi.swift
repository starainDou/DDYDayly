//
//  DDUploadApi.swift
//  elevator
//
//  Created by ddy on 2023/1/18.
//

import Foundation
import Moya

public enum DDUploadApi {
    case uploadImageOfLift(Data)
    case uploadAllImagesOfLift([Data])
}

extension DDUploadApi {
    internal var handleResult: (url: String, params: [MultipartFormData]) {
        var baseParams = Array<MultipartFormData>()
        switch self {
        case let .uploadImageOfLift(data):
            baseParams.append(MultipartFormData(provider: .data(data), name: "file", fileName: "image.jpg", mimeType: "image/jpeg"))
            return (DDBaseUrl + "/fileApp/uploadImageOfLift", baseParams)
        case let .uploadAllImagesOfLift(datas):
            for data in datas {
                baseParams.append(MultipartFormData(provider: .data(data), name: "file", fileName: "image.jpg", mimeType: "image/jpeg"))
            }
            return (DDBaseUrl + "/fileApp/uploadImageOfLift", baseParams)
        }
    }
}

/// 遵循Moya TargetType 协议
extension DDUploadApi: TargetType {
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
        return .uploadMultipart(handleResult.params)
    }
    
    public var headers: [String : String]? {
        guard let token = DDShared.shared.token, let cookie = DDShared.shared.cookie else { return nil }
        return ["Authorization": token, "Cookie": cookie]
    }
}
