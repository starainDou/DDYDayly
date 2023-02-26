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
    
    private lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var topView: DDMainteDetail4TopView = DDMainteDetail4TopView()
    
    private lazy var mapView: DDMainteDetail4MapView = DDMainteDetail4MapView()
    
    private lazy var infoView: DDMainteDetail4InfoView = DDMainteDetail4InfoView()
    
    private lazy var mpuView: DDMainteDetail4MPUView = DDMainteDetail4MPUView()
    
    private lazy var peuView: DDMainteDetail4PEUView = DDMainteDetail4PEUView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubviews(topView, mapView, infoView, mpuView, peuView)
        setViewConstraints()
    }

    private func setViewConstraints() {
        scrollView.snp.makeConstraints { make in
            
        }
        topView.snp.makeConstraints { make in
            
        }
        mapView.snp.makeConstraints { make in
            
        }
        infoView.snp.makeConstraints { make in
            
        }
        mpuView.snp.makeConstraints { make in
            
        }
        peuView.snp.makeConstraints { make in
            
        }
    }
}

extension DDMainteDetail4VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
