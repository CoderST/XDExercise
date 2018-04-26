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

// HandyJSON支持枚举，只需要enum构造时服从HandyJSONEnum协议即可
enum Vip_Type:Int,HandyJSONEnum{
    /// 未认证
    case vip_none = 0
    /// 已认证
    case vip_ok = 1
    /// 认证中
    case vip_ing = 2
    /// 被拒绝
    case vip_refuse = 3
}

enum Official_Type:Int,HandyJSONEnum{
    /// 未认证
    case official_none = 0
    /// 已认证
    case official_ok = 1
    /// 认证中
    case official_ing = 2
    /// 被拒绝
    case official_refuse = 3
}

enum Celebrity_Type:Int,HandyJSONEnum{
    /// 未认证
    case celebrity_none = 0
    /// 已认证
    case celebrity_ok = 1
    /// 认证中
    case celebrity_ing = 2
    /// 被拒绝
    case celebrity_refuse = 3
}

class Certification: HandyJSON {
    /// 会员
    var if_vip: Vip_Type = .vip_none
    /// 达人
    var if_official_vip: Official_Type = .official_none
    /// 官方
    var if_celebrity_vip: Celebrity_Type = .celebrity_none
    required init() {}
}
