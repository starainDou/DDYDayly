//
//  DDLabelCell.swift
//  elevator
//
//  Created by ddy on 2023/1/29.
//

import UIKit
import Then

class DDLabelCell: UITableViewCell {
    private lazy var floorLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
    }
    
    private lazy var tagLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = UIColor(hex: "#333333")
    }
    
    private lazy var shapeLayer: CAShapeLayer = CAShapeLayer().then {
        $0.fillColor = UIColor.clear.cgColor
        $0.strokeColor = UIColor(hex: "#EEEEEE").cgColor
        $0.lineWidth = 1
        $0.lineJoin = CAShapeLayerLineJoin.round
        $0.lineDashPhase = 0 //从哪个位置开始
        $0.lineDashPattern = [NSNumber(value: 10), NSNumber(value: 5)]
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(floorLabel, tagLabel)
        contentView.layer.addSublayer(shapeLayer)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shapeLayer.bounds != contentView.bounds {
            shapeLayer.bounds = contentView.bounds
            shapeLayer.position = CGPoint(x: contentView.bounds.width / 2, y: contentView.bounds.height / 2)
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: contentView.bounds.height))
            path.addLine(to: CGPoint(x: contentView.bounds.width, y: contentView.bounds.height))
            shapeLayer.path = path
        }
    }
    
    private func setViewConstraints() {
        floorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
        }
        tagLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(60)
            make.centerY.equalToSuperview()
        }
    }
    
    public func loadData(floor: String, label: String, isSelected: Bool) {
        floorLabel.text = floor
        tagLabel.text = label
        floorLabel.textColor = isSelected ? UIColor(hex: "#FFFFFF") : UIColor(hex: "#333333")
        tagLabel.textColor = isSelected ? UIColor(hex: "#FFFFFF") : UIColor(hex: "#333333")
        contentView.backgroundColor = isSelected ? UIColor(hex: "#168991") : UIColor(hex: "#FFFFFF")
    }
}
