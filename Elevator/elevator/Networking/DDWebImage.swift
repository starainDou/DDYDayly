//
//  DDWebImage.swift
//  elevator
//
//  Created by ddy on 2023/3/3.
//

import UIKit
import Kingfisher

class DDWebImage: NSObject {
    
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
    
    static func setImage(_ img: String, imageView: UIImageView) {
        let url = URL(string: DDBaseUrl + "/fileApp/getImageOfLift/\(img)")
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "Icon218"), options: [.requestModifier(modifier)])
    }
    
    static func setAvatar(_ img: String, imageView: UIImageView) {
        let url = URL(string: DDBaseUrl + "/file/getImages/\(img)")
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "AvatarDefault"), options: [.requestModifier(modifier)])
    }
}
