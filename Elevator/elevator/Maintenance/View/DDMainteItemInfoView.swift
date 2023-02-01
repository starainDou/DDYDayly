//
//  DDMainteItemInfoView.swift
//  elevator
//
//  Created by ddy on 2023/2/1.
//

import UIKit

class DDMainteItemInfoView: UIView {

    private(set) lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#333333")
    }
    
    private(set) lazy var infoLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#7C80B8")
    }
    
    private(set) lazy var shapeLayer: CAShapeLayer = CAShapeLayer().then {
        $0.fillColor = UIColor.clear.cgColor
        $0.strokeColor = UIColor(hex: "#EEEEEE").cgColor
        $0.lineWidth = 1
        $0.lineJoin = CAShapeLayerLineJoin.round
        $0.lineDashPhase = 0 //从哪个位置开始
        $0.lineDashPattern = [NSNumber(value: 10), NSNumber(value: 5)]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(titleLabel, infoLabel)
        layer.addSublayer(shapeLayer)
        setViewConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shapeLayer.bounds != bounds {
            shapeLayer.bounds = bounds
            shapeLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 20, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width - 18, y: bounds.height))
            shapeLayer.path = path
        }
    }
    
    private func setViewConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(23)
            make.top.equalToSuperview().inset(14)
            make.trailing.lessThanOrEqualTo(self.snp.centerX)
        }
        infoLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(23)
            make.top.equalToSuperview().inset(14)
            make.height.greaterThanOrEqualTo(15)
            make.bottom.equalToSuperview().inset(14)
            make.leading.greaterThanOrEqualTo(self.snp.centerX)
        }
    }
}
