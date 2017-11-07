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
        
        // *** 解除循环引用，需要打断链条
        // 方法1：OC 的方式
        // 细节1：var，weak 只能修改 var，不能修饰 let
        // 'weak' must be a mutable variable, because it may change at runtime
        // weak 可能会被在运行时被修改 -> 指向的对象一旦被释放，会自动设置为 nil
        //weak let weakSelf = self
//        weak var weakSelf = self
//        loadData {
            //print(self.view)
            // 细节2
            // 解包有两种方式的解包
            // ? 可选解包 - 如果 self 已经被释放，不会向对象发送 getter 的消息，更加安全
            // ! 强行解包 - 如果 self 已经被释放，强行解包会导致崩溃
            /**
                weakSelf?.view - 只是单纯的发送消息，没有计算
                强行解包，因为需要计算，可选项不能直接参与计算
            */
//            print(weakSelf?.view)
//        }
        
        // 方法2：Swift 的推荐方法
        // [weak self] 表示 {} 中所有 self 都是弱引用，需要注意解包
        // 对应于OC中的__weak
        loadData { [weak self] in
            print(self?.view)
        }

        // 方法3：Swift 的另外一个用法，知道就好
        // [unowned self] 表示 {} 中的所有 self 都是 assign 的，不会强引用，但是，如果对象释放，指针地址不会变化
        // 对应于OC中的 __unsafe_unretained
        // 如果对象被释放，继续调用，就会出现野指针的问题
//        loadData { [unowned self] in
//            print(self.view)
//        }
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

