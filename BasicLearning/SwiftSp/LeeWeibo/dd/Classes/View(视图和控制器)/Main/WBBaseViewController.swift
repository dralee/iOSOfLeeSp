//
//  WBBaseViewController.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {

    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen.cz_screenWidth(), height: 64))
    
    // 自定义的导航项
    lazy var navItem = UINavigationItem()
    
    override var title: String?{
        didSet{
            navItem.title = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = UIColor.cz_random()
        setupUI()
    }
    
    func setupUI(){
        view.backgroundColor = UIColor.cz_random()
        
        // 添加导航条
        view.addSubview(navigationBar)
        
        // 将 item 设置到 bar
        navigationBar.items = [navItem]
        // 设置 navBar 的背景颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        // 设置 navBar 的字体颜色
        navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    }
}

// MARK: - 设置界面
//extension WBBaseViewController{
//    
//    
//}

