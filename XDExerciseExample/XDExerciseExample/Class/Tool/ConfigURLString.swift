//
//  ConfigURLString.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/17.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
// MARK:- 总接口
let API_URL = "https://xdapi2.beta.xiudou.net/Interfaces/index"
let H5_URL = "https://m.beta.xiudou.net"

let XD_IOS = "XD_IOS"
let XD_UUID_IDENTIFIER = "XD_UUID_IDENTIFIER"
let kUDS = UserDefaults.standard
//let kTOKEN = kUDS.string(forKey: "token") ?? ""
var kTOKEN : String{
    get{
        let token = kUDS.string(forKey: "token") ?? ""
        return token
    }
    
}
let kUSER_ID = kUDS.string(forKey: "user_id") ?? ""
let XDCommentUserKey = "XDCommentUserKey";



// MARK:- 1 用户
let USER_URL = "/user" //用户地址段
let SIGN_IN_URL = "/sign_in" //登录

// MARK:- 2 订单order
let ORDER_URL = "/order" //订单

// MARK:- 3 首页
let INDEX_URL = "/index" // 首页地址段
/// 3.21 - 2.8.5 首页列表:index/get_home_recommend_list
let GET_HOME_RECOMMEND_LIST = "/get_home_recommend_list"
/// 3.16-2.5.9 首页推荐买家秀列表
let BUYERS_SHOW_LIST = "/buyers_show_list"

// MARK:- 4 商品
let PRODUCT_URL = "/product"
/// 4.71 - 2.8.0 商品详情
let PRODUCT_DETAIL = "/product_detail"

// MARK:- 8 评论
let COMMENT_URL = "/comment"
/// 8.2.1-2.7.32 获取日常热门评论列表
let GET_HOT_COMMENT_LIST = "/get_hot_comment_list"

//27 积分抽奖签到
let INTEGRAL = "/integral"
/// 用户签到
let INTEGRAL_USER_SIGN  = "/userSign"

// MARK:- CELL-Identifier
let RecommendTopicCellIdentifier = "RecommendTopicCellIdentifier"
let RecommendCommentCellIdentifier = "RecommendCommentCellIdentifier"

