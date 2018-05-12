//
//  EmojiToolModel.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/6.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import YYImage
import YYText
fileprivate let checkStr = "\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
class EmojiToolModel: NSObject {
    // MARK:- 内部变量
    fileprivate static let emojiPath = Bundle.main.path(forResource: "XD_Emoji", ofType: "plist")
    fileprivate static var scale : CGFloat = UIScreen.main.scale
    fileprivate static var emotionSize : CGSize = .zero
    fileprivate static var lineSpacing : CGFloat = 4.0
    fileprivate static var font : UIFont = UIFont.systemFont(ofSize: 12)
    fileprivate static var textColor : UIColor = .black
    fileprivate static var matches : [NSTextCheckingResult] = [NSTextCheckingResult]()
    fileprivate static var plainStr : String = ""
    fileprivate static var emojiImages : NSDictionary = NSDictionary()
    fileprivate static var imageDataArray : [[String : Any]] = [[String : Any]]()
    fileprivate static var attStr : NSMutableAttributedString = NSMutableAttributedString(string: "")
    fileprivate static var resultStr : NSMutableAttributedString = NSMutableAttributedString(string: "")
    
    // MARK:- 对外接口
    /*
     * 转码方法，把普通字符串转为富文本字符串（包含图片文字等）
     * 例 : [哈哈]今天[嘻嘻] -> 😆今天☺️
     * 参数 font 是用来展示的字体大小
     * 参数 plainStr 是普通的字符串
     * 参数 scale 默认不需要传递(UI切图对应文本行高准确)  不准确需要手动改值
     * 返回值：用来展示的富文本，直接复制给label展示
     */
    class func emojiDecode(_ plainStr : String, _ font : UIFont, _ scale : CGFloat = UIScreen.main.scale)->NSMutableAttributedString{
        let resultStr = decodeWithPlainStr(plainStr, font, scale)
        return resultStr
    }

    /** 获取属性文本的尺寸 */
    class func emojiAttributedStringGetSize(_ attributedString : NSMutableAttributedString, _ maxWidth : CGFloat)->CGSize{
        let size = emojiCalculateAttributedStringGetHeight(attributedString,maxWidth)
        return size
    }
    
    /*
     * 带用户回复的属性字符串包含图片文字等）
     * 例 : 小明 回复 小王: 😆今天☺️
     * 参数 fromUserName
     * 参数 toUserName
     * 参数 content 评论的内容
     * 参数 scale 图片系数  默认UIScreen.main.scale 1->max 越大图片越小
     * 返回值：用来展示的富文本
     */
    class func emojiFromUserNameToUserName(_ fromUserName : String, _ toUserName : String = "", _ content : String, _ scale : CGFloat = UIScreen.main.scale)->NSAttributedString{
        let attributedString = fromUserNameToUserName(fromUserName, toUserName, content, scale)
        return attributedString
    }

    /** 点击表情时，插入图片到输入框 */
    class func insertEmojiToTextView(_ emojiBtn : EmojiButton, _ textView : UITextView){
        insertEmoji(emojiBtn, textView)
    }
    
    /** 点击发送后从textView富文本 -> NSString */
    class func getTextViewAttributedText(_ textView : UITextView)->NSString{
        let text = textView.attributedText.getPlainString()
        return text
    }
}

// MARK:- 私有函数
extension EmojiToolModel {
    
