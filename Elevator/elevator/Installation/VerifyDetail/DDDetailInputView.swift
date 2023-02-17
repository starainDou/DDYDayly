//
//  DDDetailInputView.swift
//  elevator
//
//  Created by ddy on 2023/1/31.
//

import UIKit
import IQKeyboardManagerSwift

class DDDetailInputView: UIView {
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
    
    private(set) lazy var textView: IQTextView = IQTextView().then {
        $0.textColor = UIColor(hex: "#333333")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = .clear
        $0.placeholder = "Please inout content"
        $0.placeholderTextColor = UIColor(hex: "#999999")
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
        addSubviews(titleLabel, backView, textView)
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
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(5)
        }
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.bottom.equalToSuperview().inset(12)
        }
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backView).inset(8)
            make.top.bottom.equalTo(backView).inset(5)
        }
    }
    
}
