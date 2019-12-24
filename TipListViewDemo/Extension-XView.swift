//
//  Extension-XView.swift
//  DigitalClub
//
//  Created by TEZWEZ on 2019/8/30.
//  Copyright © 2019 xun.liu. All rights reserved.
//
import UIKit

extension UIView {
    //MARK: - property
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = left
            self.frame = frame
        }
    }
    
    var right: CGFloat {
        get {
            return self.frame.maxX
        }
        set {
            var frame = self.frame
            frame.origin.x = right - frame.width
            self.frame = frame
        }
    }
    
    var top: CGFloat {
        get {
            return self.frame.minY
        }
        set {
            var frame = self.frame
            frame.origin.y = top
            self.frame = frame
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.frame.maxY
        }
        set {
            var frame = self.frame
            frame.origin.y = bottom - frame.height
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.width
        }
        set {
            var frame = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: centerX, y: self.center.y)
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: centerY)
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = mj_origin
            self.frame = frame
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = size
            self.frame = frame
        }
    }
    
    //MARK: - func
    ///响应链 控制器
    var viewController: UIViewController? {
        var next = superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is UIViewController) {
                return nextResponder as? UIViewController
            }
            next = next?.superview
        }
        return nil
    }
    
    ///左右颜色渐变
    func gradientView(startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 0), colors: [CGColor]? = ["#0A72B8".uiColor().cgColor, "#123183".uiColor().cgColor]) {
        
        let exist = self.layer.sublayers?.first(where: { (layer) -> Bool in
            return layer.isKind(of: CAGradientLayer.self)
        })
        exist?.removeFromSuperlayer()
        
        let layer = CAGradientLayer()
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.colors = colors
        layer.frame = self.bounds
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func clearGradientView(){
        let exist = self.layer.sublayers?.first(where: { (layer) -> Bool in
            return layer.isKind(of: CAGradientLayer.self)
        })
        exist?.removeFromSuperlayer()
    }
    
    ///移除子视图
    func removeAllSubviews() {
        while self.subviews.count > 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
    
    ///阴影
    func setShadow(color: UIColor = UIColor.black.withAlphaComponent(0.4), offset: CGSize = CGSize.zero, shadowOpacity: Float = 0.4, radius: CGFloat = 3) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }
}


extension UIView {
    // MARK: - view截图
    /**
     Get the view's screen shot, this function may be called from any thread of your app.
     
     - returns: The screen shot's image.
     */
    public func screenShot() -> UIImage? {
        
        return self.screenShot(scale: 0)
    }
    // MARK: - view截图
    public func screenShot(scale: CGFloat) -> UIImage? {
        guard frame.size.height > 0 && frame.size.width > 0 else {
            
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
