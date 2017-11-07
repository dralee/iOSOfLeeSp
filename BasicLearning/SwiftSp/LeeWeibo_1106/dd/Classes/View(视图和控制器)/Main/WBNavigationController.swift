//
//  WBNavigationControllerViewController.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // 重写 push 方法，所有的 push 动作都会调用此方法！
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print(viewController)
        
        // 如果不是栈底控制器，才需要隐藏，根控制器不需要处理
        if childViewControllers.count > 0{
         
            // 隐藏底部的 TabBar
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}
