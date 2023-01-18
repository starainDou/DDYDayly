import UIKit
import CoreImage
import CoreGraphics

/// errorCode意义 0:成功 -1:字符串非法 -2:size非法 -3:前景色非法 -4:背景色非法 -5:未知错误
typealias DDYQRCodeCreatorClosure = (_ image: UIImage?,_ errorCode: Int,_ errorMessage: String) -> Void

// 创建配置结构体
public struct DDYQRCodeConfig {
    // 大小(更改大小以 let scale = min(size.width/img.extent.integral.width, size.height/img.extent.integral.height) 等比例缩放)
    var size: CGSize? = CGSize(width: 600, height: 600)
    // 前景色，默认黑色
    var color: UIColor? = UIColor.black
    // 背景色，默认白色 前景色背景色如果自定义最好有差异
    var bgColor: UIColor? = UIColor.white
    // 二维码中间logo(条形码时设置无效)
    var logo: UIImage?
}

final class DDYQRCodeCreator: NSObject {
    
    /// 生成条形码(可以配置指定大小指定颜色) DDYQRCodeCreator.ddyBarCode("987654321123456789", DDYQRCodeConfig()) { (image, code, message) in }
    ///
    /// - Parameters:
    ///   - inputStr: 要转换成条形码的字符串(128码只允许ASCII中0-127的128个字符,长度最好20个字符内)
    ///   - config: 配置
    ///   - closure: 闭包回掉(逃逸闭包)
    public static func ddyBarCode(_ inputStr: String?,_ config: DDYQRCodeConfig?,_ closure: @escaping DDYQRCodeCreatorClosure) {

        guard let strData = inputStr?.data(using: String.Encoding.utf8), strData.count>0 else {
            closure(nil, -1, "字符串非法")
            return
        }
        for asciiByte in [UInt8](strData) {
            if asciiByte > 127 {
                closure(nil, -1, "字符串非法")
                return
            }
        }
        guard let size = config?.size else {
            closure(nil, -2, "size非法")
            return
        }
        guard let color = config?.color else {
            closure(nil, -3, "前景色非法")
            return
        }
        guard let bgColor = config?.bgColor else {
            closure(nil, -4, "背景色非法")
            return
        }
        DispatchQueue.global().async {
            guard let barImg = generateOriginalBarCode(strData) else {
                closure(nil, -5, "未知错误")
                return
            }
            let colorImg = changeColor(barImg, color, bgColor)
            let sizeImg = changeSize(colorImg, size)
            DispatchQueue.main.async {
                closure(sizeImg, 0, "条形码创建成功")
            }
        }
    }

    /// 生成二维码(可以配置指定大小指定颜色) DDYQRCodeCreator.ddyQRCode("987654321123456789", DDYQRCodeConfig()) { (image, code, message) in }
    ///
    /// - Parameters:
    ///   - inputStr: 要转换成二维码的字符串(长度最好200个字符内, 太多字符导致二维码密度上升，不容易识别)
    ///   - config: 配置
    ///   - closure: 闭包回掉(逃逸闭包)
    public static func ddyQRCode(_ inputStr: String?,_ config: DDYQRCodeConfig?,_ closure: @escaping DDYQRCodeCreatorClosure) {

        guard let strData = inputStr?.data(using: String.Encoding.utf8), strData.count>0 else {
            closure(nil, -1, "字符串非法")
            return
        }
        guard let size = config?.size else {
            closure(nil, -2, "size非法")
            return
        }
        guard let color = config?.color else {
            closure(nil, -3, "前景色非法")
            return
        }
        guard let bgColor = config?.bgColor else {
            closure(nil, -4, "背景色非法")
            return
        }
        DispatchQueue.global().async {
            guard let barImg = generateOriginalQRCode(strData) else {
                closure(nil, -5, "未知错误")
                return
            }
            let colorImg = changeColor(barImg, color, bgColor)
            let sizeImg = changeSize(colorImg, size)
            if let logo = config?.logo {
                let logoImg = addLogo(logo, sizeImg, 0.25)
                DispatchQueue.main.async {
                    closure(logoImg, 0, "二维码创建成功")
                }
            } else {
                DispatchQueue.main.async {
                    closure(sizeImg, 0, "二维码创建成功")
                }
            }
        }
    }
}

// MARK:- 生成与处理 私有函数
extension DDYQRCodeCreator {
    // MARK: 生成原始条形码
    private class func generateOriginalBarCode(_ strData: Data!) -> CIImage! {
        let filter = CIFilter(name: "CICode128BarcodeGenerator")!
        filter.setDefaults()
        filter.setValue(strData, forKey: "inputMessage")
        filter.setValue(NSNumber(floatLiteral: 0), forKey: "inputQuietSpace")
        return filter.outputImage
    }

    // MARK: 生成原始二维码
    private class func generateOriginalQRCode(_ strData: Data!) -> CIImage! {
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setDefaults()
        filter.setValue(strData, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        return filter.outputImage
    }

    // MARK: 改变前景和背景色
    private class func changeColor(_ img: CIImage!,_ color: UIColor!,_ bgColor: UIColor!) -> CIImage! {
        let filter = CIFilter(name: "CIFalseColor")!
        filter.setDefaults()
        filter.setValue(img, forKey: "inputImage")
        filter.setValue(CIColor(cgColor: bgColor.cgColor), forKey: "inputColor0")
        filter.setValue(CIColor(cgColor: color.cgColor), forKey: "inputColor1")
        return filter.outputImage
    }

    // MARK: 改变宽高
    private class func changeSize(_ img: CIImage!,_ size: CGSize!) -> UIImage! {

        let extent = img.extent.integral
        let scale = min(size.width/extent.width, size.height/extent.height)
        let width = extent.width * scale
        let height = extent.height * scale
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let contentRef = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpaceRef, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGImageByteOrderInfo.order32Little.rawValue)!
        let context = CIContext(options: nil)
        let imageRef = context.createCGImage(img, from: extent)!
        contentRef.interpolationQuality = CGInterpolationQuality.none
        contentRef.scaleBy(x: scale, y: scale)
        contentRef.draw(imageRef, in: extent)
        let imageRefResized = contentRef.makeImage()
        return UIImage(cgImage: imageRefResized!)
    }
    /** 灰度图
     let colorSpaceRef = CGColorSpaceCreateDeviceGray()
     let contentRef = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpaceRef, bitmapInfo: 0)!
     */

    // MARK: 二维码添加logo
    private class func addLogo(_ logo: UIImage!,_ img: UIImage!,_ scale: CGFloat) -> UIImage! {
        let newScale = max(min(scale, 0.5), 0)
        let logoW = img.size.width * newScale
        let logoX = (img.size.width-logoW) / 2.0
        UIGraphicsBeginImageContext(img.size)
        img .draw(in: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
        logo.draw(in: CGRect(x: logoX, y: logoX, width: logoW, height: logoW))
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImg
    }
}
