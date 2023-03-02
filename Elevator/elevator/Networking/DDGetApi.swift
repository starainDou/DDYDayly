//
//  DDGetApi.swift
//  elevator
//
//  Created by ddy on 2023/1/18.
//

import Foundation
import Moya

public enum DDGetApi {
    /// 通用请求方式
    case getUniversal(url: String, params: [String: Any])
    /// 用户登出
    case doApplogout(id: String)
    /// sensor验证
    case getSensor(deviceId: String)
    /// 根据状态查询电梯
    case getLiftsBystatus(status: String, page: String, limit: String, liftnumber: String?)
    /// 查询lift的状态信息
    case getStatusOfLift(id: String)
    /// 查询警报详情
    case getDetailOfAlarm(id: String, userId: String)
    /// 梯性能统计
    case summaryOfLiftPerformance(summaryType: String, showType: String)
    /// 电梯问题比例统计
    case showPieChart
    /// 查询物业的警报信息
    case getAlarmsOfTownCouncil(townCouncil: String)
    /// 查询电梯的警报详情信息
    case getDetailsOfLiftAlarm(liftNumber: String)
    /// 查询alarm remark
    case getAlarmRemark(parentId: String)
    /// 查询警报位置
    case getLocationOfAlarms(userId: String, severity: String)
    /// 查询电梯设备的信息
    case getMessageOfLiftDevice(liftId: String)
}

extension DDGetApi {
    internal var handleResult: (url: String, params: [String: Any]) {
        var baseParams = Dictionary<String, Any>()
        switch self {
        case let .getUniversal(url, params):
            baseParams.merge(params) { first, second in first }
            return (url, baseParams)
            
        case let .doApplogout(id):
            baseParams["id"] = id
            return (DDBaseUrl + "/doApplogout", baseParams)
            
        case let .getSensor(deviceId):
            return (DDBaseUrl + "/getSensor/" + deviceId, baseParams)
            
        case let .getLiftsBystatus(status, page, limit, liftnumber):
            baseParams["liftNumber"] = liftnumber
            return (DDBaseUrl + "/liftapp/getLiftsBystatus/\(status)/\(page)/\(limit)", baseParams)
            
        case let .getStatusOfLift(id):
            return (DDBaseUrl + "/liftapp/getStatusOfLift/\(id)", baseParams)
            
        case let .getDetailOfAlarm(id, userId):
            return (DDBaseUrl + "/alarmapp/getDetailOfAlarm/\(id)/\(userId)", baseParams)
            
        case let .summaryOfLiftPerformance(summaryType, showType):
            return (DDBaseUrl + "/alarmapp/summaryOfLiftPerformance/\(summaryType)/\(showType)", baseParams)
            
        case .showPieChart:
            return (DDBaseUrl + "/alarmapp/showPieChart", baseParams)
            
        case let .getAlarmsOfTownCouncil(townCouncil):
            return (DDBaseUrl + "/alarmapp/getAlarmsOfTownCouncil/\(townCouncil)", baseParams)
            
        case let .getDetailsOfLiftAlarm(liftNumber):
            return (DDBaseUrl + "/alarmapp/getDetailsOfLiftAlarm/\(liftNumber)", baseParams)
            
        case let .getAlarmRemark(parentId):
            return (DDBaseUrl + "/alarmapp/getAlarmRemark/\(parentId)", baseParams)
            
        case let .getLocationOfAlarms(userId, severity):
            return (DDBaseUrl + "/alarmapp/getLocationOfAlarms/\(userId)/\(severity)", baseParams)
        case let.getMessageOfLiftDevice(liftId):
            return (DDBaseUrl + "/alarmapp/getMessageOfLiftDevice/\(liftId)", baseParams)
        }
    }
}

extension DDGetApi: TargetType {
    
    public var baseURL: URL {
        return URL(string: handleResult.url.replacingOccurrences(of: " ", with: ""))!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    public var task: Task {
        return .requestParameters(parameters: handleResult.params, encoding: URLEncoding.queryString)
    }
    
    public var headers: [String : String]? {
        guard let token = DDShared.shared.token, let cookie = DDShared.shared.cookie else { return nil }
        return ["Authorization": token, "Cookie": cookie]
    }
    
    public var description: String {
        return "api:\(self)\npath:\(handleResult.url)\n\nparams:\n\(handleResult.params)"
    }
}
