//
//  ViewController.swift
//  DidSetUI
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let p = Person()
        p.name = "小花"
        
        let label = DemoLabel(frame:CGRect(x: 20, y: 40, width: 100, height: 40))
        label.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        view.addSubview(label)
        
        // 将模型设置给label
        label.person = p
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

