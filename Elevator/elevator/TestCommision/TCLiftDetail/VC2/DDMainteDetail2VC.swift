//
//  DDMainteDetail2VC.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit
import JXSegmentedView
import SwiftyJSON

class DDMainteDetail2VC: UIViewController {
    
    private lazy var headerView: DDMainteDetail2Header = DDMainteDetail2Header()

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.ddy_register(cellClass: DDMainteDetail2Header.self)
        collectionView.ddy_register(cellClass: DDMainteDetail2Cell.self)
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        return collectionView
    }()
    
    var liftBaseJson: JSON = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(headerView, collectionView)
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DDMainteDetail2VC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : 22
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: DDScreen.width, height: 150)
        } else {
            return CGSize(width: (DDScreen.width - 14) / 2.0, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? UIEdgeInsets.zero : UIEdgeInsets(top: 0, left: 7, bottom: 5, right: 7)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.ddy_dequeueReusableCell(DDMainteDetail2Header.self, for: indexPath)
            
            return cell
        } else {
            let cell = collectionView.ddy_dequeueReusableCell(DDMainteDetail2Cell.self, for: indexPath)
            
            return cell
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
}

extension DDMainteDetail2VC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
