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
    var serialnumber: String = ""
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
        serialnumber = json["serialnumber"].stringValue
    }
    
}

/*
 
 {
     address = "BLK 678C PUNGGOL DRIVE S823678";
     agecolor = "<null>";
     "any_other_lift_serving_these_du" = "<null>";
     "any_other_lifts_units" = "";
     "aps_install_place" = "<null>";
     "aps_location" = "<null>";
     "aps_placement_location" = "<null>";
     base64Img = "<null>";
     batchno = "<null>";
     block = "<null>";
     brand = IFE;
     brandcolor = "<null>";
     breakdownprobability = "<null>";
     capacity = "<null>";
     "car_control" = "";
     component = "<null>";
     componenttype = "<null>";
     comstatus = "<null>";
     contractterm = "<null>";
     createtime = 1617266107000;
     "cross_beam_type" = "<null>";
     dashboardLiftAlarm = "<null>";
     description = "";
     "device_status" = "<null>";
     deviceid = "<null>";
     deviceids = "<null>";
     "door_current_sensor" = "<null>";
     "door_opening" = "<null>";
     doorcurrentsensorinstallationmethod = "<null>";
     doormotortype = "<null>";
     "drive_type" = "";
     floor = "<null>";
     fromDate = "<null>";
     id = 731b221236024bd69c95af41441cb758;
     installtime = 1640966400000;
     labelmapping = "[{\"label\":\"B2\"},{\"label\":\"B1\"},{\"label\":\"1\"},{\"label\":\"2\"},{\"label\":\"3\"},{\"label\":\"4\"},{\"label\":\"5\"},{\"label\":\"6\"},{\"label\":\"7\"},{\"label\":\"8\"},{\"label\":\"9\"},{\"label\":\"10\"},{\"label\":\"11\"},{\"label\":\"12\"},{\"label\":\"13\"},{\"label\":\"14\"},{\"label\":\"15\"},{\"label\":\"16\"},{\"label\":\"17\"}]";
     landings = 19;
     "last_replaced_by" = "<null>";
     "last_replaced_date" = "<null>";
     lastmaintenancetime = "<null>";
     lastupdatetime = 1647401083191;
     lat = "1.405907";
     liftName = "<null>";
     liftState = "<null>";
     liftState2 = "<null>";
     "lift_code" = "<null>";
     "lift_company" = "<null>";
     "lift_installation_date" = "<null>";
     "lift_model" = "<null>";
     "lift_shaft_type" = "<null>";
     "lift_type" = "<null>";
     liftage = "<null>";
     liftalarmstatus = "<null>";
     liftnumber = 823678A;
     liftstatus = "<null>";
     lng = "103.909102";
     location = "";
     locationid = 2bb6a1e5b79d48a090c064a48ef8a572;
     "lpms_commission_date" = "<null>";
     "lpms_status" = "<null>";
     "maintenance_status" = "<null>";
     minscheduletype = "<null>";
     modelid = 7217ebb7d3014649bfc2e77f71699062;
     modelname = IFE;
     "motor_room_location" = "";
     "mpu_placement_method" = "<null>";
     mpuplacementlocation = "<null>";
     nextmaintenancetime = "<null>";
     "no_of_ropes" = "<null>";
     "number_of_dwelling_units" = "";
     "number_of_dwelling_units_served" = "<null>";
     "number_of_landings_served" = "<null>";
     "person_capacity" = "<null>";
     "peu_power_source" = "<null>";
     plandescription = "<null>";
     planid = "<null>";
     planname = "<null>";
     "postal_code" = "<null>";
     "power_source_to_peu" = "<null>";
     regionid = "<null>";
     regionidforsub = "<null>";
     regionname = "<null>";
     "rope_sensor_type" = "<null>";
     ropesensor = "<null>";
     ropesensortype = "<null>";
     "roping_system" = "";
     sensors = "<null>";
     serialnumber = "<null>";
     showcolor = "<null>";
     speed = "<null>";
     status = 1;
     statuslevel = "<null>";
     storey = "<null>";
     street = "<null>";
     tenant = "";
     toDate = "<null>";
     "town_council" = "<null>";
     "type_of_door_opening" = "";
     "type_of_lift_shaft" = "";
     "type_of_rope_sensor" = "<null>";
     "use_code" = "";
     userid = "<null>";
     ward = "<null>";
     "zoning_of_lift" = "";
 }
 */
