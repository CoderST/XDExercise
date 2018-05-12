//
//  NSAttributedString+Extension.swift
//  TestCameraDemo
//
//  Created by xiudou on 2018/5/7.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import Foundation
// MARK:- 1图片2图片 -> 1[呲牙]2[调皮]
extension NSAttributedString{
    func getPlainString()->NSString{
        let plainString = NSMutableString(string: string)
        var base : Int = 0
        /// 遍历替换图片得到普通字符
        enumerateAttribute(NSAttributedStringKey.attachment, in: NSMakeRange(0, self.length), options: .init(rawValue: 0)) { (value, range, _) in
            if value != nil{
                guard let attachment = value as? EmojiAttachment else { return }
                let chsName = attachment.chsName
              plainString.replaceCharacters(in: NSMakeRange(range.location + base, range.length), with: chsName)
                base += chsName.count - 1
            }
            
        }
        return plainString
    }
}
