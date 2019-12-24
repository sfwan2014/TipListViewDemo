//
//  YXEmptyView.swift
//  EmptyViewDemo
//
//  Created by tezwez on 2019/8/29.
//  Copyright © 2019 tezwez. All rights reserved.
//

import UIKit



class YXTipView: UIView {

    lazy var imageView: UIImageView = {
        let image = UIImageView.init(frame: CGRect.zero)
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.numberOfLines = 0
        return label
    }()
    lazy var descLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.numberOfLines = 0
        return label
    }()
    lazy var button: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return btn
    }()
    
    
    var style: YXEmptyStyle = .normal(YXLabelConfig.init(text: ""), YXImageConfig.init(imageName: ""), nil){
        didSet{
            switch style {
            case .normal(_, _, let btnConfig):
                if btnConfig != nil {
                    if button.superview == nil {
                        self.addSubview(button)
                    }
                } else {
                    if button.superview != nil {
                        button.removeFromSuperview()
                    }
                }
            case .descStyle(_, _, _, let btnConfig):
                if btnConfig != nil {
                    if button.superview == nil {
                        self.addSubview(button)
                    }
                } else {
                    if button.superview != nil {
                        button.removeFromSuperview()
                    }
                }
                if descLabel.superview == nil {
                    self.addSubview(descLabel)
                }
            }
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self._init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    private func _init(){
        self.addSubview(imageView)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.update()
    }
    

    func update(){
        switch style {
        case .normal(let titleConfig, let imageConfig, let btnConfig):
            var offsetY = self.configImageView(config: imageConfig)
            offsetY = self.configLabel(titleLabel, config: titleConfig, offsetY: offsetY)
            if let config = btnConfig{
                _ = self.configButton(config, offsetY: offsetY)
            }
            break
        case .descStyle(let titleConfig,
                        let descConfig,
                        let imageConfig,
                        let btnConfig):
            var offsetY = self.configImageView(config: imageConfig)
            offsetY = self.configLabel(titleLabel, config: titleConfig, offsetY: offsetY)
            offsetY = self.configLabel(descLabel, config: descConfig, offsetY: offsetY)
            if let config = btnConfig{
                _ = self.configButton(config, offsetY: offsetY)
            }
            
            break
        }
    }
    
    
    @objc private func buttonAction(){
        style.buttonClick()?()
    }
}

//MARK: - Config UI
extension YXTipView{
    private func configImageView(config: YXImageConfig) -> CGFloat{
        let edge = config.edge
        imageView.image = UIImage.init(named: config.imageName)
        imageView.frame = CGRect.init(x: (self.frame.size.width - config.size.width)/2.0, y: edge.top, width: config.size.width, height: config.size.height)
        
        return imageView.frame.origin.y + imageView.frame.size.height + config.edge.bottom
    }
    
    private func configLabel(_ label: UILabel, config: YXLabelConfig, offsetY: CGFloat) -> CGFloat {
        let edge = config.edge
        let font = UIFont.systemFont(ofSize: config.fontSize)
        label.font = font
        label.text = config.text
        label.textColor = config.textColor
        label.textAlignment = config.textAlign
        
        let width = (self.frame.size.width - edge.left - edge.right)
        let height = YXGetLabHeight(labelStr: config.text, font: font, width: width)
        label.frame = CGRect.init(x: edge.left, y: offsetY+edge.top, width: width, height: height)
        return label.frame.origin.y + height + edge.bottom
    }
    
    private func configButton(_ config: YXButtonConfig, offsetY: CGFloat) -> CGFloat{
        let edge = config.edge
        let font = UIFont.systemFont(ofSize: config.fontSize)
        button.titleLabel?.font = font
        button.setTitle(config.text, for: .normal)
        button.setTitleColor(config.textColor, for: .normal)
        button.layer.cornerRadius = config.cornerRadius
        button.layer.masksToBounds = config.cornerRadius > 0
        
        var width: CGFloat = 0
        let height: CGFloat = config.height
        let left = edge.left
        let right = edge.right
        if left > 0 {
            width = self.frame.size.width - left - right
            button.frame = CGRect.init(x: left, y: offsetY+edge.top, width: width, height: height)
        } else { // 居中
            let padding: CGFloat = 49
            let textWidth = YXGetLabWidth(labelStr: config.text, font: font, height: 1000)
            width = textWidth + padding*2
            
            width = min(width, self.frame.size.width)
            
            button.frame = CGRect.init(x: (self.frame.size.width-width)/2.0, y: offsetY+edge.top, width: width, height: height)
        }
        
        switch config.background {
        case .image(let backImageName):
            button.setBackgroundImage(UIImage.init(named: backImageName), for: .normal)
        case .color(let backgroundColor):
            button.backgroundColor = backgroundColor
        case .colors(let colors):
            button.gradientView(colors: colors)
        }
        
        return button.frame.origin.y + height + edge.bottom
    }
}

