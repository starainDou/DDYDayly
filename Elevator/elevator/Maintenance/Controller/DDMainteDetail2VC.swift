//
//  DDMainteDetail2VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView

class DDMainteDetail2VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension DDMainteDetail2VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
