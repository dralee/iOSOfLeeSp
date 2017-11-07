//
//  ViewController.swift
//  Hello4
//
//  Created by leven on 2017/11/3.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

/**
 在 Swift 中，默认同一个项目中（同一个命名空间下），所有的类都是共享的，可以直接访问，不需要 import
 所有对象的属性 var，也可以直接访问
 */

// 子类必选属性初化过程
// 必选属性的构造过程
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 实例化person
        // ()- > alloc / init
        // SWift 中对应一个函数 init() 构造函数
        // 作用：给成员变量分配空间，初始化成员变量
//        let p = Person()
//        print(p.name)
        
        // 属性初始化过程 -> Student -> Person
//        let s = Student()
//        print(s.no)

        // 重载构造函数
//        let p = Person(name: "zhang")
//        print(p.name)
        
        // 子类重载构造函数
        let s = Student(name: "lee", no: "002")
        print("\(s.no) -- \(s.name)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

