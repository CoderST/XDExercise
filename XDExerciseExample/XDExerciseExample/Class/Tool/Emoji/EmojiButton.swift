//
//  EmojiButton.swift
//  TestCameraDemo
//
//  Created by xiudou on 2018/5/7.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit

class EmojiButton: UIButton {

    /** 图片名字 */
    var pngName : String?{
        
        didSet{
            DispatchQueue.global().async {
                //耗时操作
                let path = Bundle.main.path(forResource: self.pngName, ofType: "png") ?? ""
                let image = UIImage(contentsOfFile: path)
                DispatchQueue.main.async {
                    //刷新UI
                    if image != nil{
                        self.setImage(image, for: .normal)
                    }
                    self.isUserInteractionEnabled = image == nil ? false : true
                }
            }
        }
    }
    
    /*
     * 按钮的类型
     * 0是表情 1是删除
     */
    var btnType : Int = 0
    
    
}
