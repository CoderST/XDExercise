//
//  AppDelegate.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/14.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import AVFoundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // 初始化Bugly
//        Bugly.start(withAppId: BUGLY_APP_ID)
        let session = AVAudioSession()
        
        do{
            
            try session.setCategory(AVAudioSessionCategoryPlayback, with: [])
            
            try session.setActive(true)
            
        }catch{
            
            
            
        }
        

        
        kUDS.removeObject(forKey: "token")
        kUDS.synchronize()
        // 设置住窗口
        setupMainWindow()
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
    
    
    
}

