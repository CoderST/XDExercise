//
//  RegisterUserModel.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/1.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import HandyJSON
class RegisterUserModel: HandyJSON {

    var auth_token : String = ""
    
    var avatar : String = ""
    
    var chat_token : String = ""
    
    var code : Int = 0
    
    var forward_rewards : String = ""
    
    var if_celebrity_vip : String = ""
    
    var if_official_vip : String = ""
    
    var if_vip : String = ""
    
    var is_locking : String = ""
    
    var is_net_transaction_service : Int = 0
    
    var is_securied_transaction : String = ""
    
    var is_seven_day_refund : String = ""
    
    var phone_number : String = ""
    
    var seller_level : String = ""
    
    var sgin : String = ""
    
    var shopping_package_count : String = ""
    
    var user_id : String = ""
    
    var nick_name : String = ""
    
    required init() {}
    
}
class Setting: HandyJSON {
    
    var notification_setting: Notification_Setting = Notification_Setting()
    
    required init() {}
    
}
class Notification_Setting: HandyJSON {
    
    var notification_immediate: String = ""
    
    var notification_wifi_auto_cache_video: String = ""
    
    var notification_order: String = ""
    
    var notification_detail: String = ""
    
    var notification_wifi_auto_play_video: String = ""
    
    var notification_comment: String = ""
    
    var notification_commission: String = ""
    
    var notification_system: String = ""
    
    required init() {}
    
}
