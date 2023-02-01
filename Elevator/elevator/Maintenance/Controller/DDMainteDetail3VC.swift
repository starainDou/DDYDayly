//
//  DDMainteDetail3VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView

class DDMainteDetail3VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

extension DDMainteDetail3VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
