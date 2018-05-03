//
//  BuyShowModel.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/3.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import HandyJSON
class BuyShowModel: HandyJSON {

    var buyer_show_total: Int = 0
    
    var code: Int = 0
    
    var list: [BuyShowList] = [BuyShowList]()
    
    required init() {}
    
}
class BuyShowList: HandyJSON {
    
    var ID: String = ""
    
    var product_name: String = ""
    
    var product_show_id: String = ""
    
    var product_show_head_image: String = ""
    
    var product_price: String = ""
    
    var province: String = ""
    
    var product_image_list: [String] = [String]()
    
    var product_show_comment: String = ""
    
    var product_show_url: String = ""
    
    var product_id: String = ""
    
    var pc_product_show_url: String = ""
    
    var city: String = ""
    
    var product_type: String = ""
    
    var add_time: String = ""
    
    var user: User = User()
    
    required init() {}
    
}
