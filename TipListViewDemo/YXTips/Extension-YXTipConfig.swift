//
//  Extension-YXTipConfig.swift
//  DigitalClub
//
//  Created by tezwez on 2019/9/2.
//  Copyright © 2019 xun.liu. All rights reserved.
//

import Foundation

extension YXLabelConfig{
    static func defaultTitleConfig(text: String, top: CGFloat = 30) -> YXLabelConfig{
        let edge = UIEdgeInsets.init(top: top, left: 16, bottom: 0, right: 16)
        let textColor = UIColor.YXColor333333
        return YXLabelConfig(text: text, edge: edge, textColor: textColor)
    }
    
    static func defaultDescConfig(text: String, top: CGFloat = 25) -> YXLabelConfig{
        let edge = UIEdgeInsets.init(top: top, left: 16, bottom: 0, right: 16)
        let textColor = UIColor.YXColor999999
        let fontSize: CGFloat = 14
        return YXLabelConfig(text: text, edge: edge, fontSize: fontSize, textColor: textColor)
    }
}

extension YXImageConfig{
    static func defaultEmptyConfig(imageName: String, top: CGFloat = 80, size: CGSize = CGSize(width: 140, height: 140)) -> YXImageConfig{
        return YXImageConfig(imageName: imageName, size: size, edge: UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0))
    }
}


extension YXEmptyStyle{
    static func defaultTipStyle(title: String, desc: String, imageName: String) -> YXEmptyStyle{
        
        let titleConfig = YXLabelConfig.defaultTitleConfig(text: title)
        let imageConfig = YXImageConfig.defaultEmptyConfig(imageName: imageName)
        var style: YXEmptyStyle
        if desc.count > 0 && title.length > 0{
            let descConfig = YXLabelConfig.defaultDescConfig(text: desc)
            style = .descStyle(titleConfig, descConfig, imageConfig, nil)
        } else {
            var descConfig = YXLabelConfig.defaultDescConfig(text: title)
            if title.length == 0{
                descConfig = YXLabelConfig.defaultDescConfig(text: desc)
            }
            style = .normal(descConfig, imageConfig, nil)
        }
        return style
    }
}

extension YXTipCellConfig{
    
}
