//
//  YXTipConfig.swift
//  EmptyViewDemo
//
//  Created by tezwez on 2019/8/29.
//  Copyright © 2019 tezwez. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    static let YXColor333333 = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
    static let YXColor999999 = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
    static let YXBlue = UIColor.init(red: 10/255.0, green: 114/255.0, blue: 184/255.0, alpha: 1)
}

struct YXImageConfig {
    /// 外边距
    var edge: UIEdgeInsets
    /// 尺寸
    var size: CGSize
    /// 图片名称
    var imageName: String
    
    init(imageName: String,
         size: CGSize = CGSize(width: 100, height: 100),
         edge: UIEdgeInsets = UIEdgeInsets.init(top: 60, left: 0, bottom: 0, right: 0)) {
        self.imageName = imageName
        self.size = size
        self.edge = edge
    }
    
    
    static func defaultConfig(imageName: String) -> YXImageConfig{
        return YXImageConfig(imageName: imageName)
    }
}

struct YXLabelConfig {
    /// 外边距
    var edge: UIEdgeInsets
    /// 字体大小
    var fontSize: CGFloat = 15
    /// 文本颜色
    var textColor: UIColor?
    /// 文本
    var text: String
    /// 居左居右
    var textAlign: NSTextAlignment
    init(text: String,
         edge: UIEdgeInsets = UIEdgeInsets.zero,
         fontSize: CGFloat = 15,
         textColor: UIColor? = UIColor.white,
         textAlign: NSTextAlignment = .center) {
        self.edge = edge
        self.fontSize = fontSize
        self.text = text
        self.textColor = textColor
        self.textAlign = textAlign
    }
    
    static func defaultConfig(text: String) -> YXLabelConfig{
        let edge = UIEdgeInsets.init(top: 30, left: 16, bottom: 10, right: 16)
        let textColor = UIColor.YXColor333333
        return YXLabelConfig(text: text, edge: edge, textColor: textColor)
    }
}

struct YXButtonConfig {
    
    enum Background {
        case image(String)
        case color(UIColor)
        case colors([CGColor])
    }
    
    /// 按钮点击回调
    typealias ButtonClick = (() -> Void)
    
    /// 外边距
    var edge: UIEdgeInsets
    /// 大小
    var height: CGFloat
    /// 背景
    var background: Background
    
    /// 圆角
    var cornerRadius: CGFloat = 0
    /// 字体大小
    var fontSize: CGFloat = 15
    /// 文本颜色
    var textColor: UIColor?
    /// 文本
    var text: String
    /// 按钮点击事件
    var click: ButtonClick?
    
    init(text: String,
         background: Background = .color(UIColor.YXBlue),
         edge: UIEdgeInsets = UIEdgeInsets.init(top: 12, left: 0, bottom: 10, right: 0),
         cornerRadius: CGFloat = 5,
         fontSize: CGFloat = 15,
         textColor: UIColor? = UIColor.white,
         height: CGFloat = 44,
         click: ButtonClick? = nil) {
        self.edge = edge
        self.background = background
        self.fontSize = fontSize
        self.text = text
        self.textColor = textColor
        self.click = click
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    static func defaultConfig(text: String, click: ButtonClick? = nil) -> YXButtonConfig{
        let edge = UIEdgeInsets(top: 40, left: 16, bottom: 0, right: 16)
        return YXButtonConfig(text: text, edge: edge, click: click)
    }
}

enum YXEmptyStyle{
    /// normal : 图片+标题+按钮(可选)
    case normal(YXLabelConfig, YXImageConfig, YXButtonConfig?)
    /// desc: 图片+标题+描述+按钮(可选)
    case descStyle(YXLabelConfig, YXLabelConfig, YXImageConfig, YXButtonConfig?)//
    /// 获取按钮回调
    func buttonClick() -> YXButtonConfig.ButtonClick?{
        switch self {
        case .normal(_, _, let config):
            return config?.click
        case .descStyle(_, _, _, let config):
            return config?.click
        }
    }
    /// 默认类型
    static func defaultStyle(text: String) -> YXEmptyStyle{
        return .normal(YXLabelConfig.defaultConfig(text: text), YXImageConfig.defaultConfig(imageName: ""), nil)
    }
}



//获取字符串Label宽度
func YXGetLabWidth(labelStr: String, font: UIFont, height:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height)
    let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
    return strSize.width
}
//获取字符串Label高度
func YXGetLabHeight(labelStr: String, font: UIFont, width:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
    let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
    return strSize.height
}
