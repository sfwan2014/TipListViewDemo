//
//  Extension-Color.swift
//  BelifData
//
//  Created by ayong on 2017/2/14.
//  Copyright © 2017年 ayong. All rights reserved.
//

import Foundation
import UIKit


//MARK: 第一种方式是给String添加扩展
extension String {
    // MARK: - 将十六进制颜色转换为UIColor
    public func uiColor() -> UIColor {
        
        var hexColorString = self
        
        if hexColorString.contains("#") {
            hexColorString = hexColorString[1..<7]
        }
        
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: hexColorString[0..<2]).scanHexInt32(&red)
        
        Scanner(string: hexColorString[2..<4]).scanHexInt32(&green)
        
        Scanner(string: hexColorString[4..<6]).scanHexInt32(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
}


//MARK: 第二种方式是给UIColor添加扩展
extension UIColor {
    
    /**
     16进制表示颜色
     
     - parameter hex:
     
     - returns:
     */
    public convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    /// 用十六进制颜色创建UIColor
    ///
    /// - Parameter hexColor: 十六进制颜色 (0F0F0F)
    public convenience init(hexColor: String) {
        
        var hexColorString = hexColor
        
        if hexColorString.contains("#") {
            hexColorString = hexColorString[1..<7]
        }
        
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: hexColorString[0..<2]).scanHexInt32(&red)
        
        Scanner(string: hexColorString[2..<4]).scanHexInt32(&green)
        
        Scanner(string: hexColorString[4..<6]).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
}

//MARK: 两种方式都需要用到的扩展

extension String {
    
    // MARK: - String使用下标截取字符串， 例: "示例字符串"[0..<2] 结果是 "示例"
    public subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            
            return String(self[startIndex..<endIndex])
        }
    }
}



// MARK: - 随机颜色
extension UIColor {
    // MARK: - 随机颜色
    public static func randColor() -> UIColor {
        return UIColor.init(red: CGFloat(arc4random()%(256-124)+124)/255.0, green: CGFloat(arc4random()%(256-124)+124)/255.0, blue: CGFloat(arc4random()%(256-124)+124)/255.0, alpha: 1)
    }
}


// MARK: - 定义一些常用的颜色到静态存储区（具体看项目UI配色）
extension UIColor {
    
    static let ivTheme          = UIColor.init(red: 36.0/255.0, green: 39.0/255.0, blue: 54.0/255.0, alpha: 1)//主题深蓝
    static let ivText           = "#8A98BD".uiColor()
    static let ivSelectedBG     = "#32374F".uiColor()
    static let ivRedBtnBG       = "#DC4D4D".uiColor()
    static let ivGreenBtnBG     = "#03C189".uiColor()
    static let ivRedText        = "#FD3E3E".uiColor()
    static let ivGreenText      = "#1FE5B6".uiColor()
    static let ivTabBarBG       = "#30344A".uiColor()
    static let ivBlueText       = "#409DFF".uiColor()

    
    static let themeBlue        = "#00A8FF".uiColor()//主题蓝
    static let themeBlack       = "#2F4053".uiColor()//主题黑
    static let iRed             = "#DE1322".uiColor().withAlphaComponent(0.7)
    static let iGreen           = "#21B68A".uiColor().withAlphaComponent(0.7)
    static let gray240          = "#F0F0F0".uiColor()//rgb:240,240,240
    static let color333333      = "#333333".uiColor()
    static let color666666      = "#666666".uiColor()
    static let color999999      = "#999999".uiColor()
    
    
    static let theme            = ivTheme//主题色
    static let navBGColor       = ivTheme//顶部导航栏背景颜色
    static let tabBarBG         = ivTabBarBG//底部导航栏背景
    static let text             = ivText
    static let redBtnBG         = ivRedBtnBG
    static let greenBtnBG       = ivGreenBtnBG
    static let redText          = ivRedText
    static let greenText        = ivGreenText
    static let selectedBG       = ivSelectedBG
    static let viewBG           = ivTheme
    static let tableViewBG      = ivTheme
    static let blueText         = ivBlueText
}


extension UIColor {
    // MARK: - 由颜色填充生成一张图片
    public func image() -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
