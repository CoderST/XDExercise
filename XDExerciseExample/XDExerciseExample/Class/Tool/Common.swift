//
//  Common.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/14.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit

// MARK:- 常量
/// 屏幕宽
let kScreenW = UIScreen.main.bounds.width
/// 屏幕高
let kScreenH = UIScreen.main.bounds.height
/// 屏幕宽高
let kcreenSize = UIScreen.main.bounds.size
/// 轮播图高度
let kSycleHei : CGFloat = kScreenW * 0.7
/// 行高
let kRowHei : CGFloat = CGFloat(kcreenSize.width) * 9.0 / 16.0
/// 是否是苹果X
let IS_IPhoneX = (kScreenW == CGFloat(375.0) && kScreenH == CGFloat(812.0) ? true : false)
/// 状态栏高度
let kStatusbarH = IS_IPhoneX ? CGFloat(44.0) : CGFloat(20.0)
/// Nav高度
let kNavibarH = IS_IPhoneX ? CGFloat(88.0) : CGFloat(64.0)
/// Tabbar高度
let kTabbarH = IS_IPhoneX ? CGFloat(49.0+34.0) : CGFloat(49.0)
/// 屏幕宽
let kCellHeight : CGFloat = 44

// MARK:- 间距
/// 推荐
let recommentMargin : CGFloat = 15

// MARK:- 字体
/// 推荐-标题
let recommentTitleFont = UIFont.systemFont(ofSize: 17.5)
/// 推荐-价格
let recommentPriceFont = UIFont.systemFont(ofSize: 14)
/// 推荐-话题
let recommentTopicFont = UIFont.systemFont(ofSize: 12.5)
/// 推荐-评论
let recommentCommentFont = UIFont.systemFont(ofSize: 12.5)

/// 商品详情 - 标题
let productDetailHeadTitleFont = UIFont.boldSystemFont(ofSize: 20)
/// 商品详情 - 子标题
let productDetailHeadSubTitleFont = UIFont.boldSystemFont(ofSize: 15)
/// 商品详情 - 浏览
let productDetailHeadBrowseFont = UIFont.boldSystemFont(ofSize: 10)

// MARK:- 颜色
let recommentCommentColor = UIColor(r: 0.2, g: 0.4, b: 0.6)
let XDGlobalOrangeTextColor = UIColor.orange
let productDetailHeadTitleColor = UIColor(hex: "#000000")
let productDetailHeadSubTitleColor = UIColor(hex: "#333333")
// MARK:- version
let version_10 = "1.0"
let version_285 = "2.8.5"

// MARK:- 请求个数
let item_count = 20




// MARK:- debugLog
// http://www.jianshu.com/p/88c59eea39f0
func debugLog<T>(_ message : T, file : String = #file, lineNumber : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):line:\(lineNumber)]- \(message)")
        
    #endif
}

// MARK:- 获取MainNavigationController
func kNavigation()->UINavigationController{
    let window = UIApplication.shared.keyWindow!
    let tabVC = window.rootViewController as!UITabBarController
    let nav = tabVC.selectedViewController as!UINavigationController
    return nav
}
