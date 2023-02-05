// UILabel扩展


import UIKit

private var InnerKey: Void?

public extension UILabel {

    var contentEdgeInsets: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &InnerKey) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
        set {
            objc_setAssociatedObject(self, &InnerKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}

private extension UILabel {
    
    static func ddySwizzle(_ oldSel: Selector,_ newSel: Selector, swizzleClass: AnyClass) {
        guard let m1 = class_getInstanceMethod(swizzleClass, oldSel) else {
            return
        }
        guard let m2 = class_getInstanceMethod(swizzleClass, newSel) else {
            return
        }

        if (class_addMethod(swizzleClass, newSel, method_getImplementation(m2), method_getTypeEncoding(m2))) {
            class_replaceMethod(swizzleClass, newSel, method_getImplementation(m1), method_getTypeEncoding(m1))
        } else {
            method_exchangeImplementations(m1, m2)
        }
    }
    
    static func ddySwizzleMethod() {
        ddySwizzle(#selector(UILabel.textRect(forBounds:limitedToNumberOfLines:)), #selector(ddyTextRect(_:_:)), swizzleClass: self)
        ddySwizzle(#selector(UILabel.drawText(in:)), #selector(ddyDrawText(in:)), swizzleClass: self)
    }

    @objc func ddyTextRect(_ bounds: CGRect,_ numberOfLines: Int) -> CGRect {
        var rect = self.ddyTextRect(bounds.inset(by: self.contentEdgeInsets), numberOfLines)
        rect.origin.x -= self.contentEdgeInsets.left;
        rect.origin.y -= self.contentEdgeInsets.top;
        rect.size.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right;
        rect.size.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
        return rect
    }
    
    @objc func ddyDrawText(in rect: CGRect) {
        self.ddyDrawText(in: rect.inset(by: self.contentEdgeInsets))
    }
}



