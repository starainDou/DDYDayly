//
//  DDDashLineView.swift
//  elevator
//
//  Created by ddy on 2023/2/13.
//

import UIKit

class DDDashLineView: UIView {

    private(set) lazy var shapeLayer: CAShapeLayer = CAShapeLayer().then {
        $0.fillColor = UIColor.clear.cgColor
        $0.strokeColor = UIColor(hex: "#EEEEEE").cgColor
        $0.lineWidth = 1
        $0.lineJoin = CAShapeLayerLineJoin.round
        $0.lineDashPhase = 0 //从哪个位置开始
        $0.lineDashPattern = [NSNumber(value: 10), NSNumber(value: 5)]
    }
    
    var isHorizontal: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shapeLayer.bounds != bounds {
            shapeLayer.bounds = bounds
            shapeLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            let path = CGMutablePath()
            if isHorizontal {
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: bounds.width, y: 0))
            } else {
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: bounds.height))
            }
            shapeLayer.path = path
        }
    }
}
