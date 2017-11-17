//
//  WBStatus.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/8.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit
import YYModel

// 微博数据模型
class WBStatus: NSObject {

    /// Int 类型，在64位的机器是64位，在32位机器就是32位的
    /// 如果不写Int64 在 iPad 2/iPhone 5/5c/4s/4 都无法正常运行（数据会益出）
    @objc var id: Int64 = 0
    
    /// 微博的信息内容
    @objc var text: String?
    
    /// 重写 description 的计算型属性
    override var description: String{
        return yy_modelDescription()
    }
}
