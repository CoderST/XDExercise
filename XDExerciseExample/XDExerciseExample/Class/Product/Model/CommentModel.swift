//
//  CommentModel.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/3.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import HandyJSON
class CommentModel: HandyJSON {

    var code: Int = 0
    
    var hot_total: Int = 0
    /// 新鲜评论
    var list: [CommentList] = [CommentList]()
    /// 热门评论
    var hot_list: [CommentList] = [CommentList]()
    
    var total: Int = 0
    
    required init() {}
    
}
class CommentList: HandyJSON {
    
    var province: String = ""
    
    var spec: String = ""
    
    var is_read: String = ""
    
    var user_id: String = ""
    
    var zan_count: String = ""
    
    var is_zan: String = ""
    
    var comment_image: String = ""
    
    var type_id: String = ""
    
    var seller_delete: String = ""
    
    var admin_id: String = ""
    
    var root_id: String = ""
    
    var city: String = ""
    
    var deep: Int = 0
    
    var system: String = ""
    
    var order_id: String = ""
    
    var type: String = ""
    
    var ID: String = ""
    
    var show: String = ""
    
    var add_time: String = ""
    
    var user_info: User_Info = User_Info()
    
    var target_uid: String = ""
    
    var pid: String = ""
    
    var target_cid: String = ""
    
    var price: String = ""
    
    var isCommented: Int = 0
    
    var last_update_time: String = ""
    
    var content: String = ""
    
    required init() {}
    
}

class User_Info: HandyJSON {
    
    var nick_name: String = ""
    
    var gender: Int = 0
    
    var user_id: String = ""
    
    var avatar: String = ""
    
    required init() {}
    
}
