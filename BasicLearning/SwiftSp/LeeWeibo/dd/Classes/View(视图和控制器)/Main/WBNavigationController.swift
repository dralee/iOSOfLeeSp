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

        // 隐藏默认的 NavigationBar
        navigationBar.isHidden = true
    }
    
    // 重写 push 方法，所有的 push 动作都会调用此方法！
    // viewController 被 push 的控制器，设置它的左侧按钮作为返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print(viewController)
        
        // 如果不是栈底控制器，才需要隐藏，根控制器不需要处理
        if childViewControllers.count > 0{
         
            // 隐藏底部的 TabBar
            viewController.hidesBottomBarWhenPushed = true
            
            // 判断控制器的类型
            if let vc = viewController as? WBBaseViewController{
                
                var title = "返回"
                // 判断控制器的级数
                if childViewControllers.count == 1{
                    // title 显示首页的标题，只有一个子控制器的时候，显示栈底控制器的标题
                    title = childViewControllers.first?.title ?? "返回"
                }
                    // 取出自定义的 navItem，设置左侧按钮作为返回
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popTopParent), isBack: true)
        }
        
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    /// POP 返回到上一级控制器
    @objc private func popTopParent(){
        popViewController(animated: true)
    }
}
