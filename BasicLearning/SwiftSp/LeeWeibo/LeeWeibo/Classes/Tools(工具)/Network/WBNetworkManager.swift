//
//  WBNetworkManager.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/8.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit
import AFNetworking // 导入框架的文件夹名字

/// Swift 的枚举支持任意数据类型
/// Swift / enum 在 OC 中都只是支持整数
enum WBHTTPMethod{
    case GET
    case POST
}

// 网络管理工具
class WBNetworkManager: AFHTTPSessionManager {

    /// Swift 中的 单例
    /// 静态区/常量/闭包
    /// 在第一次访问时执行闭包，并且将结果保存在shared 常量中
    static let shared = { ()-> WBNetworkManager in
        // 实例化对象
        let instance = WBNetworkManager()
        
        // 设置响应反序列支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        // 返回对象
        return instance
    }()
    
    /// 访问令牌，所有网络请求，都基于此令牌（登录除外）
    /// 为了保护用户安全，token是有时限的，默认用户是三天
    /// 模拟 Token 过期 -> 服务器返回的状态码是 403
//    var accessToken: String? = "2.00E1XKKC7zPzpBd7b06c0c18WDKhgD" //= "2.00E1XKKC7zPzpBd7b06c0c18WDKhgD"
//    // 用户微博 id
//    var uid: String? = "1982540400"
    /// 用户账户的懒加载
    lazy var userAccount = WBUserAccount()
    
    /// 用户登录标志[计算型属性]
    var userLogin: Bool{
        return userAccount.access_token != nil &&
            (userAccount.expiresDate?.compare(Date()) == .orderedDescending) // 不过期
    }
    
    /// 专门负责拼接 token 的网络请求方法
    func tokenRequest(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: Any]?, completion: @escaping (_ json: Any?, _ isSuccess: Bool) -> ()){
     
        // 处理 token 字典
        // 0> 判断 token 是否为 nil，为 nil 直接返回，为nil直接返回，程序执行过程中，一般 token 不会为 nil
        guard let accessToken = userAccount.access_token else{
            
            print("没有 token! 需要登录")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
            
            completion(nil, false)
            
            return
        }
        
        // 1> 判断 参数字典是否存在，如果 为 nil，应该新建一个字典
        var parameters = parameters
        if parameters == nil{
            // 实例化字典
            parameters = [String: Any]()
        }
        
        // 2> 设置参数字典
        parameters!["access_token"] = accessToken
        
        request(method: method, URLString: URLString, parameters: parameters, completion: completion)
    }
    
    // lazy var xxx = UIButton()
    
    /// 使用一个函数封装 AFN 的 GET / POST 请求
    
    /// 封装 AFN 的 GET / POST 请求
    ///
    /// - Parameters:
    ///   - method:  GET / POST
    ///   - URLString: URLString
    ///   - parameters: 参数字典
    ///   - completion: 完成回调[json（字典/数组），是否成功]
    func request(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: Any]?, completion: @escaping (_ json: Any?, _ isSuccess: Bool) -> ()){
        
        // 成功回调
        let success = { (task: URLSessionDataTask, json: Any?) -> () in
            completion(json, true)
        }
        
        // 失败回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            // error 通常比较吓人，例如编号：XXXX，错误原因一堆英文
            print("网络请求错误 \(error)")
            
            // 针对 403 处理用户 Token 过期
            if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                print("Token 过期了")
                
                // 发送通知 提示用户再次登录（本方法不知道被谁调用，谁接收到通知，谁处理）
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "Bad token")
                
            }
            
            completion(nil, false)
        }
        
        if method == .GET{
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