    class fileprivate func fromUserNameToUserName(_ fromUserName : String, _ toUserName : String = "", _ content : String, _ scale : CGFloat = UIScreen.main.scale)->NSAttributedString{
        if toUserName.count > 0{
            // 有回复
            let text = "\(fromUserName)回复\(toUserName): \(content)"
            let textString = text as NSString
            //                var textString = text as NSString
            //            let mutableAttributedString = NSMutableAttributedString(string: textString as String)
            let mutableAttributedString = EmojiToolModel.emojiDecode(text, recommentCommentFont,scale)
            mutableAttributedString.yy_font = recommentCommentFont
            mutableAttributedString.yy_color = recommentCommentColor
            mutableAttributedString.yy_lineSpacing = 10
            let fromUserRange = NSMakeRange(0, fromUserName.count)
            let bacColor = UIColor(white: 0, alpha: 0.220)
            let fromUserHighlight = YYTextHighlight(backgroundColor: bacColor)
            //            fromUserHighlight.userInfo = [XDCommentUserKey : fromUser]
            
            mutableAttributedString.yy_setTextHighlight(fromUserHighlight, range: fromUserRange)
            // 设置昵称颜色
            mutableAttributedString.yy_setColor(XDGlobalOrangeTextColor, range: fromUserRange)
            
            let toUserRange = textString.range(of: "\(toUserName)")
            // 文本高亮模型
            let toUserHighlight = YYTextHighlight(backgroundColor: bacColor)
            //            toUserHighlight.userInfo = [XDCommentUserKey : toUser]
            mutableAttributedString.yy_setTextHighlight(toUserHighlight, range: toUserRange)
            // 设置昵称颜色
            mutableAttributedString.yy_setColor(XDGlobalOrangeTextColor, range: toUserRange)
            return mutableAttributedString
        }else{
            // 没有回复
            // 1 拼接字符
            let text = "\(fromUserName): \(content)"
            
            //            let textString = text as NSString
            // 2 创建属性字符串
            //                let mutableAttributedString = NSMutableAttributedString(string: textString as String)
            let mutableAttributedString = EmojiToolModel.emojiDecode(text, recommentCommentFont,scale)
            mutableAttributedString.yy_font = recommentCommentFont
            mutableAttributedString.yy_color = recommentCommentColor
            mutableAttributedString.yy_lineSpacing = 10
            //3 获取fromuser的尺寸
            let fromUserRange = NSMakeRange(0, fromUserName.count)
            let bacColor = UIColor(white: 0, alpha: 0.220)
            let fromUserHighlight = YYTextHighlight(backgroundColor: bacColor)
            /// 存储user对象 可以点击跳转
            //            fromUserHighlight.userInfo = [XDCommentUserKey : fromUser]
            mutableAttributedString.yy_setTextHighlight(fromUserHighlight, range: fromUserRange)
            // 设置昵称颜色
            mutableAttributedString.yy_setColor(XDGlobalOrangeTextColor, range: fromUserRange)
            return mutableAttributedString
        }
        
    }
    
    /*
     * 转码方法，把普通字符串转为富文本字符串（包含图片文字等）
     * 参数 font 是用来展示的字体大小
     * 参数 plainStr 是普通的字符串
     * 返回值：用来展示的富文本，直接复制给label展示
     */
    class fileprivate func decodeWithPlainStr(_ plainStr : String, _ font : UIFont, _ scale : CGFloat = UIScreen.main.scale)->NSMutableAttributedString {
        self.font = font
        self.plainStr = plainStr
        self.textColor = .black
        self.scale = scale
        
        initProperty()
        executeMatch()
        setImageDataArray()
        setResultStrUseReplace()
        return resultStr
    }
    
    class fileprivate func emojiCalculateAttributedStringGetHeight(_ attributedString : NSMutableAttributedString, _ maxWidth : CGFloat)->CGSize{
        let textLimitSize = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
        guard let textSize = YYTextLayout(containerSize: textLimitSize, text: attributedString)?.textBoundingSize else {
            return CGSize(width: 0, height: 0)
            
        }
        
        return textSize
    }
}

extension EmojiToolModel {
    class fileprivate func initProperty(){
        guard let emojiPath = emojiPath else {
            print("emojiPath没有")
            return
        }
        guard let dictpath = NSDictionary(contentsOfFile: emojiPath) else {
            print("解析失败")
            return
        }
        emojiImages = dictpath
        
        // 文本间隔
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        var dict : [NSAttributedStringKey : Any] = [NSAttributedStringKey : Any]()
        dict = [NSAttributedStringKey.font : font,
                   NSAttributedStringKey.paragraphStyle : paragraphStyle
            ]
        
        emotionSize = "/".sizeWithFont(font, dict)
        
        attStr = NSMutableAttributedString(string: plainStr, attributes: dict)
        
    }
}
// MARK: 比对结果
extension EmojiToolModel {
    class fileprivate func executeMatch(){
        let regexString = checkStr
        let regex = try! NSRegularExpression(pattern: regexString, options: .caseInsensitive)
        let totalRange = NSMakeRange(0, plainStr.count)
        matches = regex.matches(in: plainStr, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: totalRange)
    }
}

extension EmojiToolModel {
    
    class fileprivate func setImageDataArray(){
        var imageDataArray : [[String : Any]] = [[String : Any]]()
    
        let matchesCount = matches.count - 1
        // 反向遍历
        for i in (0...matchesCount).reversed() {

            var record = [String : Any]()
            let attachMent = EmojiAttachment()
            attachMent.bounds = CGRect(x: 0, y: -4, width: emotionSize.height, height: emotionSize.height)
            let match = matches[i]
            
            let matchRange = match.range
            let str = plainStr as NSString
            let tagString = str.substring(with: matchRange)
            
            guard let imageName = emojiImages[tagString] as? String else{
                print("没有取到图片")
                continue
            }
            if imageName.count == 0 {
                continue
            }
            
            let value = NSValue.init(range: matchRange)
            record["range"] = value
            record["imageName"] = imageName
            imageDataArray.append(record)
            
        }
        self.imageDataArray = imageDataArray
    
    }
}

