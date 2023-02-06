//
//  DDEvent.swift
//  elevator
//
//  Created by ddy on 2023/2/5.
//

import UIKit
import RxSwift

class DDEvent: NSObject {
    public let logInOrOut: PublishSubject<Bool> = PublishSubject()
}
