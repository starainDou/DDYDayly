//
//  DDDetailMenuView.swift
//  elevator
//
//  Created by ddy on 2023/1/31.
//

import UIKit

class DDDetailMenuView: UIView {
    
    private(set) lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hex: "#666666")
        $0.numberOfLines = 0
    }
    
    private lazy var backView: UIView = UIView().then  {
        $0.backgroundColor = UIColor(hex: "#F3F3F3")
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private(set) lazy var textLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .right
    }
    
    private(set) lazy var rightButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ArrowBottom"), for: .normal)
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
        addSubviews(titleLabel, backView, textLabel, rightButton)
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
            path.move(to: CGPoint(x: 15, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width - 15, y: bounds.height))
            shapeLayer.path = path
        }
    }
    
    private func setViewConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(backView.snp.leading).offset(-7)
        }
        backView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(26)
            make.leading.equalTo(self.snp.centerX).offset(-20)
        }
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(5)
            make.top.bottom.equalTo(backView)
            make.trailing.equalTo(rightButton.snp.leading).offset(-3)
        }
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(backView).inset(3)
            make.width.height.equalTo(24)
        }
    }
   
}
