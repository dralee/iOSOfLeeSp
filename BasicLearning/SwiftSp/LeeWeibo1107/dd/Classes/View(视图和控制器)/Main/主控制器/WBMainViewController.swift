//
//  WBMainViewController.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

// 主控制器
class WBMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllers()
        setupComposeButton()
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
        // 将向内缩进的宽度减少，能够让按钮的宽度变大，防止穿帮！
        let w = tabBar.bounds.width / count - 1 // 减1除去容错点
        // 设置按钮的位置
        // CGRectInsert 正数向内缩进，负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        print("按钮宽度 \(composeButton.bounds.width)")
        
        // 按钮监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    // 设置所有子控制器
    private func setupChildControllers(){
        
        // 从 bundle 加载配置的 json
        guard let path = Bundle.main.path(forResource: "main.json", ofType: nil),
            let data = NSData(contentsOfFile: path),
            let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String: Any]] else{
            return
        }
        
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
