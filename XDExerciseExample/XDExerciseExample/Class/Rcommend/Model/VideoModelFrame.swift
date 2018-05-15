//
//  VideoModelFrame.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/16.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
//import STRowLayout
/// 用户高度
let userHeight : CGFloat = 60
/// 用户头像大小
let userAvatarWH : CGFloat = 40
/// cell底部bar高度
let bottomBarHeight : CGFloat = 50
/// 价格和奖励哪一行的高度
let priceHeight : CGFloat = 25
/// 关注大小
let attentionSize = CGSize(width: 60, height: 25)
/// 性别大小
let sexSize = CGSize(width: 30, height: 15)
/// 用户标题字体
let userTitleFont : UIFont = UIFont.systemFont(ofSize: 14)
/// 用户子标题字体
let userSubTitleFont : UIFont = UIFont.systemFont(ofSize: 10)
class VideoModelFrame: NSObject {

    // MARK:- 计算属性
    /// 用户标题
    var userTitle : String = ""
    /// 用户子标题
    var userSubTitle : String = ""
    /// 视频头图
    var videoCoverImageUrl : String = ""
    /// 视频播放地址
    var videoUrl : String = ""
    /// 价格
    var priceString : String = ""
    /// 标题
    var title : String = ""
    /// 话题View
    lazy var recommendTopicView : RecommendTopicView = RecommendTopicView()
    var isHiddenTopic : Bool = false
    /// 所有评论
    lazy var commentFrames : [RecommendCommentModelFrame] = [RecommendCommentModelFrame]()
    /// tableViewFrame
    var tableViewFrame : CGRect = .zero
    
    // MARK:- 尺寸标注
    var videoModel : Video
    // MARK: 用户部分 - 尺寸固定
    var userF : CGRect = .zero
    /// 关注
    var attentionF : CGRect = .zero
    /// 头像
    var userAvatarF : CGRect = .zero
    /// 标题
    var userTitleF : CGRect = .zero
    /// 子标题
    var userSubTitleF : CGRect = .zero
    /// 性别
    var userSexF : CGRect = .zero
    // MARK: 视频部分 - 更具后台给尺寸
    var videoF : CGRect = .zero
    // MARK: 价格和奖励哪一行的F + 标题F
    var normalOrProductF : CGRect = .zero
    // MARK: 价格和奖励哪一行的F
    var pricesF : CGRect = .zero  ///
    // MARK: 标题F
    var titleF : CGRect = .zero  ///
    // MARK:- 话题标签
    var topicF : CGRect = .zero
    /// 子话题尺寸数组
    lazy var topicModelArray : [RecommendTopicModel] = [RecommendTopicModel]()
    // MARK:- 评论
    var commentF : CGRect = .zero
    // MARK:- 底部的Bar
    var bottomBarF : CGRect = .zero
    /// cell高度
    var cellHeight : CGFloat = 0
    
