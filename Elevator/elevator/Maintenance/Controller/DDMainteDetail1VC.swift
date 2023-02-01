//
//  DDMainteDetail1VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView

class DDMainteDetail1VC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension DDMainteDetail1VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
