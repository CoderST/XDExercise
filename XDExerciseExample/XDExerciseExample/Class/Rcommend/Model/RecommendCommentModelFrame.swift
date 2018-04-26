//
//  RecommendCommentModelFrame.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/25.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import YYText
class RecommendCommentModelFrame: NSObject {
    
    /// 最大宽度 外界传递
    var maxW : CGFloat = 0
    
    /// 内容尺寸
    var textFrame : CGRect = .zero
    /// cell高度
    var cellHeight : CGFloat = 0
    
    var attributedString : NSAttributedString?
    
    var comment : HotDict?{
        didSet{
            guard let comment = comment else { return }
            let MHCommentVerticalSpace : CGFloat = 7
            let maxW : CGFloat = kScreenW - 2 * recommentMargin
            let textLimitSize = CGSize(width: maxW, height: CGFloat(MAXFLOAT))
            guard let attributedString = setupUserComment(comment) else { return }
            let textH = YYTextLayout(containerSize: textLimitSize, text: attributedString)?.textBoundingSize.height ?? 0
            textFrame = CGRect(x: recommentMargin, y: MHCommentVerticalSpace, width: textLimitSize.width, height: textH)
            cellHeight = textFrame.maxY + MHCommentVerticalSpace
        }
        
    }
}

extension RecommendCommentModelFrame{
    /// 处理 评论回复的内容
    func setupUserComment(_ comment : HotDict)->NSAttributedString?{
        let fromUser = comment.user_info
        let toUser = comment.target_user_info
            if toUser.nick_name.count > 0{
                // 有回复
                let text = "\(fromUser.nick_name)回复\(toUser.nick_name): \(comment.content)"
                let textString = text as NSString
                //                var textString = text as NSString
                let mutableAttributedString = NSMutableAttributedString(string: textString as String)
                mutableAttributedString.yy_font = recommentCommentFont
                mutableAttributedString.yy_color = recommentCommentColor
                mutableAttributedString.yy_lineSpacing = 10
                let fromUserRange = NSMakeRange(0, fromUser.nick_name.count)
                let bacColor = UIColor(white: 0, alpha: 0.220)
                let fromUserHighlight = YYTextHighlight(backgroundColor: bacColor)
                fromUserHighlight.userInfo = [XDCommentUserKey : fromUser]
                
                mutableAttributedString.yy_setTextHighlight(fromUserHighlight, range: fromUserRange)
                // 设置昵称颜色
                mutableAttributedString.yy_setColor(XDGlobalOrangeTextColor, range: fromUserRange)
                
                let toUserRange = textString.range(of: "\(toUser.nick_name)")
                // 文本高亮模型
                let toUserHighlight = YYTextHighlight(backgroundColor: bacColor)
                toUserHighlight.userInfo = [XDCommentUserKey : toUser]
                mutableAttributedString.yy_setTextHighlight(toUserHighlight, range: toUserRange)
                // 设置昵称颜色
                mutableAttributedString.yy_setColor(XDGlobalOrangeTextColor, range: toUserRange)
                attributedString = mutableAttributedString
                return mutableAttributedString
            }else{
                 // 没有回复
                // 1 拼接字符
                let text = "\(fromUser.nick_name): \(comment.content)"
                let textString = text as NSString
                // 2 创建属性字符串
                let mutableAttributedString = NSMutableAttributedString(string: textString as String)
                mutableAttributedString.yy_font = recommentCommentFont
                mutableAttributedString.yy_color = recommentCommentColor
                mutableAttributedString.yy_lineSpacing = 10
                //3 获取fromuser的尺寸
                let fromUserRange = NSMakeRange(0, fromUser.nick_name.count)
                let bacColor = UIColor(white: 0, alpha: 0.220)
                let fromUserHighlight = YYTextHighlight(backgroundColor: bacColor)
                fromUserHighlight.userInfo = [XDCommentUserKey : fromUser]
                mutableAttributedString.yy_setTextHighlight(fromUserHighlight, range: fromUserRange)
                // 设置昵称颜色
                mutableAttributedString.yy_setColor(XDGlobalOrangeTextColor, range: fromUserRange)
                attributedString = mutableAttributedString
                return mutableAttributedString
            }
    }
}
