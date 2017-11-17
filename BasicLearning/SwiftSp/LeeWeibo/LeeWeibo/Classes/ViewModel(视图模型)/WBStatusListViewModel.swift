//
//  WBStatusListViewModel.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/8.
//  Copyright © 2017年 lee. All rights reserved.
//

import Foundation

/// 微博数据列表视图模型
/**
 父类的选择
 - 如果类需要使用`KVC`或字典转换模型框架设置对象值，类就需要继承自NSObject
 - 如果类只是包装一些代码逻辑（写了一些函数），可以不用任何父类，好处：更加轻量级
 - 提示：如果用 OC 写，一律继承自 NSObject 即可
 
 使命：负责微博数据处理
 1. 字典转模型
 2.下拉/上拉刷新数据处理
*/

/// 上拉刷新最大尝试次数
private let maxPullupTryTimes = 3

class WBStatusListViewModel {
    
    /// 微博模型数组懒加载
    lazy var statusList = [WBStatus]()
    
    /// 上拉刷新错误次数
    private var pullupErrorTimes = 0
    
    /// 加载微博列表
    ///
    /// - Parameters:
    ///   - pullup: 是否上拉刷新标记
    ///   - completion: 完成回调[网络是否成功，是否刷新表格]
    func loadStatus(pullup: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefrehs: Bool)->()){
        
        // 判断是否是上拉刷新，同时检查刷新错误
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(false, false)
            
            return
        }
        
        // since_id 与 max_id 不能同时有效
        // since_id 取出数组中第一条微博的 id
        let since_id = pullup ? 0 : (statusList.first?.id ?? 0)
        // 上拉刷新 取出数组的最后一条微博的id
        let max_id = pullup ? (statusList.last?.id ?? 0) : 0
        
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSucess) in
            // 1.字典转模型
//            let res:[[String: Any]] = [["id": 1,"name": "lee"],["id": 2,"name": "lee2"],["id": 3,"name": "lee3"]]
//            let ps = Person.cz_objects(with: res).
//            let pers:[Person] = (NSArray.yy_modelArray(with: Person.self, json: res) as? [Person])!
            
            guard let array = NSArray.yy_modelArray(with: WBStatus.self, json: list ?? []) as? [WBStatus] else{
                
                completion(isSucess, false)
                
                return
            }
            
            print("刷新到 \(array.count) 条数据")
            
            // 2.拼接数据
            // 下拉刷新，应该将结果数组拼接在数组前面
            if pullup {
                // 上拉刷新结束后，将结果拼接在数组的后面
                self.statusList += array
            }else{
                // 下拉刷新结束后，将结果拼接在数组前面
                self.statusList = array + self.statusList
            }
            
            // 判断上拉刷新的数据量
            if pullup && array.count == 0{
                self.pullupErrorTimes += 1
                
                completion(isSucess, false)
                
                return
            }
            
            // 3.完成回调
            completion(isSucess, true)
        }
    }
}

class Person : NSObject{
    @objc var id: Int = 0
    @objc var name: String?
    
}
