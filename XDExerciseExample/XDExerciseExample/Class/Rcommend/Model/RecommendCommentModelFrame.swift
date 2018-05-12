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
        let textComment = "[cool]哈哈你个[kuxiaobude]傻逼"
            if toUser.nick_name.count > 0{
                // 有回复
                 let mutableAttributedString = EmojiToolModel.emojiFromUserNameToUserName(fromUser.nick_name, toUser.nick_name, textComment, 6)
               attributedString = mutableAttributedString
                return mutableAttributedString
            }else{
                 // 没有回复
                // 1 拼接字符
               let mutableAttributedString = EmojiToolModel.emojiFromUserNameToUserName(fromUser.nick_name, "", textComment, 6)
                attributedString = mutableAttributedString
                return mutableAttributedString
            }
    }
}
