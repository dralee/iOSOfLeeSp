//
//  ViewController.swift
//  Hello3
//
//  Created by leven on 2017/11/3.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

// 有循环引用的代码
class ViewController: UIViewController {

    // 属性就是一个 var
    var completionCallBack: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // lbock 中如果出现 self，需要特别小心！
        // `循环`引用 单方向的引用是不会产生循环引用的！
        // - 只是闭包对 self 进行了 copy，闭包执行完成之后，会自动销毁，同时释放对 self 的引用
        // - 同时需要 self 对闭包引用
        loadData {
            print(self.view)
        }
    }
    
    func loadData(completion: @escaping ()->())->(){
        
        // 使用属性记录闭包 -> self 对闭包引用了
        completionCallBack = completion
        
        // 异步
        DispatchQueue.global().async {
            print("耗时操作")
            
            DispatchQueue.main.async {
                // 回调，执行闭包
                completion()
            }
        }
    }
    
    // 类似于 OC 的dealloc
    deinit {
        print("我去了")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

