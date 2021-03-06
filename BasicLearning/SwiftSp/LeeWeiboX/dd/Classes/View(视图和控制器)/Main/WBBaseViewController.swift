//
//  WBBaseViewController.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

// 面试题：OC 中支持多继承吗？如果不支持，如何替代？答案：使用协议替代！
// Swift 的写法更类似于多继承
//class WBBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
// Swift 中利用extension 可以把函数按照功能分类管理，便于阅读和维护！
// 注意：
//      1. extension 中不能有属性
//      2. extension 中不能重写`父类`方法！重写父类方法是子类的职责，扩展是对类的扩展！

// 所有控制器的基类控制器
class WBBaseViewController: UIViewController {

    // 用户登录标记
    var userLogon = false
    
    /// 访问视图信息字典
    var visitorInfoDictionary: [String: String]?
    
    // 表格视图 - 如果用户没有登录，就不创建
    var tableView: UITableView?
    // 刷新控件
    var refreshControl: UIRefreshControl?
    // 上拉刷新标记
    var isPullup = false
    
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen.cz_screenWidth(), height: 64))
    
    // 自定义的导航项
    lazy var navItem = UINavigationItem()
    
    override var title: String?{
        didSet{
            navItem.title = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = UIColor.cz_random()
        setupUI()
        loadData()
    }
    
    /// 加载数据 - 具体的实现由子类负责
    @objc func loadData(){
            // 如果子类不实现任何方法，默认关闭刷新
            refreshControl?.endRefreshing()
    }
    
    private func setupUI(){
        view.backgroundColor = UIColor.white
        
        // 取消自动缩进 - 如果隐藏了导航栏，会缩进20个点
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        userLogon ? setupTableView() : setupVisitorView()
    }
    
    /// 设置表格视图 - 用户登录之后执行
    /// 子类重写此方法，因为子类不需要关心用户之前的逻辑
    func setupTableView(){
        tableView = UITableView(frame: view.frame, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        // 设置数据源和代理 -> 目的：子类直接实现数据源方法
        tableView?.dataSource = self
        tableView?.delegate = self
        
        // 设置内容缩进
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height,
                                               left: 0,
                                               bottom: 0, // 如果下边也被隐藏，则设置下边距 bottom: tabBarController?.tabBar.bounds.height ?? 49,
                                               right: 0)
        // 设置刷新控制
        // 1> 实例化控件
        refreshControl = UIRefreshControl()
        
        // 2> 添加到表格视图
        tableView?.addSubview(refreshControl!)
        
        // 3> 添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
    }
    
    
    /// 设置访客视图
    private func setupVisitorView(){
        let visitorView = WBVisitorView(frame: view.bounds)
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        print(visitorView)
        
        // 1. 设置访客视图信息
        visitorView.visitorInfo = visitorInfoDictionary
        
        // 2. 添加访客视图按钮的监听方法
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        // 3. 设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
    /// 设置导航条
    private func setupNavigationBar(){
        // 添加导航条
        view.addSubview(navigationBar)
        
        // 将 item 设置到 bar
        navigationBar.items = [navItem]
        // 1> 设置 navBar 整个背景的背景颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        // 2> 设置 navBar 的字体颜色
        navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        // 3> 设置系统按钮的文字渲染颜色
        navigationBar.tintColor = UIColor.orange
        
    }
}

// MARK: - 访客视图监听方法
extension WBBaseViewController{
    @objc func login(){
        print("用户登录")
    }
    
    @objc func register(){
        print("用户注册")
    }
}

// MARK: - 设置界面
extension WBBaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // 基类只是准备方法，子类负责具体实现
    // 子类的数据源方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    /// 在显示最后一行时，做上拉刷新
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - cell: <#cell description#>
    ///   - indexPath: <#indexPath description#>
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 1. 判断 indexPath 是否最后一行(indexPath.section[最后] / indexPath.row[最后一行])
        // 1> row
        let row = indexPath.row
        // 2> section
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0{
            return
        }
        
        // 3> 行数
        let count = tableView.numberOfRows(inSection: section)
        
        // 如果是最后一行，同时没有开始上拉刷新
        if row == (count - 1) && !isPullup{
            print("上拉刷新")
            isPullup = true
            
            // 开始刷新
            loadData()
        }
        
        print("section ---- \(section)" )
    }
}

