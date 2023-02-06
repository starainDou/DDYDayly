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
    var state: String = ""
    /// 品牌
    var brand: String = ""
    /// 时间
    var time: String = ""
    /// 地址
    var address: String = ""
    /// 单元号
    var unit: String = ""
    /// 型号
    var model: String = ""
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
    
    
    init(liftsBystatus json: JSON) {
        address = json["address"].stringValue
        createtime = json["createtime"].stringValue
        number = json["liftnumber"].stringValue
        brand = json["brand"].stringValue
        id = json["id"].stringValue
    }
}
