//
//  Bundle+extension.swift
//  Reflector
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

extension Bundle{

    // 返回命名空间字符串
//    func namespace() -> String{
//        //return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
//        return infoDictionary?["CFBundleName"] as? String ?? ""
//    }
    
    var namespace: String{
        //return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
