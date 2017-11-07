//
//  ViewController.swift
//  Hello2
//
//  Created by leven on 2017/11/3.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        demo()
        demo1()
        // 尾随闭包，如果函数的最后一个参数是闭包，函数参数可以提交结束，最后一个参数直接使用 {} 包装闭包的代码
        // loadData(completion: <#T##([String]) -> ()#>)
        // 关于尾随闭包
        // 1.要能看懂
        // 2.能够慢慢的编写，`大多数` Xcode 的智能提示会帮我们做
        loadData { (result) in
            print("获取的新闻数据 \(result)")
        }
        
        // 原始写法（按照函数本身续写的结果）
        loadData(completion: {  (result) in
            print("获取的新闻数据：\(result)")
        })
    }
    
    // MARK:
    // 将余额添加到队列，指定执行任务的函数
    // `队列`高度任务（block/闭包）以同步/异步的方式执行
    func demo1(){
        // 尾随闭包
        DispatchQueue.global().async {
            print("耗时操作 \(Thread.current)")
            
            // 主队列回调
            DispatchQueue.main.async {
                print("主线程更新 \(Thread.current)")
            }
        }
    }
    func loadData(completion: @escaping (_ result: [String]) -> ()) -> () {
        // 将余额添加到队列，指定执行任务的函数
        // `队列`高度任务（block/闭包）以同步/异步的方式执行
        DispatchQueue.global().async {
            print("耗时操作 \(Thread.current)")
            
            // 休眠
            Thread.sleep(forTimeInterval: 1.5)
            
            // 获得结果
            let json = ["头条", "八卦", "出大事了"]
            
            // 主队列回调
            DispatchQueue.main.async {
                print("主线程更新 \(Thread.current)")
                
                // 回调 -> 执行 闭包（通过参数传递的）
                // 传递异步获取的结果
                completion(json)
            }
        }
    }
    
    // MARK: 闭包
    func demo(){
        // 1. 最简单的闭包
        // () -> () 没有参数，没有返回值的函数
        // 如果没有参数，没有返回值，可以省略，连 in 都一起省略
        // option + click 最常见的组合键
        let b1 = {
            print("hello")
        }
        // 执行闭包
        b1()
        
        // 2.带参数的闭包
        // 闭包中，参数，返回值，实现代码都写在 {} 中
        // 需要使用一个关键字`in` 分隔定义和实现
        // { 形参列表 -> 返回值类型 in // 实现 }
        
        // (Int) -> {}
        let b2 = {(x:Int) -> () in
            print(x)
        }
        
        b2(20)
        
        // 3. 带参数 / 返回值的闭包
        // (Int) -> Int
        let b3 = { (x: Int) -> Int in
            return x + 250
        }
        print(b3(120))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

