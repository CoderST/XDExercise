//
//  JoinActivityVC.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/17.
//  Copyright © 2018年 CoderST. All rights reserved.
//  进入活动

import UIKit
//import WebViewJavascriptBridge
class JoinActivityVC: UIViewController {

    var url : String = ""
    
    // MARK:- 私有
    fileprivate lazy var webView : UIWebView = {
        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        return webView
    }()
    fileprivate var _bridge:WebViewJavascriptBridge?
//    fileprivate lazy var backBtn : UIButton = {
//       let backBtn = UIButton()
//        backBtn.setImage(UIImage(named: ""), for: .normal)
//        backBtn.frame = CGRect(x: 8, y: 28, width: 28, height: 28)
//        return backBtn
//    }()
    
    
    // MARK:- 生命
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        view.addSubview(webView)
//        view.addSubview(backBtn)
        
        WebViewJavascriptBridge.enableLogging()

//        _bridge = WebViewJavascriptBridge(for: webView)
        
        // 返回
        goBackAction("goBack")
    
        
        if let url = URL(string: url){
            webView.loadRequest(URLRequest(url: url))
        }
        
    }


}
// MARK:- JS to IOS
extension JoinActivityVC{
    fileprivate func goBackAction(_ title : String){
        weak var weakSelf = self
        _bridge?.registerHandler(title, handler: { (data, callback) in
            if weakSelf?.webView.canGoBack == true{
                weakSelf?.webView.goBack()
            }else{
                weakSelf?.view.resignFirstResponder()
                weakSelf?.navigationController?.popViewController(animated: true)
            }
        })
    }
}

// MARK:- IOS to JS
extension JoinActivityVC{
    
}
