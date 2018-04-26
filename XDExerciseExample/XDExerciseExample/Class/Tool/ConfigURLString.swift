//
//  ConfigURLString.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/17.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
let XD_IOS = "XD_IOS"
let XD_UUID_IDENTIFIER = "XD_UUID_IDENTIFIER"
let TOKEN : String = ""
let USER_ID = UserDefaults.standard.string(forKey: "user_id") ?? ""
let XDCommentUserKey = "XDCommentUserKey";
// MARK:- 1 用户
let USER_URL = "/user" //用户地址段
let SIGN_IN_URL = "/sign_in" //登录

// MARK:- 2 订单order
let ORDER_URL = "/order" //订单

// MARK:- 3 首页
let INDEX_URL = "/index" //首页地址段
let GET_HOME_RECOMMEND_LIST = "/get_home_recommend_list" // 3.21 - 2.8.5 首页列表:index/get_home_recommend_list


// MARK:- CELL-Identifier
let RecommendTopicCellIdentifier = "RecommendTopicCellIdentifier"
let RecommendCommentCellIdentifier = "RecommendCommentCellIdentifier"