    // MARK:- 临时记录属性
    weak var collectionView : UICollectionView?
    var indexPathItem : Int = 0
    
    
     init(_ videoModel : Video) {
        self.videoModel = videoModel
        super.init()
        /// 顶部用户
        userF = CGRect(x: 0, y: 0, width: kScreenW, height: userHeight)
        setupUserSubViewFrame(videoModel)
        cellHeight = userF.maxY
        
        /// 视频
        videoF = setupVideoFrame(videoModel)
        setupProductOrNormalCoverImage(videoModel)
        setupProductOrNormalVideo(videoModel)
        cellHeight = cellHeight + videoF.height
        
        /// 价格和奖励哪一行的F + 标题F
        normalOrProductF = setupNormalOrProductViewFrame(videoModel)
        cellHeight = cellHeight + normalOrProductF.height
        
        /// 话题
        setupTopicFrame(videoModel)
        
        /// 评论
        setupCommentFrame(videoModel)

        // 底部bar
        bottomBarF = CGRect(x: 0, y: cellHeight, width: kScreenW, height: bottomBarHeight)
        cellHeight = bottomBarF.maxY

    
    }
}
// 用户部分 - 尺寸固定子数据尺寸
extension VideoModelFrame{
    fileprivate func setupUserSubViewFrame(_ videoModel : Video){
    userAvatarF = CGRect(x: recommentMargin, y: 10, width: userAvatarWH, height: userAvatarWH)
        let user = videoModel.user
        // 关注
        let attX = kScreenW - attentionSize.width - recommentMargin
        let attY = (userHeight - attentionSize.height) * 0.5
        attentionF = CGRect(x: attX, y: attY, width: attentionSize.width, height: attentionSize.height)
        
        /*
         标题
         屏幕宽 - 头像最大宽 - 间隙 - 关注宽 - 间隙 - 间隙 - 性别宽(性别左右间隙通过宽度来调)
         */
        let maxWidth = kScreenW - userAvatarF.maxX - recommentMargin - attentionF.width - recommentMargin - recommentMargin
        let titleMaxSize = CGSize(width: maxWidth, height: userTitleFont.lineHeight)
        userTitle = user.nick_name 
        debugLog(userTitle)
//        userTitle = "阿福卡金风科技啊上课了房价"
        let nickNameSize = userTitle.sizeWithFont(userTitleFont, maxSize: titleMaxSize)
        userTitleF = CGRect(x: userAvatarF.maxX + recommentMargin, y: userAvatarF.origin.y, width: nickNameSize.width, height: nickNameSize.height)
        // 性别
        let sexY = (titleF.height - sexSize.height) * 0.5
        userSexF = CGRect(x: titleF.maxX + 5, y: sexY, width: sexSize.width, height: sexSize.height)
        // 子标题
        let subMaxWidth = kScreenW - userAvatarF.maxX - recommentMargin - attentionF.width - recommentMargin - recommentMargin
        let subTitleMaxSize = CGSize(width: subMaxWidth, height: userSubTitleFont.lineHeight)
        userSubTitle = user.signature
        let subNickNameSize = userSubTitle.sizeWithFont(userSubTitleFont, maxSize: subTitleMaxSize)
        userSubTitleF = CGRect(x: userTitleF.origin.x, y: userAvatarF.maxY - subNickNameSize.height, width: subNickNameSize.width, height: subNickNameSize.height)
    }
}

// MARK:- 计算视频的尺寸
extension VideoModelFrame{
    fileprivate func setupVideoFrame(_ videoModel : Video)->CGRect{
        let videoWidth = kScreenW
        var videoHeight : CGFloat = 0
        let height = Double(videoModel.video_height) ?? 0
        let width = Double(videoModel.video_width) ?? 1
        let zhi = fabs(height / width) - (9.0 / 16.0)
        if(zhi) < 0.01{
            videoHeight = videoWidth * 9 / 16.0
        }else{
            videoHeight = videoWidth
        }
        
        let videoF = CGRect(x: 0, y: userHeight, width: videoWidth, height: videoHeight)
        return videoF
    }
    
    fileprivate func setupProductOrNormalCoverImage(_ videoModel : Video){
        // 取出类型  商品 或者 日常
        let type = videoModel.type
        let mediaType = videoModel.media_type
        switch type {
        case .product:
            // 取出 是否有视频
//            if mediaType == .video{
//                videoCoverImageUrl = videoModel.video_header_image
//            }else{
                videoCoverImageUrl = videoModel.product_header_image
//            }

        default:
//            if mediaType == .video{
//                videoCoverImageUrl = videoModel.video_header_image
//            }else{
                videoCoverImageUrl = videoModel.normal_header_image
//            }
        }
    }

    //
    fileprivate func setupProductOrNormalVideo(_ videoModel : Video){
        let mediaType = videoModel.media_type
        switch mediaType {
        case .video:
            debugLog("1")
//            let videoStr = videoModel.video_url_stream
            videoUrl = videoModel.video_url_stream
            debugLog("videoUrl == \(videoModel.video_url_stream)")
            
            
        default:
            videoUrl = ""
            debugLog("2")
        }
    }
    
    // 日常或者商品是否带金额
    fileprivate func setupNormalOrProductViewFrame(_ videoModel : Video)->CGRect{
        let type = videoModel.type
        switch type {
        case .product:
            priceString = "$\(videoModel.price)"
            // 1 价格分佣尺寸
            pricesF = CGRect(x: recommentMargin, y: recommentMargin, width: kScreenW, height: priceHeight)
            // 2 文本尺寸
//            debugLog("product")
            titleF = setupTitleF(videoModel)
            
            // 价格高度 + 文本高度 + 间隙
            let normalOrProductF = CGRect(x: 0, y: cellHeight, width: kScreenW, height: titleF.maxY + recommentMargin)
            return normalOrProductF
        default:
            priceString = ""
            //  文本尺寸
//            debugLog("normal")
            pricesF = .zero
            titleF = setupTitleF(videoModel)
            let normalOrProductF = CGRect(x: 0, y: cellHeight, width: kScreenW, height: titleF.maxY + recommentMargin)
            return normalOrProductF
        }
    }
    
