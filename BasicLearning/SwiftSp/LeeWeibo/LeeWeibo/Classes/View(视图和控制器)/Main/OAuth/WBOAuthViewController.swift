//
//  WBOAuthViewController.swift
//  LeeWeibo
//
//  Created by leven on 2017/11/9.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 通过 webView 加载新浪微博授权页面控制器
class WBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        // 取消滚动视图 - 新浪微博的服务器，返回的授权页面默认就是全屏显示
        webView.scrollView.isScrollEnabled = false
        
        // 设置代理
        webView.delegate = self
        
        // 设置导航栏
        title = "登录新浪微博"
        // 导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        // 1> URL 确定要访问的资源
        guard let url = URL(string: urlString) else{
                return
        }
        // 2> 建立请求
        let request = URLRequest(url: url)
        // 3> 加载请求
        webView.loadRequest(request)
        
    }
    
    deinit {
        let cookieStorage = HTTPCookieStorage.shared
        for cookie in cookieStorage.cookies ?? [] {
            cookieStorage.deleteCookie(cookie)
        }
        URLCache.shared.removeAllCachedResponses()
        
    }
    
    // MARK: - 监听方法
    /// 关闭控制器
    @objc private func close(){
        SVProgressHUD.dismiss()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    /// 自动填充 - WebView 的注入，直接通过 js 修改 `本地浏览器中` 缓存的页面内容
    /// 点击登录按钮执行 submit() 将本地数据提交给服务器！
    @objc private func autoFill(){
        // 准备 js
        let js = "document.getElementById('userId').value = '';" +
            "document.getElementById('passwd').value = ''; ";
        
        // 让 webView 执行 js
        webView.stringByEvaluatingJavaScript(from: js)
    }
}

extension WBOAuthViewController : UIWebViewDelegate {
    
    
    /// webView 将要加载请求
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - request: 要加载的请求
    ///   - navigationType: 导航类型
    /// - Returns: 是否加载 request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("为什么的url：\(request.url)")
        // 确认思路
        // 1. 如果请求地址包含 http:// baidu.com 不加载页面  / 否则加载页面
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        //print("加载请求 --- \(request.url?.absoluteString)")
        // query 就是 URL 中 `?` 后面的所有部分
        //print("加载请求 --- \(request.url?.query)")
        // 2. 从 http://baidu.com回调地址查询字符串中查询 `code=`
        // 如果有，说明授权成功，否则授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            close()
        }
        
        // 3. 从query 字符串中取出 授权码
        // 代码走到此处，url 中一定有 查询字符串，且有`code=`
        // code=4909b2c0e7b1839b8d725e247038ead0
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        print("获取授权码... \(code)")
        
        // 4. 使用授权码获取（换取）access_token
        WBNetworkManager.shared.loadAccessToken(code: code){(isSucess) in
            if !isSucess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            }else{
                // SVProgressHUD.showInfo(withStatus: "登录成功")
                
                // 通过通知发送登录成功消息
                // 1> 发送通知 -  不关心有没有接收
                NotificationCenter.default.post(name: Notification.Name(rawValue: WBUserLoginSuccessedNotification), object: nil)
                
                // 2> 关闭窗口
                self.close()
                
            }
        }
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