extension EmojiToolModel {
    
    class fileprivate func setResultStrUseReplace(){
        let result = attStr
        for i in 0..<imageDataArray.count{
            guard let rangeValue = imageDataArray[i]["range"] as? NSValue else{
                
                continue
            }
            let range = rangeValue.rangeValue
            
            guard let imageName = imageDataArray[i]["imageName"] as? String else{
                continue
            }
            //            guard let imagePath = Bundle.main.path(forResource: imageName, ofType: "gif") else {
            //                print("没有找到gif")
            //                continue
            //            }
            
            var imagePath : String = ""
            if let gifpath = Bundle.main.path(forResource: imageName, ofType: "gif"){
                imagePath = gifpath
            }else if let pngpath = Bundle.main.path(forResource: imageName, ofType: "png"){
                
                imagePath = pngpath
            }else if let path = Bundle.main.path(forResource: imageName, ofType: nil){
                imagePath = path
                
            }else{
                print("没有找到图片")
                continue
            }
            
            guard let data = NSData(contentsOfFile: imagePath) else { continue }
            // 此处sc图片的大小最好让UI切好,对应的显示大小,不然需要手动调整这个比例来适合的大小
            let image = YYImage(data: data as Data, scale: scale)
            image?.preloadAllAnimatedImageFrames = true
            let imageView = YYAnimatedImageView(image: image)
            
            let attachText = NSMutableAttributedString.yy_attachmentString(withContent: imageView, contentMode: .center, attachmentSize: imageView.frame.size, alignTo: font, alignment: .center)
            result.replaceCharacters(in: range, with: attachText)
        }
        resultStr = result
    }
}

// MARK: 点击表情时，插入图片到输入框
extension EmojiToolModel {
    class fileprivate func insertEmoji(_ emojiBtn : EmojiButton, _ textView : UITextView){
        guard let emojiPath = EmojiToolModel.emojiPath else {
            print("emojiPath没有")
            return
        }
        guard let dictpath = NSDictionary(contentsOfFile: emojiPath) else {
            print("解析失败")
            return
        }
        let emojiAttachment = EmojiAttachment()
        // 更具图片名称找到中文名称
        let chsName = getKeyForValue(emojiBtn.pngName ?? "", dictpath)
    
        emojiAttachment.chsName = chsName
        
        if let imageName = emojiBtn.pngName{
            emojiAttachment.image = UIImage(named: imageName)
        }else{
            print("EmojiButton上没有图片名称")
        }
        // 文本间隔
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        var dict : [NSAttributedStringKey : Any] = [NSAttributedStringKey : Any]()
        dict = [NSAttributedStringKey.font : font,
                NSAttributedStringKey.paragraphStyle : paragraphStyle
        ]
        let emotionSize = "/".sizeWithFont(font, dict)
        emojiAttachment.bounds = CGRect(x: 0, y: -4, width: emotionSize.height, height: emotionSize.height)
        let attributedString = NSAttributedString(attachment: emojiAttachment)
        textView.textStorage.insert(attributedString, at: textView.selectedRange.location)
        textView.selectedRange = NSMakeRange(textView.selectedRange.location + 1, textView.selectedRange.length)
        //重设输入框字体
        resetTextStyle(textView)
    }
    
    /// 获取对应的图片中文名称 与服务器传递用
    class fileprivate func getKeyForValue(_ pngName : String, _ dict : NSDictionary)->String{
        var chsName : String = ""
        for (key , obj) in dict{
            guard let objString = obj as? String else { continue }
            guard let keyString = key as? String else { continue }
            if objString == pngName{
                chsName = keyString
            }
        }
        return chsName
    }
    
    class fileprivate func resetTextStyle(_ textView : UITextView){
        let wholeRange = NSMakeRange(0, textView.textStorage.length)
        textView.textStorage.removeAttribute(NSAttributedStringKey.font, range: wholeRange)
        textView.textStorage.addAttribute(NSAttributedStringKey.font, value: font, range: wholeRange)
        let rect = CGRect(x: 0, y: 0, width: textView.contentSize.width, height: textView.contentSize.height)
        textView.scrollRectToVisible(rect, animated: false)
        
    }
}
