//
//  DDNetworkApi.swift
//  elevator
//
//  Created by ddy on 2023/1/18.
//

import Moya
import Moya

public enum DDPostApi {
    /// 通用请求方式
    case postUniversal(url: String, params: [String: Any])
    /// 用户登录
    case doAppLogin(username: String, password: String)
    /// 获取lift status
    case getLiftStatus(liftnumber: String, userid: String)
    /// 获取电梯警报列表
    case getLiftAlarmList(page: String, limit: String, sensors: String, userid: String)
    /// 获取电lift KPI
    case getLiftKpi(liftnumber: String) // 重复错误
    /// getSingleRide
    case getSingleRide(liftnumber: String, daterange: [String])
    /// 获取电梯详情
    case getLiftDetail(liftId: String)
    /// 修改电梯详情
    case updateDetailOfLift(liftId: String)
    /// 下载KPI report
    case kpiNew(fileName: String, liftNumber: String, dateVal: String, flag: String)
    /// 解除绑定
    case removeBinding(liftNumber: String, deviceId: String)
    /// 下载T&C report
    case getAppTcReport(fileName: String, liftNumber: String, mapImgBase64: String, dateVal: String)
    /// 查找指定用户下的警报
    case getAlarmsOfLift(userid: String, page: String, limit: String, alarmType: String, severityType: String, value: String, sortType: String, dateRange: [String])
    /// 收藏警报
    case favoriteAlarm(deviceId: String, userId: String, isFavourite: String)
    /// 更新警报
    case updateStatusOfAlarm(userid: String, id: String, status: String, desc: String, natureOfTask: String, component: String, task: String, images: String)
    /// 保存图片信息
    case saveMessageOfImage(id: String, type: String, subType: String, liftNumber: String, fileName: String, description: String, before: String)
}

extension DDPostApi {
    fileprivate var handleResult: (url: String, params: [String: Any]) {
        var baseParams = Dictionary<String, Any>()
        
        switch self {
        case let .postUniversal(url, params):
            baseParams.merge(params) { first, second in first }
            return (url, baseParams)
            
        case let .doAppLogin(username, password):
            baseParams["username"] = username
            baseParams["password"] = password
            return (DDBaseUrl + "/doAppLogin", ["user": baseParams])
            
        case let .getLiftStatus(liftnumber, userid):
            baseParams["liftnumber"] = liftnumber
            baseParams["userid"] = userid
            return (DDBaseUrl + "/liftmetering/getLiftStatus", baseParams)
            
        case let .getLiftAlarmList(page, limit, sensors, userid):
            baseParams["listQuery"] = ["page": page, "limit": limit]
            baseParams["sensors"] = sensors
            baseParams["userid"] = userid
            return (DDBaseUrl + "/alarm/getLiftAlarmList", baseParams)
            
        case let .getLiftKpi(liftnumber):
            baseParams["liftnumber"] = liftnumber
            return (DDBaseUrl + "/getLiftKpi", baseParams)
            
        case let .getSingleRide(liftnumber, daterange):
            baseParams["liftnumber"] = liftnumber
            baseParams["daterange"] = daterange
            return (DDBaseUrl + "/liftmetering/getSingleRide", baseParams)
            
        case let .getLiftDetail(liftId):
            return (DDBaseUrl + "/getLiftDetail/\(liftId)", baseParams)
            
        case let .updateDetailOfLift(liftId):
            return (DDBaseUrl + "/liftapp/updateDetailOfLift/\(liftId)", baseParams)
            
        case let .kpiNew(fileName, liftNumber, dateVal, flag):
            baseParams["fileName"] = fileName
            baseParams["liftNumber"] = liftNumber
            baseParams["dateVal"] = dateVal
            baseParams["flag"] = flag
            return (DDBaseUrl + "/report/kpiNew", baseParams)
            
        case let .removeBinding(liftNumber, deviceId):
            baseParams["liftNumber"] = liftNumber
            baseParams["deviceId"] = deviceId
            return (DDBaseUrl + "/removeBinding", baseParams)
            
        case let .getAppTcReport(fileName, liftNumber, mapImgBase64, dateVal):
            baseParams["fileName"] = fileName
            baseParams["liftNumber"] = liftNumber
            baseParams["mapImgBase64"] = mapImgBase64
            baseParams["dateVal"] = dateVal
            return (DDBaseUrl + "/tcreport/getAppTcReport", baseParams)
            
        case let .getAlarmsOfLift(userid, page, limit, alarmType, severityType, value, sortType, dateRange):
            baseParams["userid"] = userid
            baseParams["page"] = page
            baseParams["limit"] = limit
            baseParams["alarmType"] = alarmType
            baseParams["severityType"] = severityType
            baseParams["value"] = value
            baseParams["sortType"] = sortType
            baseParams["dateRange"] = dateRange
            return (DDBaseUrl + "/alarmapp/getAlarmsOfLift", baseParams)
            
        case let .favoriteAlarm(deviceId, userId, isFavourite):
            baseParams["deviceId"] = deviceId
            baseParams["userId"] = userId
            baseParams["isFavourite"] = isFavourite
            return (DDBaseUrl + "/alarmapp/favoriteAlarm/\(deviceId)/\(userId)/\(isFavourite)", baseParams)
            
        case let .updateStatusOfAlarm(userid, id, status, desc, natureOfTask, component, task, images):
            baseParams["userid"] = userid
            baseParams["_id"] = id
            baseParams["status"] = status
            baseParams["desc"] = desc
            baseParams["natureOfTask"] = natureOfTask
            baseParams["component"] = component
            baseParams["task"] = task
            baseParams["images"] = images
            return (DDBaseUrl + "/alarmapp/updateStatusOfAlarm", baseParams)
            
        case let .saveMessageOfImage(id, type, subType, liftNumber, fileName, description, before):
            baseParams["id"] = id
            baseParams["type"] = type
            baseParams["subType"] = subType
            baseParams["liftNumber"] = liftNumber
            baseParams["fileName"] = fileName
            baseParams["description"] = description
            baseParams["before"] = before
            return (DDBaseUrl + "/fileApp/saveMessageOfImage", baseParams)
        }
    }
}

extension DDPostApi: TargetType {
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
        return .requestParameters(parameters: handleResult.params, encoding: JSONEncoding.default)
    }
    
    public var headers: [String : String]? {
        return ["Authorization": UserDefaults.standard.string(forKey: "DDToken") ?? ""]
    }
    
    public var description: String {
        return "api:\(self)\npath:\(handleResult.url)\n\nparams:\n\(handleResult.params)"
    }
}
