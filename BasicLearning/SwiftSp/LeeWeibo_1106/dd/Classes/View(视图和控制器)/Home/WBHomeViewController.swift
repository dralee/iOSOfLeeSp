//
//  WBHomeViewController.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

class WBHomeViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    /// 显示好友
    @objc private func showFriends(){
        print(#function)
        let vc = WBDemoViewController()
        
        // push时藏起来（传统做法）
        // vc.hidesBottomBarWhenPushed = true
        
        // push 的动作是 nav 做的
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setupUI() {
        // 调用父类方法
        super.setupUI()
        
        // 设置导航栏按钮
        // 无法高亮
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友",style: .plain, target: self, action: #selector(showFriends))
        
        // Swift: 调用 OC 返回 instancetype 的方，判断不出是否可选，加个类型就不需要解包了
//        let btn:UIButton = UIButton.cz_textButton("好友", fontSize: 16, normalColor: .darkGray, highlightedColor: UIColor.orange)
//        btn.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
//
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target:self, action: #selector(showFriends))
    }

}

// MARK: - 设置界面
//extension WBHomeViewController{
//
//}

