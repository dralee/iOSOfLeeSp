//
//  Person.swift
//  Hello4
//
//  Created by leven on 2017/11/3.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

/**
 1.构造函数的目的：给自己的属性分配空间并且设置初始值
 2.调用父类构造函数之前，需要先给本类的属性设置初始值
 3.调用父类的`构造函数`，给父类的属性分配空设置初始值
    NSObject 没有属性，只有一个成员亦是`isa`
 顺序跟OC的初始化过程相反！
 4. 如果重载了构造函数，并且没有实现父类 init 方法，系统不再提供 init() 构造函数（默认是会有的）
    - 因为 默认的构造函数，不能给本类的属性分配空间！
 
 */

// 1. Class 'Person' has no initializers
// Person 类没有初始化器，可以有多个，默认的是 init
class Person: NSObject {
    
    var name: String

    // 2. Overriding declaration requires an 'override' keyword
    // `重写` -> 父类有这方法，子类重新实现，需要override 关键字
    // 3. Property 'self.name' not initialized at implicitly generated super.init call
    // implicitly（隐式生成的 super.init）调用父类的构造函数之前，属性 self.name 没有初始化
    // 重写Person构造函数，父类有这方法
    override init() {
        // 4. Property 'self.name' not initialized at super.init call
        // 在调用父类 super.init 时，没有给 self.name 初始化 -> 分配空间，设置初始值！
        
        print("person init")
        
        name = "li"
        
        super.init()
        
    }
    
    // `重载`，函数名相同，参数和个数不同
    // - 重载可以给自己的属性从外部设置初始值
    // - 提问：OC 有重载吗？没有 initWithXXX（就是构造函数）
    init(name: String){
        // 使用参数设置给属性
        self.name = name
        
        // 调用父类构造函数
        super.init()
    }
}
