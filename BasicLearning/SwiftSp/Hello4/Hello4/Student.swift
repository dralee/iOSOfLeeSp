//
//  Student.swift
//  Hello4
//
//  Created by leven on 2017/11/3.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

class Student: Person {
    
    // 学号
    var no: String = ""
    
    override init() {
        print("student init")
        
        no = "0001"        
        
        super.init()
    }
    
    init(name: String, no: String){
        self.no = no
        
        // 调用父类
        super.init(name: name)
    }
}
