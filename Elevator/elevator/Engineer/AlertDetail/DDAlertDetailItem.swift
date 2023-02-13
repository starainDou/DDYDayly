//
//  DDAlertDetailItem.swift
//  elevator
//
//  Created by ddy on 2023/2/12.
//

import UIKit
import DDYSwiftyExtension

class DDAlertDetailItem: UIView {

    private lazy var avatarView: UIImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22
    }
    
    private lazy var nameLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)        
    }
    
    private lazy var dateLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private lazy var funcLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#1ECAA1")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 4
        flowLayout.itemSize = CGSize(width: 70, height: 70)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.ddy_register(cellClass: InnerCell.self)
        return collectionView
    }()

    private lazy var grayView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F1F5FF")
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private lazy var textView: UITextView = UITextView().then {
        $0.textColor = UIColor(hex: "#666666")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.isEditable = false
        $0.backgroundColor = UIColor(hex: "#F3F3F3")
    }
    
    private lazy var dashView: DDDashLineView = DDDashLineView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(avatarView, nameLabel, dateLabel, funcLabel, collectionView, grayView, textView, dashView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        avatarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(33)
            make.top.equalToSuperview().inset(16)
            make.width.height.equalTo(44)
        }
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(avatarView.snp.centerY).offset(-2)
            make.leading.equalTo(avatarView.snp.trailing).offset(8)
        }
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(15)
        }
        funcLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nameLabel)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(33)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(70)
        }
        grayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(82)
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(15)
        }
        textView.snp.makeConstraints { make in
            make.edges.equalTo(grayView).inset(UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14))
        }
        dashView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(85)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(1)
            make.top.equalToSuperview()
        }
    }
    
    public func loadData() {
        avatarView.backgroundColor = .lightGray
        nameLabel.text = "Molly";
        funcLabel.text = "Update"
        dateLabel.text = "09/11 10:06:00"
        textView.text = "Maintenance/1200 Brakes and Gear box/1201 Examine for abormal noise, contamination, damage,"
    }
}

extension DDAlertDetailItem: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 2
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.ddy_dequeueReusableCell(InnerCell.self, for: indexPath)
            cell.loadData()
            return cell
        }
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            
        }
    }

fileprivate class InnerCell: UICollectionViewCell {
    private lazy var imgView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(imgView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func loadData() {
        imgView.backgroundColor = .lightGray
    }
}
