//
//  DemoLabel.swift
//  DidSetUI
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

class DemoLabel: UILabel {

    var person: Person?{
        // 就是替代OC中重写setter方法
        // 区别：再也不需要考虑 _成员变量 = 值！
        // OC 中如果是 copy 属性，应该 _成员变量 = 值.copy!；
        didSet{
            // 此时name属性已经有值，可以直接设置UI属性
            text = person?.name
        }
    }
    
}
