//
//  YXTipCollectionViewCell.swift
//  DigitalClub
//
//  Created by tezwez on 2019/9/2.
//  Copyright © 2019 xun.liu. All rights reserved.
//

import UIKit

class YXTipCollectionViewCell: UICollectionViewCell {
    
    lazy var tipView: YXTipView = {
        let view = YXTipView.init(frame: CGRect.zero)
        return view
    }()
    
    var imageTopSapce: CGFloat = 80
    var titleTop: CGFloat = 20
    var descTop: CGFloat = 15
    var imageSize: CGSize = CGSize(width: 140, height: 140)
    
    var titleFontSize: CGFloat = 15
    var descFontSize: CGFloat = 14
    var titleColor: UIColor = UIColor.color333333
    var descColor: UIColor = UIColor.color999999
    
    var isShowButton = false
    var btnBackground: YXButtonConfig.Background = .colors([UIColor.init(hexColor: "#0A72B8").cgColor, UIColor.init(hexColor: "#123183").cgColor])
    var btnTitleColor: UIColor = .white
    var btnTitleFontSize: CGFloat = 16
    var buttonTop: CGFloat = 40
    var buttonLeft: CGFloat = 0
    var buttonHeight: CGFloat = 44
    var buttonCornerRadius: CGFloat = 5
    var buttonAction: (() -> Void)?
    
    var config: YXTipCellConfig?{
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        _init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    private func _init(){
        self.contentView.addSubview(tipView)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tipView.style = self.generateTipStyle()
        
        tipView.frame = self.bounds
        tipView.setNeedsLayout()
    }
    
    // MARK: Class Method
    class func register(for collectionView: UICollectionView, identify: String){
        collectionView.register(YXTipCollectionViewCell.self, forCellWithReuseIdentifier: identify)
    }
    
    
    // MARK: Getter
    func titleConfig(_ text: String) -> YXLabelConfig{
        return YXLabelConfig(text: text, edge: UIEdgeInsets(top: titleTop, left: 16, bottom: 0, right: 16), fontSize: titleFontSize, textColor: titleColor, textAlign: .center)
    }
    
    func descConfig(_ text: String) -> YXLabelConfig{
        return YXLabelConfig(text: text, edge: UIEdgeInsets(top: descTop, left: 16, bottom: 0, right: 16), fontSize: descFontSize, textColor: descColor, textAlign: .center)
    }
    
    func imageConfig(_ image: String) -> YXImageConfig{
        return YXImageConfig(imageName: image, size: imageSize, edge: UIEdgeInsets(top: imageTopSapce, left: 0, bottom: 0, right: 0))
    }
    
    func buttonConfig(_ title: String) -> YXButtonConfig{
        
        
        let background = btnBackground
        
        return YXButtonConfig(text: title, background: background, edge: UIEdgeInsets(top: buttonTop, left: buttonLeft, bottom: 0, right: buttonLeft), cornerRadius: buttonCornerRadius, fontSize: btnTitleFontSize, textColor: btnTitleColor, height: buttonHeight, click: buttonAction)
    }
    
    func generateTipStyle() -> YXEmptyStyle{
        
        let title = config?.title ?? ""
        let desc = config?.desc ?? ""
        let imageName = config?.imageName ?? ""
        let buttonTitle = config?.buttonTitle ?? ""
        
        let titleConfig = self.titleConfig(title)
        let imageConfig = self.imageConfig(imageName)
        var buttonConfig: YXButtonConfig?
        if self.isShowButton {
            buttonConfig = self.buttonConfig(buttonTitle)
        }
        
        var style: YXEmptyStyle
        if desc.count > 0 && title.count > 0{
            let descConfig = self.descConfig(desc)
            style = .descStyle(titleConfig, descConfig, imageConfig, buttonConfig)
        } else {
            var descConfig = self.titleConfig(title)
            if title.count == 0{
                descConfig = self.descConfig(desc)
            }
            style = .normal(descConfig, imageConfig, buttonConfig)
        }
        return style
    }
}
