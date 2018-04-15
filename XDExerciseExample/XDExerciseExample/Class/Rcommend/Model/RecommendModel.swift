//
//  RecommendModel.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/15.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import HandyJSON
class RecommendModel: HandyJSON {
    var code: Int = 0
    
    var list: List?
    required init() {}
}

class List: HandyJSON {
    
    var video: [Video] = [Video]()
    
    var recommend: [Recommend] = [Recommend]()
    required init() {}
}

class Video: HandyJSON {
    
    var video_width: String = ""
    
    var video_url: String = ""
    
    var media_type: Int = 0
    
    var video_height: String = ""
    
    var product_header_image: String = ""
    
    var video_id: String = ""
    
    var video_header_image: String = ""
    
    var video_url_stream: String = ""
    
    var product_name: String = ""
    
    var max_price: String = ""
    
    var type: String = ""
    
    var product_views_count: Int = 0
    
    var product_header_image_32: String = ""
    
    var video_duriation: String = ""
    
    var product_id: String = ""
    
    var product_play_count: Int = 0
    
    var product_comment_count: Int = 0
    
    var user: User?
    
    var hot_list: [String] = [String]()
    
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

class Recommend: HandyJSON {
    
    var recommend_id: String = ""
    
    var recommend_type: String = ""
    
    var recommend_images: String = ""
    
    var recommend_images_32: String = ""
    
    var recommend_title: String = ""
    
    var recommend_content: String = ""
    required init() {}
}
