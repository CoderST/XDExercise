//
//  User.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/15.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import HandyJSON
class User: HandyJSON {
    /// 用户名
    var nick_name: String = ""
    /// 性别
    var gender: String = ""
   /// 头像
    var avatar: String = ""
    
    var friend_shop_count: Int = 0 // 没有用到
    /// 签名
    var signature: String = ""
    /// 粉丝数
    var fans_count: Int = 0
    /// 是否关注
    var is_faved: Int = 0
    /// 用户ID
    var user_id: String = ""
    /// 会员等级
    var certification: Certification?
    /// 七天协议认证
    var shop_agreement: [String]?
    
    var seller_level: String = ""
    required init() {}
}

class Certification: HandyJSON {
    /// 会员
    var if_vip: Int = 0
    /// 达人
    var if_official_vip: Int = 0
    /// 官方
    var if_celebrity_vip: Int = 0
    required init() {}
}
