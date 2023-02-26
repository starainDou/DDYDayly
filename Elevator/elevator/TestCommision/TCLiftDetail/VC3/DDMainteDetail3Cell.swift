//
//  DDMainteDetail3Cell.swift
//  elevator
//
//  Created by ddy on 2023/2/5.
//

import UIKit
import SwiftyJSON

class DDMainteDetail3Cell: UITableViewCell {
    
    private var actionBlock: (() -> Void)?
    
    private lazy var dotView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#3E2AFF")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 3
    }
    
    private lazy var dashLineView: DDDashLineView = DDDashLineView().then {
        $0.isHorizontal = false
    }
    
    private lazy var stackView: UIStackView = UIStackView().then {
        $0.addArrangedSubviews(sectionView, item1View, item2View, item3View, item4View, item5View, item6View)
        $0.axis = .vertical
    }
    
    private lazy var sectionView: DDMainteDetail3Section = DDMainteDetail3Section()
    
    private lazy var item1View: DDMainteDetail3Item = DDMainteDetail3Item().then {
        $0.iconView.image = UIImage(named: "StartFloor")
        $0.titleLabel.text = "Start Floor"
    }
    
    private lazy var item2View: DDMainteDetail3Item = DDMainteDetail3Item().then {
        $0.iconView.image = UIImage(named: "StopFloor")
        $0.titleLabel.text = "Stop Floor"
    }
    
    private lazy var item3View: DDMainteDetail3Item = DDMainteDetail3Item().then {
        $0.iconView.image = UIImage(named: "CurrentSpeed")
        $0.titleLabel.text = "Current Load(kg)"
    }
    
    private lazy var item4View: DDMainteDetail3Item = DDMainteDetail3Item().then {
        $0.iconView.image = UIImage(named: "MoveNumber")
        $0.titleLabel.text = "Move Number"
    }
    
    private lazy var item5View: DDMainteDetail3Item = DDMainteDetail3Item().then {
        $0.iconView.image = UIImage(named: "Distance")
        $0.titleLabel.text = "Distance"
    }
    
    private lazy var item6View: DDMainteDetail3Item = DDMainteDetail3Item().then {
        $0.iconView.image = UIImage(named: "Speed")
        $0.titleLabel.text = "Speed"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubviews(dotView, stackView, dashLineView)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        dotView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(50)
            make.centerY.equalTo(sectionView)
            make.width.height.equalTo(6)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(dotView.snp.trailing).offset(9)
            make.trailing.equalToSuperview().inset(23)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(25)
        }
        dashLineView.snp.makeConstraints { make in
            make.centerX.equalTo(dotView)
            make.top.equalTo(dotView.snp.centerY)
            make.bottom.equalToSuperview().offset(5)
            make.width.equalTo(1)
        }
        sectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        item1View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        item2View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        item3View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        item4View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        item5View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        item6View.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
    }
    
    
    @objc private func expandAction() {
        actionBlock?()
    }
    
    public func loadData(_ json: JSON, action: @escaping (() -> Void)) {
        
        actionBlock = action
        
        item1View.isHidden = json["isFold"].boolValue
        item2View.isHidden = json["isFold"].boolValue
        item3View.isHidden = json["isFold"].boolValue
        item4View.isHidden = json["isFold"].boolValue
        item5View.isHidden = json["isFold"].boolValue
        item6View.isHidden = json["isFold"].boolValue
        
        item1View.textLabel.text = json["startFloor"].stringValue
        item2View.textLabel.text = json["stopFloor"].stringValue
        item3View.textLabel.text = json["currentLoad"].stringValue
        item4View.textLabel.text = json["numberofDoorMovement"].stringValue
        item5View.textLabel.text = json["distance"].stringValue
        item6View.textLabel.text = json["speed"].stringValue
        
        sectionView.timeLabel.text =  json["time"].stringValue
        sectionView.arrowButton.setImage(UIImage(named: json["isFold"].boolValue ? "ArrowTop" : "ArrowBottom"), for: .normal)
    }
}
