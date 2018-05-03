//
//  MoreActivityVC.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/26.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
//import WebViewJavascriptBridge
class MoreActivityVC: UIViewController {

    fileprivate lazy var webView : UIWebView = UIWebView()
    fileprivate var bridge : WebViewJavascriptBridge!
    fileprivate var responseCallback : WVJBResponseCallback?
    override func viewDidLoad() {
        super.viewDidLoad()

        let token = "NPr9OVVKOaHSeqOrNmziX6ckb1PGlgEuRnucNdO5KNvf6MU5dXMGhVZKjSU2OAql4hxNbHTsS7ToMbglG%2Bw3HA%3D%3D"
        let urlS = "https://m.beta.xiudou.net/integral/userSign.html?auth_token=\(token)&client=iOS"
        let urll = urlS as NSString
//        let uuuf8 = urll.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        view.addSubview(webView)
        webView.frame = CGRect(x: 0, y: kStatusbarH, width: kScreenW, height: kScreenH - kStatusbarH)
        
        let url = URL(string: urll as String)!
        webView.loadRequest(URLRequest(url: url))
        
        //1 开启日志，方便调试
        WebViewJavascriptBridge.enableLogging()
        //2 第二步：给ObjC与JS建立桥梁
        // 给哪个webview建立JS与OjbC的沟通桥梁
//        bridge = WebViewJavascriptBridge(forWebView: webView)
//        bridge = WebViewJavascriptBridge(for: webView)
        bridge = WebViewJavascriptBridge(for: webView, webViewDelegate: self, handler: { (result, responseCallBack) in
            
        })
        // 设置代理，如果不需要实现，可以不设置
        //3 第三步：注册HandleName，用于给JS端调用iOS端
        /* JS主动调用OjbC的方法
         这是JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
         JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
         OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
         */
        
        bridge.registerHandler("goBack") { (result, responseCallBack) in
            print("js call getUserIdFromObjC, data from js is",result as Any)
            if responseCallBack != nil{
                
                if self.navigationController != nil{
                    if self.navigationController?.viewControllers.count == 1{
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
                // 反馈给JS
//                let par = ["userId": "123456"]
//                responseCallBack!(par)
            }
            
        }
        
//        bridge.registerHandler("getBlogNameFromObjC") { (result, responseCallBack) in
//            if responseCallBack != nil{
//                print("js call getUserIdFromObjC, data from js is",result)
//                // 反馈给JS
////                responseCallBack!(["blogName": "标哥的技术博客"])
//            }
//
//        }
        
        //4 第四步：直接调用JS端注册的HandleName
        if responseCallback != nil{
            responseCallback!(token)
            responseCallback = nil
        }
//        bridge.callHandler("version", data: "2.8.2")
//        bridge.callHandler("getUserInfos", data: ["name": "标哥"]) { (responseData) in
//            print("from js",responseData as Any)
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension MoreActivityVC : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        debugLog("webViewDidStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        debugLog("webViewDidFinishLoad")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}

extension MoreActivityVC{
    
    func addBendiData(){
        // 加载本地数据
        let path = Bundle.main.path(forResource: "test", ofType: "html") ?? ""
        do {
            let appHtml = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            let baseURL = URL(fileURLWithPath: path as String)
            webView.loadHTMLString(appHtml as String, baseURL: baseURL)
        } catch  {
            debugLog("错误了")
        }
    }
}
