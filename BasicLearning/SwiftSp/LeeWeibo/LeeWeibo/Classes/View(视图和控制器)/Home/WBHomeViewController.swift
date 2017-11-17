//
//  WBHomeViewController.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/6.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

// 定义全局常量，尽量使用 private 修饰，否则到处都可以访问
private let cellId = "cellId"

class WBHomeViewController: WBBaseViewController {
    
    /// 列表视图模型
    private lazy var listViewModel = WBStatusListViewModel()

    /// 微博数据数组
    private lazy var statusList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /// 显示好友
    @objc private func showFriends(){
        print(#function)
        let vc = WBDemoViewController()
        
        // push时藏起来（传统做法）
        // vc.hidesBottomBarWhenPushed = true
        
        // push 的动作是 nav 做的
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setupTableView() {
        super.setupTableView()
        
        // 换成自定义的导航
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target:self, action: #selector(showFriends))
        
        // 注册原型 cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupNavTitle()
    }
    
    /// 设置导航栏标题
    private func setupNavTitle(){
        
        let title = WBNetworkManager.shared.userAccount.screen_name
//        let button = UIButton.cz_textButton(title, fontSize: 17, normalColor: UIColor.darkGray, highlightedColor: UIColor.black)
//        button?.setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
//        button?.setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)

        let button = WBTitleButton(title: title)
        navItem.titleView = button
        
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
    }
    
    @objc private func clickTitleButton(btn: UIButton){
        // 设置选中状态
        btn.isSelected = !btn.isSelected
    }
    
    /// 设置界面
//    override func setupUI() {
//        // 调用父类方法
//        super.setupUI()
//
//        // 设置导航栏按钮
//        // 无法高亮
//        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友",style: .plain, target: self, action: #selector(showFriends))
//
//        // Swift: 调用 OC 返回 instancetype 的方，判断不出是否可选，加个类型就不需要解包了
////        let btn:UIButton = UIButton.cz_textButton("好友", fontSize: 16, normalColor: .darkGray, highlightedColor: UIColor.orange)
////        btn.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
////
////        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
//
////        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target:self, action: #selector(showFriends))
//        // 换成自定义的导航
//        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target:self, action: #selector(showFriends))
//
//        // 注册原型 cell
//        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
//
//    }
    
    /// 加载数据
    override func loadData() {
        
        print("准备输出最后一条 \(self.listViewModel.statusList.last?.text ?? "")")
        
        listViewModel.loadStatus(pullup: self.isPullup){ (isSucess, hasMorePullup) in
            
            print("加载数据结束")
            
            // 结束刷新控件
            self.refreshControl?.endRefreshing()
            // 恢复上拉刷新标志
            self.isPullup = false
            
            // 刷新表格
            if hasMorePullup {
                self.tableView?.reloadData()
            }
        }
       
//        // 用网络工具 加载微博数据
//        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
//        let params = ["access_token": "2.00E1XKKC7zPzpBd7b06c0c18WDKhgD"]
 // 最简单的请求
//        WBNetworkManager.shared.get(urlString, parameters: params, progress: nil, success: { (_,  json) in
//            print(json)
//        }) { (_, error) in
//            print("网络请求失败 \(error)")
//        }
        
//        WBNetworkManager.shared.request(URLString: urlString, parameters: params) { (json: Any?, isSuccess: Bool) in
//            if isSuccess {
//                print(json)
//            }
//        }
        
//        WBNetworkManager.shared.statusList{ (list, isSucess) in
//            // 字典转模型，绑定表格数据
//            print(list)
//        }
//
//        print("开始加载数据 \(WBNetworkManager.shared)")
//
//        // 模拟延时加载数据 -> dispatch_after
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { // 延时1秒
//            for i in 0..<15 {
//                if self.isPullup {
//                    self.statusList.append("上拉 \(i)")
//                }else{
//                    // 将数据插入到数组的顶部
//                    self.statusList.insert(i.description, at: 0)
//                }
//            }
//
//            print("刷新表格")
//            // 结束刷新控件
//            self.refreshControl?.endRefreshing()
//            // 恢复上拉刷新标志
//            self.isPullup = false
//
//            // 刷新表格
//            self.tableView?.reloadData()
 //       }
        
    }
}


// MARK: - 表格数据源方法，具体的数据源方法实现，不需要 super
extension WBHomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count //statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. 取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        // 2. 设置cell
        cell.textLabel?.text = listViewModel.statusList[indexPath.row].text //statusList[indexPath.row].text
        // 3. 返回cell
        return cell
    }
}
