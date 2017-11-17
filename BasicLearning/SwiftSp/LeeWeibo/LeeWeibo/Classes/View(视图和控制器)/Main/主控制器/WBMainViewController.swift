//
//  WBMainViewController.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit
import SVProgressHUD

// 主控制器
class WBMainViewController: UITabBarController {

    // 定时器
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllers()
        setupComposeButton()
        setupTimer()
        
        // 设置新特性视图
        setupNewfeatureViews()
        
        // 测试未读数量
//        WBNetworkManager.shared.unreadCount { (count) in
//            print("有 \(count)条新微博")
//        }
        // 设置代理
        delegate = self
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    deinit {
        // 销毁时钟
        timer?.invalidate()
        
        // 注册通知
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
        portrait    ：竖屏，肖像
        landscape   ：横屏，风景画
        - 使用代码控制设备的方向，好处，可以在需要横屏时，单独处理
        - 设置支持的方向之后，当前的控制器及子控制器都会遵守这个方向！
        - 如果播放视频，通常是通过 modal 展现的
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    // MARK: - 监听方法
    @objc private func userLogin(n: Notification){
        print("用户登录通知 \(n)")
        
        var when = DispatchTime.now()
        
        // 判断 n.object 是否有值，如果有值 -> token 过期，提示用户重新登录
        if n.object != nil {
            // 设置指示器渐变样式
            SVProgressHUD.setDefaultMaskType(.gradient) // 渐变地
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            
            // 修改延迟时间
            when = DispatchTime.now() + 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) { // 延时2秒再弹出
            SVProgressHUD.setDefaultMaskType(.clear) // 恢复
            
            // 展现登录控制器 - 通常会和 UINavigationController连用，方便返回
            let nav = UINavigationController(rootViewController: WBOAuthViewController())
            
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    // 撰写微博
    // FIXME： 没有实现
    // private 能保证方法私有，仅在当前对象被访问
    // @objc 允许这个函数在运行时通过 OC 的消息机制被调用！
    @objc private func composeStatus(){
        print("撰写微博")
        
        // 测试方向旋转
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.cz_random()
        let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - 私有控件
    private lazy var composeButton: UIButton = UIButton.cz_imageButton(
        "tabbar_compose_icon_add",
        backgroundImageName: "tabbar_compose_button")
    
}

// MARK: - 新特性视图处理
extension WBMainViewController{
    /// 设置新特性视图
    private func setupNewfeatureViews(){
        
        // 1. 检查版本是否更新
        
        // 1. 如果更新，显示新特性，否则显示欢迎
        let v = isNewVersion ? WBNewFeatureView() : WBWellcome()
        
        // 3. 添加视图
        v.frame = view.bounds
        
        view.addSubview(v)
    }
    
    /// extension 中可以有计算型属性，不会占用存储空间
    /// 构造函数：给属性分配空间
    /**
        版本号
            - 在 AppStore 每次升级应用程序，版本号都需要增加，不能递减
            - 组成 主版本号.次版本号.修订版本号
            - 主版本号：意味着大的修改，使用者也需要做大的适应
            - 次版本号：意味着小的修改，某些函数和方法的使用或都参数有变化
            - 修订版本号：框架/程序内部 bug 的修订，不会对使用者造成任何的影响
     */
    private var isNewVersion: Bool{
        // 1. 取当前的版本号
        //print(Bundle.main.infoDictionary)
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        print(currentVersion)
        
        // 2. 取保存在`Document(iTunes备份)【最理想保存在用户偏好】`目录中的之前的版本号
        let path: String = ("version" as NSString).cz_appendDocumentDir()
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        print("沙盒版本" + sandboxVersion)
        //print(path)
        
        // 3. 将当前版本号保存在沙盒
        try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        // 4. 返回两个版本号`是否一致`
        return currentVersion != sandboxVersion
    }
}

// MARK: 利用代理方法解决 + 号按钮 穿帮
extension WBMainViewController : UITabBarControllerDelegate{
    
    /// 将要选择 TabBarItem
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController
    ///   - viewController: 目标控制器
    /// - Returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        print("将要切换到 \(viewController)")
        
        // 1> 获取控制器在数组中的索引
        let index = (childViewControllers as NSArray).index(of: viewController)
        
        // 2> 判断当前索引是首页，同时 index 也是首页，重复点击首页
        if selectedIndex == 0 && index == selectedIndex {
            print("点击首页")
            // 3> 让表格滚动到顶部
            // a) 获取控制器
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            
            // b) 滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x: 0,y: -64), animated: true)
            
            // 4> 刷新数据
            // 如果有问题可能是Xcode的问题
            //vc.loadData()
            // 可通过下面方式解决
            DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1, execute: {
                vc.loadData()
            })
        }
        
        // 判断目标控制器是否是 UIViewController
        return !viewController.isMember(of: UIViewController.self)
    }
}

// MARK: - 时钟相关方法
extension WBMainViewController{
    // 定义时钟
    private func setupTimer(){
        // 30秒一次
        // 时间间隔建议长一些
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    /// 时钟触发方法
    @objc private func updateTimer(){
        
        if !WBNetworkManager.shared.userLogin {
            return
        }
        
        WBNetworkManager.shared.unreadCount { (count) in
            print("检测到 \(count) 条瓣微博")
            // 设置 首页 tabBarItem 的 badgeNumber
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            // 设置 App 的 badgeNumber，从iOS 8.0 之后，要用户授权之后才显示
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

// extensions 类似于 OC 中中分类，在Swfit中还可以用来切分代码块
// 可以把相近功能的函数，放在一个extension 中
// 便 于代码维护
// 注意：和 OC 的分类一样，extension 中不能定义属性
extension WBMainViewController{
    
    // 设置撰写按钮
    private func setupComposeButton(){
        tabBar.addSubview(composeButton)
        
        // 计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
//        // 将向内缩进的宽度减少，能够让按钮的宽度变大，防止穿帮！
//        let w = tabBar.bounds.width / count - 1 // 减1除去容错点
        let w = tabBar.bounds.width / count  // 通过 UITabBarControllerDelegate shouldSelect 方法判断更科学
        
        // 设置按钮的位置
        // CGRectInsert 正数向内缩进，负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        print("按钮宽度 \(composeButton.bounds.width)")
        
        // 按钮监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    // 设置所有子控制器
    private func setupChildControllers(){
        // 0. 获取沙盒 json 路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        
        // 加载 data
        var data = NSData(contentsOfFile: jsonPath)
        
        // 判断 data 是否有内容，如果没有，说明本地沙盒没有文件
        if data == nil{
            // 从 Bundle 加载 data
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        // data 一定会有一个内容，反序列化
        
        // 反序列化转换成数组
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: Any]] else{
            return
        }
        
        // 从 bundle 加载配置的 json
//        guard let path = Bundle.main.path(forResource: "main.json", ofType: nil),
//            let data = NSData(contentsOfFile: path),
//            let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String: Any]] else{
//            return
//        }
        
        // 在现在的很多引用程序中，界面的创建都依赖网络的 json
//        let array:[[String: Any]] = [
//            ["clsName": "WBHomeViewController","title":"首页", "imageName": "home",
//                "visitorInfo": ["imageName": "","message": "关注一些人，回这里看看有什么惊喜"]],
//            ["clsName": "WBMessageViewController","title":"消息", "imageName": "message_center",
//                "visitorInfo": ["imageName": "visitordiscover_image_message","message": "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知"]],
//            ["clsName": "XXX" ], // 添加一个空的在中间
//            ["clsName": "WBDisconverViewController","title":"发现", "imageName": "discover",
//                "visitorInfo": ["imageName": "visitordiscover_image_message","message": "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过"]],
//            ["clsName": "WBProfileViewController","title":"我", "imageName": "profile",
//                "visitorInfo": ["imageName": "visitordiscover_image_profile","message": "登录后，你的微博、相册、个人资料会显示在这里，展示给别人"]],
//        ]
//
//        // 测试数据格式是否正确 - 转换成 plist 数据更加直观
//        //(array as NSArray).write(toFile: "/Users/leven/Desktop/demo.plist", atomically: true)
//        // 数组 -> json 序列化
//        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
//        (data as NSData).write(toFile: "/Users/leven/Desktop/demo.json", atomically: true)
        
        // 遍历数组，循环创建控制器数组
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        
        // 设置 tabBar 的子控件器
        viewControllers = arrayM
    }
    
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典[clsName, title, imageName]
    /// - Returns: 子控制器
    private func controller(dict: [String: Any]) -> UIViewController {
        
        // 1.取得字典内容
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? WBBaseViewController.Type,
            let visitorDict = dict["visitorInfo"] as? [String: String]
            else{
                return UIViewController()
        }
        
        // 2.创建视图控制器
        // 1>将clsName 转换成 cls
        let vc = cls.init()
        
        vc.title = title
        
        // 设置控制器的访客信息字典
        vc.visitorInfoDictionary = visitorDict
        
        // 3.设置图像
        vc.tabBarItem.image = UIImage(named: "tabbar_"+imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_"+imageName+"_selected")?.withRenderingMode(.alwaysOriginal)
        
        // 4.设置 tabbar 的标题字体（大小）
        vc.tabBarItem.setTitleTextAttributes(
            [NSAttributedStringKey.foregroundColor: UIColor.orange],
            for: .highlighted)
        // 系统默认是 12 号字，修改字体大小，要设置 normal 的字体大小
        vc.tabBarItem.setTitleTextAttributes(
            [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)],
            for: UIControlState.normal)
        
        // 实例化导航控制器时，会调用 push 方法将 rootVC 压栈
        let nav = WBNavigationController(rootViewController: vc)
        
        return nav
    }
}
