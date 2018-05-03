//
//  ProductModel.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/29.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import HandyJSON
class ProductModel: HandyJSON {
    
    var product_header_image: String = ""
    
    var product_detail_list: [String] = [String]()
    
    var video_image_list: [Video_Image_List] = [Video_Image_List]()
    
    var buyer_show_total: Int = 0
    
    var faved_count: Int = 0
    
    var is_faved: Int = 0
    
    var product_name: String = ""
    
    var spike_delivery_price: Int = 0
    
    var location_latitude: String = ""
    
    var spike_type_id: Int = 0
    
    var iwant_id: String = ""
    
    var forward_count: Int = 0
    
    var not_available_topic: [String] = [String]()
    
    var product_header_image_32: String = ""
    
    var classification: Classification = Classification()
    
    var is_locking: Int = 0
    
    var forward_price: Int = 0
    
    var user: User = User()
    
    var is_iwant: Int = 0
    
    var product_delivery_price: String = ""
    
    var code: Int = 0
    
    var is_on_market: Int = 0
    
    var comment_count: Int = 0
    
    var product_views_count: Int = 0
    
    var status: String = ""
    
    var product_description: String = ""
    
    var product_id: String = ""
    
    var product_type: [Product_Type] = [Product_Type]()
    
    var publish_date: String = ""
    
    var location_title: String = ""
    
    var spike_price: Int = 0
    
    var forward_charge: String = ""
    
    var location_longitude: String = ""
    
    var topics: [String] = [String]()
    
    var system_type_id: String = ""
    
    var spike_status: Int = 0
    
    var spike_stock: Int = 0
    
    var show_iwant: Int = 0
    
    var product_video_header_image: String = ""
    
    var min_price: String = ""
    
    var video_play_count: Int = 0
    
    var forward_user_list: [Forward_User_List] = [Forward_User_List]()
    
    var max_forward_price: Int = 0
    
    var shop_coupon: Int = 0
    
    var max_price: String = ""
    
    required init() {}
}
class Classification : HandyJSON{
    
    var classification_id: String = ""
    
    var classification_name: String = ""
    
    required init() {}
}

class Forward_User_List : HandyJSON{
    
    var user_id: String = ""
    
    var avatar: String = ""
    
    required init() {}
    
}

class Product_Type : HandyJSON{
    
    var type_id: String = ""
    
    var type_name: String = ""
    
    var type_price: String = ""
    
    var stock: String = ""
    
    required init() {}
    
}

class Video_Image_List : HandyJSON{
    
    var height: String = ""
    
    var video_stream_url: String = ""
    
    var video_url: String = ""
    
    var image_url: String = ""
    
    var width: String = ""
    
    var video_https_url: String = ""
    
    var type: Int = 0
    
    required init() {}
    
}

//class User : HandyJSON{
//
//var nick_name: String?
//
//var gender: String?
//
//var avatar: String?
//
//var friend_shop_count: Int = 0
//
//var fans_count: Int = 0
//
//var certification: Certification?
//
//var is_faved: Int = 0
//
//var user_id: String?
//
//var seller_level: String?
//
//    required init() {}
//
//}

//class Certification : HandyJSON{
//
//var if_vip: String?
//
//var if_official_vip: Int = 0
//
//var if_celebrity_vip: Int = 0
//
//    required init() {}
//
//}
