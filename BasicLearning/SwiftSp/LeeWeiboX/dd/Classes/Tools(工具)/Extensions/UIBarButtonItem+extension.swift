//
//  File.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    
    /// 创建 UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize，默认 16
    ///   - target: target
    ///   - action: action
    ///   - isBack: isBack 是否是返回按钮，如果是加上箭头
    convenience init(title: String, fontSize: CGFloat = 16, target: Any?, action: Selector, isBack: Bool = false){
        // Swift: 调用 OC 返回 instancetype 的方，判断不出是否可选，加个类型就不需要解包了
        let btn:UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: .darkGray, highlightedColor: UIColor.orange)
        
        if isBack {
            let imageName = "navigationbar_back_withtext"
            
            btn.setImage(UIImage(named: imageName), for: UIControlState.normal)
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        // self.init() 实例化 UIBarButtonItem
        self.init(customView: btn)
    }
}
