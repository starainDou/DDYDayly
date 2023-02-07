//
//  DDLiftModel.swift
//  elevator
//
//  Created by ddy on 2023/1/29.
//

import Foundation
import SwiftyJSON

class DDLiftModel: NSObject {
    /// 编号  581923121
    var number: String = ""
    /// 状态
    var status: String = ""
    /// 品牌
    var brand: String = ""
    /// 安装时间
    var installtime: String = ""
    /// 地址
    var address: String = ""
    /// 单元号
    var unit: String = ""
    /// 型号
    var modelid: String = ""
    /// 传感器 HWW111400000502
    var sensor: String = ""
    /// 载量
    var landing: Int = 0
    /// 合同条款
    var term: String = ""
    /// 描述
    var profile: String = ""
    /// 位置
    var location: String = ""
    /// 承租人
    var tenant: String = ""
    /// 载客人数
    var capacity: Int = 0
    /// 绳索数量
    var ropes: Int = 0
    /// 挂绳系统
    var ropingSystem: String = ""
    /// 开门类型
    var DoorType: String = ""
    /// 车控
    var carControl: String = ""
    /// 使用模式
    var useMode: String = ""
    /// 速度
    var speed: String = ""
    /// 驱动类型
    var driveType: String = ""
    /// 电机房位置
    var motorLocation: String = ""
    /// 轴类型
    var shaftType: String = ""
    /// 电梯分区
    var zoning: String = ""
    /// 出路单位数
    var dewingUnits: String = ""
    /// 任何其他升降机单元
    var leftUnits: String = ""
    /// id
    var id: String = ""
    /// createTime
    var createtime: String = ""
    
    
    ///
    var brandcolor: String = ""
    
    var batchno: String = ""
    
    var locationid: String = ""
    
    var planid: String = ""
    
    var lastupdatetime: String = ""
    var nextmaintenancetime: String = ""
    var lastmaintenancetime: String = ""
    var regionid: String = ""
    var landings: String = ""
    var contractterm: String = ""
    var sensors: String = ""
    var labelmapping: String = ""
    var regionidforsub: String = ""
    var dashboardLiftAlarm: String = ""
    var person_capacity: String = ""
    var no_of_ropes: String = ""
    var roping_system: String = ""
    var type_of_door_opening: String = ""
    var car_control: String = ""
    var use_code: String = ""
    var drive_type: String = ""
    var motor_room_location: String = ""
    var ropesensor: String = ""
    var fromDate: String = ""
    var toDate: String = ""
    var showcolor: String = ""
    var agecolor: String = ""
    var userid: String = ""
    var lat: String = ""
    var lng: String = ""
    var planname: String = ""
    var comstatus: String = ""
    var liftalarmstatus: String = ""
    var componenttype: String = ""
    var component: String = ""
    var plandescription: String = ""
    var breakdownprobability: String = ""
    var base64Img: String = ""
    var liftState: String = ""
    var liftState2: String = ""
    var floor: String = ""
    var statuslevel: String = ""
//    var <#planid#>: String = ""
    
    
    init(liftsBystatus json: JSON) {
        address = json["address"].stringValue
        createtime = json["createtime"].stringValue
        number = json["liftnumber"].stringValue
        brand = json["brand"].stringValue
        id = json["id"].stringValue
    }
    
    init(liftDetail json: JSON) {
        address = json["address"].stringValue
        createtime = json["createtime"].stringValue
        number = json["liftnumber"].stringValue
        brand = json["brand"].stringValue
        id = json["id"].stringValue
        brandcolor = json["brandcolor"].stringValue
        batchno = json["batchno"].stringValue
        installtime = json["installtime"].stringValue
        profile = json["description"].stringValue
        locationid = json["locationid"].stringValue
        modelid = json["modelid"].stringValue
        planid = json["planid"].stringValue
        status = json["status"].stringValue
        lastupdatetime = json["lastupdatetime"].stringValue
        nextmaintenancetime = json["nextmaintenancetime"].stringValue
        lastmaintenancetime = json["lastmaintenancetime"].stringValue
        regionid = json["regionid"].stringValue
        landings = json["landings"].stringValue
        contractterm = json["contractterm"].stringValue
        sensors = json["sensors"].stringValue
        labelmapping = json["labelmapping"].stringValue
        regionidforsub = json["regionidforsub"].stringValue
        dashboardLiftAlarm = json["dashboardLiftAlarm"].stringValue
        location = json["location"].stringValue
        tenant = json["tenant"].stringValue
        person_capacity = json["person_capacity"].stringValue
        no_of_ropes = json["no_of_ropes"].stringValue
        roping_system = json["roping_system"].stringValue
        type_of_door_opening = json["type_of_door_opening"].stringValue
        car_control = json["car_control"].stringValue
        use_code = json["use_code"].stringValue
        speed = json["speed"].stringValue
        drive_type = json["drive_type"].stringValue
        motor_room_location = json["motor_room_location"].stringValue
        ropesensor = json["ropesensor"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        showcolor = json["showcolor"].stringValue
        agecolor = json["agecolor"].stringValue
        userid = json["userid"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        planname = json["planname"].stringValue
        comstatus = json["comstatus"].stringValue
        liftalarmstatus = json["liftalarmstatus"].stringValue
        componenttype = json["componenttype"].stringValue
        component = json["component"].stringValue
        plandescription = json["plandescription"].stringValue
        breakdownprobability = json["breakdownprobability"].stringValue
        base64Img = json["base64Img"].stringValue
        liftState = json["liftState"].stringValue
        liftState2 = json["liftState2"].stringValue
        floor = json["floor"].stringValue
        statuslevel = json["statuslevel"].stringValue
    }
    
}

/*
 
 { "id": "4d299afdd5f442f2a93b23a802e11ff3", "liftnumber": "570203D", "brand": "EMS", "createtime": "2021-04-01T08:35:03.000+0000", "address": null,
 
 "brandcolor": null, "batchno": null, "installtime": "2021-04-01T08:35:03.000+0000", "description": null, "locationid": "0c967b22d0e146718d503be721fbb748", "modelid": "a4c465e9096f4dc1992c32ec6a9999d6", "planid": null, "status": 1, "lastupdatetime": null, "nextmaintenancetime": null, "lastmaintenancetime": null, "regionid": null, "landings": 4, "contractterm": null, "sensors": null, "labelmapping": "[{\"label\":\"1\"},{\"label\":\"2\"},{\"label\":\"3\"},{\"label\":\"4\"}]", "regionidforsub": null, "dashboardLiftAlarm": null, "location": null, "tenant": null, "person_capacity": null, "no_of_ropes": null, "roping_system": null, "type_of_door_opening": null, "car_control": null, "use_code": null, "speed": null, "drive_type": null, "motor_room_location": null, "ropesensor": null, "fromDate": null, "toDate": null, "showcolor": null, "agecolor": null, "userid": null, "lat": 1.354722, "lng": 103.847213, "planname": null, "modelname": null, "deviceid": null, "deviceids": null, "regionname": null, "liftage": null, "minscheduletype": null, "liftstatus": null, "comstatus": null, "liftalarmstatus": null, "componenttype": null, "component": null, "plandescription": null, "breakdownprobability": null, "base64Img": null, "liftState": null, "liftState2": null, "floor": null, "statuslevel": null }
 */
