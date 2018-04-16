//
//  VideoModelFrame.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/16.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
/// 用户高度
let userHeight : CGFloat = 60
/// cell底部bar高度
let bottomBarHeight : CGFloat = 50
/// 价格和奖励哪一行的高度
let priceHeight : CGFloat = 25
class VideoModelFrame: NSObject {

    /// 用户部分 - 尺寸固定
    var userF : CGRect = .zero
    /// 视频部分 - 更具后台给尺寸
    var videoF : CGRect = .zero
    /// 价格和奖励哪一行的F + 标题F
    var normalOrProductF : CGRect = .zero
    var pricesF : CGRect = .zero  /// 价格和奖励哪一行的F
    var titleF : CGRect = .zero  /// 标题F
    /// 话题标签
    var topicF : CGRect = .zero
    /// 底部的Bar
    var bottomBarF : CGRect = .zero
    /// cell高度
    var cellHeight : CGFloat = 0
     init(_ videoModel : Video) {
        super.init()
        userF = CGRect(x: 0, y: 0, width: kScreenW, height: userHeight)
        cellHeight = userF.maxY
        
        videoF = setupVideoFrame(videoModel)
        cellHeight = cellHeight + videoF.height
        
        normalOrProductF = setupNormalOrProductViewFrame(videoModel)
        cellHeight = cellHeight + normalOrProductF.height
        
//        bottomBarF = CGRect(x: 0, y: cellHeight, width: kScreenW, height: bottomBarHeight)
//        cellHeight = cellHeight + bottomBarF.height

    
    }
}

extension VideoModelFrame{
    // 计算视频的尺寸
    fileprivate func setupVideoFrame(_ videoModel : Video)->CGRect{
        let videoWidth = kScreenW
        var videoHeight : CGFloat = 0
        if(fabs(videoModel.video_height / videoModel.video_width) - 9.0 / 16.0) < 0.01{
            videoHeight = videoWidth * 9 / 16.0
        }else{
            videoHeight = videoWidth
        }
        
        let videoF = CGRect(x: 0, y: userHeight, width: videoWidth, height: videoHeight)
        return videoF
    }

    // 日常或者商品是否带金额
    fileprivate func setupNormalOrProductViewFrame(_ videoModel : Video)->CGRect{
        let type = videoModel.type
        switch type {
        case .product:
            // 1 价格分佣尺寸
            pricesF = CGRect(x: 0, y: recommentMargin, width: kScreenW, height: priceHeight)
            cellHeight = cellHeight + priceHeight
            // 2 文本尺寸
            debugLog("product")
            titleF = setupTitleF(videoModel)
            let normalOrProductF = CGRect(x: 0, y: cellHeight, width: kScreenW, height: priceHeight + titleF.height)
            return normalOrProductF
        default:
            //  文本尺寸
            debugLog("normal")
            titleF = setupTitleF(videoModel)
            let normalOrProductF = CGRect(x: 0, y: cellHeight, width: kScreenW, height: titleF.height)
            return normalOrProductF
        }
    }
    
    fileprivate func setupTitleF(_ videoModel : Video)->CGRect{
        let maxSize = CGSize(width: kScreenW - 2 * recommentMargin, height: CGFloat(MAXFLOAT))
        let titleSize = videoModel.product_name.sizeWithFont(recommentTitleFont, size: maxSize)
        var titleTop : CGFloat = 0
        if videoModel.type == .product {
            titleTop = pricesF.maxY + 10
        }else{
            titleTop = 15
        }
        titleF = CGRect(x: recommentMargin, y: titleTop, width: titleSize.width, height: titleSize.height)
        return titleF
    }
    
    // 话题标签
    fileprivate func setupTopicFrame(_ videoModel : Video){
        
    }
}
