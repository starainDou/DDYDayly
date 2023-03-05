//
//  DDWebImage.swift
//  elevator
//
//  Created by ddy on 2023/3/3.
//

import UIKit
import Kingfisher
import SwiftyJSON
import ProgressHUD

class DDWebImage: NSObject {
    
    static func imgBase(_ img: String) -> URL? {
        return URL(string: "http://steecd.imwork.net:54265/lift-mgmt-server/file/getImages/\(img)?random=0.0786746724668026")
    }
    
    static var modifier = AnyModifier { request in
        var r = request
        if let token = DDShared.shared.token {
            r.setValue(token , forHTTPHeaderField: "Authorization")
        }
        if let cookie = DDShared.shared.cookie {
            r.setValue(cookie , forHTTPHeaderField: "Cookie")
        }
        return r
    }
    
    static func setAvatar(_ img: String, imageView: UIImageView) {
        let url = URL(string: DDBaseUrl + "/file/getImages/\(img)")
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "AvatarDefault"), options: [.requestModifier(modifier)])
    }
}
