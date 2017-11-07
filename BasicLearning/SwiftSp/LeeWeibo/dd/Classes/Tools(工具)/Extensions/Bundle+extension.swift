//
//  Bundle+extension.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

extension Bundle {

    var namespace: String{
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
