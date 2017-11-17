//
//  WBNetworkManager+extension.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/8.
//  Copyright © 2017年 lee. All rights reserved.
//

import Foundation

// MARK: - 封装新浪微博的网络请求方法
extension WBNetworkManager{
    
    
    /// 加载微博数据字典数组
    ///
    ///   - since_id: 返回ID比since_id大的微博，（即比since_id时间晚的微博），默认为0
    ///   - max_id: 返回ID小于或等于max_id的微博，默认为0
    /// - Parameter completion: 完成回调[list：微博字典数组/是否成功]
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: Any]]?, _ isSucess: Bool)->()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let max_id = max_id > 0 ? max_id - 1 : max_id
        let params = ["since_id":since_id, "max_id": max_id]
        
        tokenRequest(URLString: urlString, parameters: params){ (json, isSuccess) in
                
                let result = (json as? [String: Any])?["statuses"] as? [[String: Any]]
                
                completion(result, isSuccess)
        }
    }
    
    /// 返回微博的未读数量
    func unreadCount(completion: @escaping (_ count: Int) -> ()){
        
        guard let uid = userAccount.uid else{
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid": uid]
        
        tokenRequest(URLString: urlString, parameters: params) { (json, isSuccess) in
            let dict = json as? [String: Any]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
            // print(json)
        }
    }
}

// MARK: - 用户信息
extension WBNetworkManager{
    
    /// 加载当前用户信息 - 用户登录后立即执行
    func loadUserInfo(completion: @escaping (_ dict: [String: Any])->()){
        guard let uid = userAccount.uid else{
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let params = ["uid": uid]
        
        tokenRequest(URLString: urlString, parameters: params) { (json, isSuccess) in
            // 完成回调
            completion(json as? [String: Any] ?? [:])
        }
    }
}

// MARK: - OAuth相关方法
extension WBNetworkManager{
    
    /// 提问：网络语法异步到底应该怎么返回？需要返回什么？（闭包）
    /// 加载 access_token
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - completion: 完成回调[是否成功]
    func loadAccessToken(code: String, completion: @escaping (_ isSuccess: Bool)->()){
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type":"authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI]
        
        // 发起网络请求
        request(method:.POST, URLString: urlString, parameters: params) { (json, isSuccess) in
            print(json)
            
            // 如果请求失败，对用户账户数据不会有任何影响
            // 直接用字典设置userAccount 属性
            self.userAccount.yy_modelSet(with: (json as? [String: Any]) ?? [:]) // 空字典 [:]，空数组 []
            
            // 加载当前用户信息
            self.loadUserInfo{ (dict) in
                //print(dict)
                // 使用用户信息字典设置用户账户信息（昵称和头像地址）
                self.userAccount.yy_modelSet(with: dict)
                
                print(self.userAccount)
                // 保存模型
                self.userAccount.saveAccount()
                
                print(self.userAccount)
                
                // 用户信息加载完成再，完成回调
                completion(isSuccess)
            }
            
        }
        
    }
}
