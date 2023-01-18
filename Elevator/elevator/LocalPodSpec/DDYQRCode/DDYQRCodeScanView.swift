import UIKit

typealias DDYScanViewClosure = (Bool) -> Void

enum DDYQRScanStyle {
    case line(_ mainColor: UIColor) // 单线样式
    case grid(_ mainColor: UIColor) // 网格样式
}

class DDYQRCodeRectView: UIView {
    // MARK:- 懒加载
    // MARK: 扫描框带边角视图
    lazy var scanBackView: UIImageView = {
        let imageView = UIImageView.init(frame: self.bounds)
        return imageView
    }()
    // MARK: 扫描线
    lazy var scanLineView: UIImageView = {
        let scanLine = UIImageView()
        return scanLine
    }()
    // MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK:- 私有方法
    // MARK: 添加视图
    private func setupViews() {
        addSubview(scanBackView)
        addSubview(scanLineView)
    }
    // MARK: 布局视图
    private func setupFrame() {

    }

    fileprivate func setStyle(_ style: DDYQRScanStyle) {
        switch style {
        case .line(let mainColor):
            scanLineView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: 2)
            scanLineView.image = UIImage(named: "DDYQRCode.bundle/ScanLine")?.withRenderingMode(.alwaysTemplate)
            scanLineView.tintColor = mainColor
            scanBackView.image = DDYQRCodeScanner.scanRectImage(mainColor)
        case .grid(let mainColor):
            scanLineView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            scanLineView.image = UIImage(named: "DDYQRCode.bundle/ScanGrid")?.withRenderingMode(.alwaysTemplate)
            scanLineView.tintColor = mainColor
            scanBackView.image = DDYQRCodeScanner.scanRectImage(mainColor)
        }
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

class DDYQRCodeScanView: UIView {
    // MARK:- 计算属性
    // MARK: 开灯按钮显隐性
    var lightHidden: Bool {
        get {
            return lightButton.isHidden
        }
        set {
            lightButton.isHidden = newValue
        }
    }
    // MARK: 开灯按钮选择性
    var lightSelect: Bool {
        get {
            return lightButton.isSelected
        }
        set {
            lightButton.isSelected = newValue
        }
    }

    // MARK:- 事件回调
    // MARK: 返回事件闭包回调
    var backAction: DDYScanViewClosure?
    // MARK: 相册事件闭包回调
    var albumAction: DDYScanViewClosure?
    // MARK: 开光灯事件闭包回调
    var lightAction: DDYScanViewClosure?

    // MARK:- 懒加载
    // MARK: 返回按钮懒加载
    lazy var backButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "DDYQRCode.bundle/Back"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside)
        return button
    }()

    // MARK: 相册按钮懒加载
    lazy var albumButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("相册", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickAlbumButton), for: .touchUpInside)
        return button
    }()

    // MARK: 扫描窗口懒加载
    lazy var rectView: DDYQRCodeRectView = {
        let rectView = DDYQRCodeRectView.init(frame: rectFrame())
        return rectView
    }()

    // MARK: 镂空layer懒加载
    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        let pathOut = UIBezierPath(rect: UIScreen.main.bounds)
        let pathIn = UIBezierPath(rect: rectFrame())
        pathOut.append(pathIn.reversing())
        shapeLayer.path = pathOut.cgPath
        return shapeLayer
    }()

    // MARK: 提示语懒加载
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "将二维码/条码放入框内, 即可自动扫描"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    // MARK: 开灯按钮懒加载
    lazy var lightButton: UIButton = {
        let lightButton = UIButton(type: .custom)
        lightButton.setImage(UIImage(named: "DDYQRCode.bundle/LightOff"), for: .normal)
        lightButton.setImage(UIImage(named: "DDYQRCode.bundle/LightOn"), for: .selected)
        lightButton.addTarget(self, action: #selector(clickLightButton(_:)), for: .touchUpInside)
        lightButton.isHidden = true
        return lightButton
    }()

    // MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupFrame()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: 添加视图
    private func setupViews() {
        layer.addSublayer(shapeLayer)
        addSubview(backButton)
        addSubview(albumButton)
        addSubview(rectView)
        addSubview(tipLabel)
        addSubview(lightButton)
    }

    // MARK: 布局视图
    private func setupFrame() {
        backButton.frame = CGRect(x: 12, y: statusBarHeight()+6, width: 14.0, height: 26.0)
        albumButton.frame = CGRect(x: UIScreen.main.bounds.size.width-12-35, y: statusBarHeight()+6, width: 35.0, height: 32.0)
        tipLabel.frame = CGRect(x: 0, y: scanY()+scanW()+20, width: UIScreen.main.bounds.size.width, height: 20)
        lightButton.frame = CGRect(x: UIScreen.main.bounds.size.width/2.0-11, y: scanY()+scanW()-30, width: 22, height: 22)
        var colorArray = [UIColor]()
        colorArray.append(UIColor(red: 85.0/255.0, green: 180.0/255.0, blue: 55.0/255.0, alpha: 1.0))
        colorArray.append(UIColor(red: 1.0, green: 128.0/255.0, blue: 0, alpha: 1.0))
        colorArray.append(UIColor.red)
        colorArray.append(UIColor.green)
        colorArray.append(UIColor.blue)
        colorArray.append(UIColor.orange)
        colorArray.append(UIColor.magenta)
        colorArray.append(UIColor.brown)
        let tempNum = Int(arc4random_uniform(2))
        if tempNum == 1 {
            rectView.setStyle(.line(colorArray[Int(arc4random_uniform(8))]))
        } else {
            rectView.setStyle(.grid(colorArray[Int(arc4random_uniform(8))]))
        }
    }

    // MARK:- 私有方法 布局数据
    // MARK: 状态栏高度
    private func statusBarHeight() -> CGFloat {
        return (UIApplication.shared.statusBarFrame.height)
    }

    // MARK: 导航栏高度
    private func navigationBarHeight() -> CGFloat {
        return 44
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
        return (statusBarHeight() + navigationBarHeight() + 60.0)
    }

    // MARK: 扫描框frame
    private func rectFrame() -> CGRect {
        return CGRect(x: scanX(), y: scanY(), width: scanW(), height: scanW())
    }

    // MARK: - 事件响应
    // MARK: 返回事件
    @objc func clickBackButton() {
        if backAction != nil {
            backAction!(true)
        }
    }

    // MARK: 相册事件
    @objc func clickAlbumButton() {
        if albumAction != nil {
            albumAction!(true)
        }
    }

    // MARK: 开关灯
    @objc func clickLightButton(_ button: UIButton) {
        if lightAction != nil {
            button.isSelected = !button.isSelected
            lightAction!(button.isSelected)
        }
    }
}
// UIColor(red: 85.0/255.0, green: 180.0/255.0, blue: 55.0/255.0, alpha: 1.0)
// UIColor(red: 1.0, green: 128.0/255.0, blue: 0, alpha: 1.0)
