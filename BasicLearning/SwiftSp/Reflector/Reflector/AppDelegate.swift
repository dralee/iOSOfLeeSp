//
//  AppDelegate.swift
//  Reflector
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

// Xcode 8.0 OC 的 NSLog 都不能在控制台输出，所有和OC相关的错误，控制台都无法显示！=> 仅限于beta版会
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // ** 注意：window 是可选的
    var window: UIWindow?

    /**
     1.知道 Swift 中有命名空间
        - 在同一个命名空间下，全局共享
        - 第三方框架使用Swift 如果直接拖拽到项目中，从属于同一个命名空间很有可能冲突
        - 以后尽量都要用 cocoapod
     2.重点要知道 Swift 中 NSClassFromString（反射机制）的写法
        - 反射最重要的目的就是为了解耦！
        - 搜索`反射机制和工厂方法`！
        - 提示：第一印象会发现一个简单的功能，写得很复杂
        - 但是，封装得很好，而且弹性很大！
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // A.常规写法
        // *** 代码中的 ? 都是`可选`解包，发送消息不参与计算
        // 所有的 ? 都是Xcode 自动添加的！
        // 1.实例化 window
//        window = UIWindow()
//        window?.backgroundColor = UIColor.white
//
//        // 2.设置 根控制器
//        let vc = ViewController()
//
//        window?.rootViewController = vc
//
//        // 3.让 window 可见
//        window?.makeKeyAndVisible()
        
        // B.反射写法
        // *** 代码中的 ? 都是`可选`解包，发送消息不参与计算
        // 所有的 ? 都是Xcode 自动添加的！
        // 1.实例化 window
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        
        // ----- 输出 Bundle info.plist 的内容
        // Product Name / 版本 是记录在 info.plist
        // [String: Any]?
        print(Bundle.main.infoDictionary)
        // 1> 因为字典是可选的，因此需要解包再取值
        //      如果 字典 为nil，就不取值
        // 2> 通过key从字典中取值，如果 key 错了，就没有值了
        //      Any? 表示不一定能够获取到值
        //let ns = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        let ns = Bundle.main.namespace
        
        // 2.设置 根控制器，需要添加命名空间 -> 默认就是`项目名称（最好不要有数字和特殊符号）`
        //let clsName = "Reflector.ViewController"
        let clsName = "\(ns).ViewController"
        // AnyClass? -> 视图控制器的类型
        let cls = NSClassFromString(clsName) as? UIViewController.Type
        
        // 使用类创建视图控制器
        // UIViewController?
        let vc = cls?.init()
        //let vc = ViewController()
        
        window?.rootViewController = vc
        
        // 3.让 window 可见
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

