//
//  DDUserModel.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import UIKit
import SwiftyJSON

class DDUserModel: NSObject {
    var rolename = ""
    var username = ""
    var firstname = ""
    var lastname = ""
    var address = ""
    var createby = ""
    var createtime = ""
    var email = ""
    var id = 0
    var idcard = ""
    var language = ""
    var lastupdatetime = ""
    var mobile = ""
    var password = ""
    var portrait = ""
    var portraitfilename = ""
    var preferreddashboardwidget = ""
    var preferrednotification = ""
    var regionids = ""
    var regionname = ""
    var roleid = 0
    var state = ""
    var version = ""
    
    init(_ json: JSON) {
        rolename = json["rolename"].stringValue
        username = json["username"].stringValue
        firstname = json["firstname"].stringValue
        lastname = json["lastname"].stringValue
        address = json["address"].stringValue
        createby = json["createby"].stringValue
        createtime = json["createtime"].stringValue
        email = json["email"].stringValue
        id = json["id"].intValue
        idcard = json["idcard"].stringValue
        language = json["language"].stringValue
        lastupdatetime = json["lastupdatetime"].stringValue
        mobile = json["mobile"].stringValue
        password = json["password"].stringValue
        portrait = json["portrait"].stringValue
        portraitfilename = json["portraitfilename"].stringValue
        preferreddashboardwidget = json["preferreddashboardwidget"].stringValue
        preferrednotification = json["preferrednotification"].stringValue
        regionids = json["regionids"].stringValue
        regionname = json["regionname"].stringValue
        roleid = json["roleid"].intValue
        state = json["state"].stringValue
        version = json["version"].stringValue
    }
}
