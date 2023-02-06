//
//  DDSensorModel.swift
//  elevator
//
//  Created by ddy on 2023/2/6.
//

import UIKit
import SwiftyJSON

class DDSensorModel: NSObject {
    var timeStamp: String = ""
    var deviceId: String = ""
    var status: String = ""
    var lastUpdateTime: String = ""
    var liftNumber: String = ""
    
    var readyState: String {
        if status == "1" {
            return "Ready"
        } else if status == "2" {
            return "Binded Lift"
        } else {
            return "Not Ready"
        }
    }
    
    init(_ id: String) {
        deviceId = id
        timeStamp = DDAppInfo.timeStamp()
        status = "0"
        lastUpdateTime = DateFormatter().then { $0.dateFormat = "MM/dd/yyyy HH:mm:ss" }.string(from: Date())
    }
    
    init(_ json: JSON) {
        deviceId = json["deviceId"].stringValue
        lastUpdateTime = json["lastUpdateTime"].stringValue
        status = json["status"].stringValue
        liftNumber = json["liftNumber"].stringValue
    }
}
