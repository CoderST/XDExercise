//
//  RecommendMainModel.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/15.
//  Copyright © 2018年 CoderST. All rights reserved.
//  轮播 + 视频等信息

import UIKit
import HandyJSON
class RecommendMainModel: HandyJSON {
    var code: Int = 0
    
    var list: List?
    required init() {}
}

class List: HandyJSON {
    
    var video: [Video] = [Video]()
    
    var recommend: [Recommend] = [Recommend]()
    required init() {}
}

// HandyJSON支持枚举，只需要enum构造时服从HandyJSONEnum协议即可
enum Media_Type:Int,HandyJSONEnum{
    case video = 1 // 视频类型
    case image = 2 // 图片类型
}

enum NormalOrProduct_Type:Int,HandyJSONEnum{
    case product = 1 // 商品
    case normal = 2 // 日常
}
class Video: HandyJSON {
    
    var video_width: String = ""
    
    var video_height: String = ""
    
    var video_url: String = ""
    
    //1.视频 2.图片 隐藏播放按钮
    var media_type: Media_Type = .video
    
    var product_header_image: String = ""
    
    var normal_header_image: String = ""
    
    var video_id: String = ""
    
    var video_header_image: String = ""
    
    var video_url_stream: String = ""
    
    var product_name: String = ""
    
    var normal_name : String = ""
    
    var max_price: String = ""
    // 1:商品  2:日常
    var type: NormalOrProduct_Type = .normal
    
    var product_views_count: Int = 0
    
    var product_header_image_32: String = ""
    
    var video_duriation: String = ""
    
    var product_id: String = ""
    
    var product_play_count: Int = 0
    
    var product_comment_count: Int = 0
    
    var user: User = User()
    
    var hot_list: [HotDict] = [HotDict]()
    
    var product_fav_count: Int = 0
    
    var is_faved: Int = 0
    
    var video_url_https: String = ""
    
    var price: String = ""
    
    var forward_price: Int = 0
    
    var product_forward_count: Int = 0
    
    var topics: [String] = [String]()
    
    var max_forward_price: Int = 0
    required init() {}
}
class HotDict: HandyJSON {
 
    var id : String = ""
    
    var pid : String = ""
    
    var root_id : String = ""
    
    var target_uid : String = ""
    
    var target_cid : String = ""
    
    var add_time : String = ""
    
    var content : String = ""
    
    var zan_count : String = ""
    
    var show : String = ""
    
    var is_zan : String = ""
    
    var user_info : UserInfor = UserInfor()
    
    var target_user_info : UserInfor = UserInfor()
    
    required init() {}
}

class UserInfor: HandyJSON {
    
    var avatar : String = ""
    
    var nick_name : String = ""
    
    var user_id : String = ""
    
    var genden : Int = 0
    
    required init() {}
}

class Recommend: HandyJSON {
    
    var recommend_id: String = ""
    
    var recommend_type: String = ""
    
    var recommend_images: String = ""
    
    var recommend_images_32: String = ""
    
    var recommend_title: String = ""
    
    var recommend_content: String = ""
    required init() {}
}
