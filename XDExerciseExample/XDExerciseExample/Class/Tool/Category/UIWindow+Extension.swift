//
//  UIWindow.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/26.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import Foundation
extension UIWindow{
    
    func visibleViewController()->UIViewController?{
        guard let window = UIApplication.shared.delegate?.window else{
            debugLog("没有window")
            return nil
        }
        guard let rootViewController = window?.rootViewController else {
            debugLog("没有rootViewController")
            return nil
            
        }
        
        return UIWindow.getVisibleViewControllerFrom(rootViewController)
    }
    
    class fileprivate func getVisibleViewControllerFrom(_ rootvc : UIViewController)->UIViewController{
        if rootvc is UINavigationController {
            let vc = rootvc as! UINavigationController
            guard let visiVc = vc.visibleViewController else{
                return rootvc
            }
            return getVisibleViewControllerFrom(visiVc)
        }else if(rootvc is UITabBarController){
            let vc = rootvc as! UITabBarController
            guard let visiVc = vc.selectedViewController else{
                return rootvc
            }
            return getVisibleViewControllerFrom(visiVc)
        }else{
            let prevc = rootvc.presentedViewController
            guard let visiVc = prevc else{
                return rootvc
            }
            return getVisibleViewControllerFrom(visiVc)
        }
    }
    
}