    fileprivate func setupTitleF(_ videoModel : Video)->CGRect{
        let maxSize = CGSize(width: kScreenW - 2 * recommentMargin, height: CGFloat(MAXFLOAT))
        
        
        var titleTop : CGFloat = 0
        if videoModel.type == .product {
            title = videoModel.product_name
            titleTop = pricesF.maxY + 10
        }else{
            title = videoModel.normal_name
            titleTop = 15
        }
        let titleSize = title.sizeWithFont(recommentTitleFont, maxSize: maxSize)
        titleF = CGRect(x: recommentMargin, y: titleTop, width: titleSize.width, height: titleSize.height)
        return titleF
    }
    
    // 话题标签
    fileprivate func setupTopicFrame(_ videoModel : Video){
        
        if videoModel.topics.count > 0{
            // 计算文本的宽度
//            top
//            videoModel.topics = ["都在想什么呢1","都在想什么呢2","都在想什么呢3","都在想什么呢4?","都在想什么呢5?","都在想什么呢6?","都在想什么呢7?","都在想什么呢8?","都在想什么呢9?"]
    
            setupTopic(videoModel)
            
        }else{
            topicF = .zero
            recommendTopicView.topicModelArray = topicModelArray
            isHiddenTopic = true
            recommendTopicView.frame = topicF
        }
    }
}

// MARK:- 计算话题
extension VideoModelFrame{
    fileprivate func setupTopic(_ videoModel : Video){
        let marginClo : CGFloat = 15 // 列间距
        let marginRow : CGFloat = 15 // 行间距
        let titleLRMargin : CGFloat = 5 // 左右间隙
        let titleTBMargin : CGFloat = 2 // 上下间隙
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        var topicLeft : CGFloat = edgeInsets.left
        let topicRight : CGFloat = edgeInsets.right
        var topicTop : CGFloat = 0
        var rowNumber : Int = 1
        for topic in videoModel.topics{
            var topicSize = topic.sizeWithFont(recommentTopicFont)
            topicSize = CGSize(width: topicSize.width + 2 * titleLRMargin, height: topicSize.height + 2 * titleTBMargin)
            //                topicLeft = topicLeft + topicSize.width + marginClo
            // 判断是否大于一行
            if topicLeft + topicSize.width + marginClo + topicRight > kScreenW{
                rowNumber += 1
                topicLeft = edgeInsets.left
                topicTop = topicTop + marginRow
            }
            let topicSubFrame = CGRect(x: topicLeft, y: topicTop, width: topicSize.width, height: topicSize.height)
            topicLeft = topicLeft + topicSize.width + marginClo
            // 创建话题模型
            let topicModel = RecommendTopicModel()
            topicModel.topicTitle = topic
            topicModel.topicFrame = topicSubFrame
            topicModelArray.append(topicModel)
        }
        
        // 取出最后一个元素
        let lastTopicModel = topicModelArray.last!
        let lastTopicMaxY = lastTopicModel.topicFrame.maxY
        topicF = CGRect(x: 0, y: cellHeight, width: kScreenW, height: lastTopicMaxY)
        
        // 整体话题View尺寸
        recommendTopicView.frame = topicF
        recommendTopicView.topicModelArray = topicModelArray
        cellHeight = cellHeight + lastTopicMaxY
        isHiddenTopic = false
    }
}

// MARK:- 评论
extension VideoModelFrame{
    fileprivate func setupCommentFrame(_ videoModel : Video){
        var tableViewH : CGFloat = 0
        let maxW : CGFloat = kScreenW - 2 * recommentMargin
        let textLimitSize = CGSize(width: maxW, height: CGFloat(MAXFLOAT))
        let hot_list = videoModel.hot_list
        if hot_list.count > 0 {
            for hotDict in hot_list{
                // 创建评论Frame
                let commentFrame = RecommendCommentModelFrame()
                commentFrame.comment = hotDict
                commentFrames.append(commentFrame)
                tableViewH = tableViewH + commentFrame.cellHeight
                
            }
            tableViewFrame = CGRect(x: recommentMargin, y: cellHeight, width: textLimitSize.width, height: tableViewH)
            // 自身高度
            cellHeight = tableViewFrame.maxY
        }else{
            commentF = .zero
        }
    }
}
