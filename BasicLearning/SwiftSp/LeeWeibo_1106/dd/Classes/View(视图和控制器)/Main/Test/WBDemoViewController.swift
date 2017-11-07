//
//  WBDemoViewController.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        title = "第 \(navigationController?.childViewControllers.count ?? 0) 个"
        
    }
    
    // MARK: - 监听方法
    // 继续 PUSH 一个新的控制器
    @objc private func showNext(){
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 重写父类方法
    override func setupUI() {
        super.setupUI()
        
        // 设置右侧的控制器
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", style: .plain, target: self, action: #selector(showNext))
        
        // Swift: 调用 OC 返回 instancetype 的方，判断不出是否可选，加个类型就不需要解包了
//        let btn:UIButton = UIButton.cz_textButton("下一个", fontSize: 16, normalColor: .darkGray, highlightedColor: UIColor.orange)
//        btn.addTarget(self, action: #selector(showNext), for: .touchUpInside)
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }
}
