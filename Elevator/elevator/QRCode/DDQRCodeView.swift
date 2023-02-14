//
//  DDQRCodeView.swift
//  elevator
//
//  Created by ddy on 2023/1/18.
//

import UIKit
import Then
import SnapKit

class DDQRRectView: UIView {
    
    private lazy var scanLineView: UIImageView = UIImageView(frame: self.bounds).then {
        $0.image = UIImage(named: "DDYQRCode.bundle/ScanGrid")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = UIColor(hex: "#168A8D")
    }
    // MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(scanLineView)
        startAnimation()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func startAnimation() {
        sacnAnimation(-scanLineView.bounds.size.height/2.0, self.bounds.size.height+scanLineView.bounds.size.height/2.0)
    }
    
    // MARK: 动画
    private func sacnAnimation(_ startValue: CGFloat, _ endValue: CGFloat) {
        let baseAnimation = CABasicAnimation(keyPath: "position.y")
        baseAnimation.duration = 1.8
        baseAnimation.fromValue = startValue;
        baseAnimation.toValue = endValue
        baseAnimation.repeatCount = MAXFLOAT
        baseAnimation.isRemovedOnCompletion = false
        baseAnimation.fillMode = CAMediaTimingFillMode.forwards
        baseAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn)
        scanLineView.layer.add(baseAnimation, forKey: "scanAnimation")
    }
}

class DDQRCodeView: UIView {
    
    private(set) lazy var backButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ArrowLeft"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
    }
    
    private(set) lazy var lightButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "TurnOnLight"), for: .normal)
        $0.setImage(UIImage(named: "TurnOffLight"), for: .selected)
    }
    
    private(set) lazy var tipLabel: UILabel = UILabel().then {
        $0.text = "Position QR code in this frame"
        $0.textColor = UIColor(hex: "#FFFFFF")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private(set) lazy var rectView: DDQRRectView = DDQRRectView(frame: rectFrame())
    
    private lazy var inputBackView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FFFFFF")
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private(set) lazy var inputTextField: UITextField = UITextField().then {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(hex: "#168A8D")]
        $0.attributedPlaceholder = NSAttributedString.init(string: "Please enter the number", attributes: attributes)
        $0.textColor = UIColor(hex: "#168A8D")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.keyboardType = .asciiCapable
    }
    
    private(set) lazy var confirmButton: UIButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(hex: "1792AC")
        $0.setTitle("Confirm", for: .normal)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    // MARK: 镂空layer懒加载
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        let pathOut = UIBezierPath(rect: UIScreen.main.bounds)
        let pathIn = UIBezierPath(rect: rectFrame())
        pathOut.append(pathIn.reversing())
        shapeLayer.path = pathOut.cgPath
        return shapeLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        layer.addSublayer(shapeLayer)
        addSubviews(backButton, lightButton, tipLabel, rectView, inputBackView)
        inputBackView.addSubviews(inputTextField, confirmButton)
        setViewConstraints()
        inputTextField.text = "HWW111400000503"
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setViewConstraints() {
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(60)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        lightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(80)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        tipLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(scanY() - 30)
        }
        inputBackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(80)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(44)
        }
        inputTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(confirmButton.snp.leading).offset(-10)
        }
        confirmButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 74, height: 38))
            make.trailing.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
    }
    
    
    
    // MARK: 扫描框宽度
    private func scanW() -> CGFloat {
        return 240.0
    }

    // MARK: 扫描框起始位置x
    private func scanX() -> CGFloat {
        return (UIScreen.main.bounds.size.width/2.0 - scanW()/2.0)
    }
    
    // MARK: 扫描框起始位置y
    private func scanY() -> CGFloat {
        return (DDScreen.height - scanW()) / 2.0 - 60.0
    }
    // MARK: 扫描框frame
    private func rectFrame() -> CGRect {
        return CGRect(x: scanX(), y: scanY(), width: scanW(), height: scanW())
    }
}
