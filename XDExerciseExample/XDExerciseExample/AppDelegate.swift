//
//  AppDelegate.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/14.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import AVFoundation
import Reachability
import SVProgressHUD
import Bugly

enum H5GO_TYPE : String{
    /// 商品 go 商品详情页
    case PRODUCT = "product"
    /// 日常 go 日常详情页
    case NORMAL = "normal"
    /// 想要 go 商品详情页
    case IWANT = "iwant"
    /// 个人主页 go 个人主页
    case PERSONHOME = "person_home"
    /// 活动 go 日常详情页
    case ACTION = "action"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var reach: Reachability?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        kUDS.removeObject(forKey: "token")
        kUDS.synchronize()
        /// 监听网络状态
        checkoutNetworkStatus()
        /// 设置SDK
        setupSDK()
        /// 设置住窗口
        setupMainWindow()
        
        let session = AVAudioSession()
        
        do{
            
            try session.setCategory(AVAudioSessionCategoryPlayback, with: [])
            
            try session.setActive(true)
            
        }catch{
            
            
            
        }
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //[[NSNotificationCenter defaultCenter]  postNotificationName:AppDelegateWillEnterForegroudKey object:nil];
        

//        NotificationCenter.default.post(name: AppDelegateWillEnterForegroudKey, object: nil)
    }

    /// NSTime进入后台继续执行
    func applicationWillTerminate(_ application: UIApplication) {

        let app = UIApplication.shared
        var bgTask : UIBackgroundTaskIdentifier?
        bgTask = app.beginBackgroundTask {
            DispatchQueue.main.async(execute: {
                if (bgTask != UIBackgroundTaskInvalid)
                {
                    bgTask = UIBackgroundTaskInvalid;
                }
            })
        }
        
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                if (bgTask != UIBackgroundTaskInvalid)
                {
                    bgTask = UIBackgroundTaskInvalid;
                }
            }
        }
    }


}

extension AppDelegate {
    
    fileprivate func setupSDK(){
    
//         Bugly.startWithAppId("此处替换为你的AppId")
        /// 开始监控crash
        Bugly.start(withAppId: BUGLY_APPID)
        
        /// 卡顿上报
        let config = BuglyConfig()
        config.debugMode = true
        config.blockMonitorEnable = true
        config.blockMonitorTimeout = 2
        config.consolelogEnable = true
        config.delegate = self
        Bugly.start(withAppId: BUGLY_APPID, config: config)
        
    }
    

    
    /// 设置主窗口
    fileprivate func setupMainWindow() {
        // 1.创建窗口
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 2.设置根控制器
//        let account = DZAccount.account()
        //        if account != nil{
        let tabBarController = MainTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        //        }else{
        // 进入登录界面
        //        }
        
        
    }
    
    /// 检查网络状态
    fileprivate func checkoutNetworkStatus(){
        reach = Reachability.forInternetConnection()
        
        // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        reach!.reachableOnWWAN = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged),
            name: NSNotification.Name.reachabilityChanged,
            object: nil
        )
        
        reach!.startNotifier()
    }
    
    
    @objc fileprivate func reachabilityChanged(notification: NSNotification) {
        if reach!.isReachableViaWiFi() || reach!.isReachableViaWWAN() {
            SVProgressHUD.showInfo(withStatus: "service avalaible")
        } else {
            SVProgressHUD.showInfo(withStatus: "No service avalaible")
//            print("No service avalaible!!!")
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        handleOpenFromLinePayWithUrl(url)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        handleOpenFromLinePayWithUrl(url)
        return true
    }
    
    func handleOpenFromLinePayWithUrl(_ url : URL){
        /// 如果是tabbar类型 就从对应tabbar首页跳转 发出通知 从首页进行跳转
        
        /// 2 用下面方法跳
        debugLog(url)
        guard  let urlLowercased = url.scheme?.lowercased() else {
            debugLog("没有URL")
            return
        }
        
        guard urlLowercased == "xiudouios" else {
            return
        }
        
        guard let urlHost = url.host else {
            return
        }

        guard urlHost == "detail" else {
            return
        }
        
        let relativePath = url.relativePath as NSString
        if relativePath.hasPrefix("/"){
            
            var ID = ""
            if let pid = url.query{
                let mypid = pid as NSString
                if mypid.contains("="){
                    let stringArray = mypid.components(separatedBy: "=")
                    ID = stringArray.last ?? ""
                }
            }
            
            
            let path = relativePath.substring(from: 1)
            guard let type = H5GO_TYPE(rawValue: path) else {
                return
            }
            
            switch type {
            case .PRODUCT:
                debugLog("PRODUCT")
                let productVC = ProductDetailVC()
                productVC.product_id = ID
                let rootvc = MainNavigationController(rootViewController: productVC)
                /// 延迟跳转
                let time: TimeInterval = 0.5
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
//                    // 如果window存在 普通跳转
//
//                    // 如果window不存在,
//                    self.window?.visibleViewController()?.navigationController?.present(rootvc, animated: true, completion: nil)
//
////
//                }
//                self.window?.visibleViewController()?.navigationController?.pushViewController(productVC, animated: true)
                self.window?.visibleViewController()?.navigationController?.present(rootvc, animated: true, completion: nil)
                
            case .NORMAL:
                debugLog("NORMAL")
            case .PERSONHOME:
                debugLog("PERSONHOME")
            case .IWANT:
                debugLog("IWANT")
            case .ACTION:
                debugLog("ACTION")
            default:
                debugLog("default==")
            }
            
        }
     
        
        
        
    }
}

extension AppDelegate : BuglyDelegate{
    func attachment(for exception: NSException?) -> String? {
        return "Do you want to do..."
    }
}

