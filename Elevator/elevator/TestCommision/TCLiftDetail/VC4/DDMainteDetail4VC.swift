//
//  DDMainteDetail4VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView
import SwiftyJSON

class DDMainteDetail4VC: UIViewController {
    
    var liftBaseJson: JSON = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension DDMainteDetail4VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
