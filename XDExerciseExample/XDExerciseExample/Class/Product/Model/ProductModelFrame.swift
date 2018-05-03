//
//  ProductModelFrame.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/2.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
fileprivate let marginTB : CGFloat = 20
fileprivate let marginLR : CGFloat = 15
class ProductModelFrame: NSObject {

    // MARK:- 尺寸
    /// 视频F
    var videoFrame : CGRect = .zero
    /// 金额 包邮(是否)  想要(是否)
    var priceBaoyouViewFrame : CGRect = .zero
    /// 大标题
    var titleLabelFrame : CGRect = .zero
    /// 话题
    var topicViewFrame : CGRect = .zero
    /// 描述
    var subTitleLabelFrame : CGRect = .zero
    /// 浏览
    var browseLabelFrame : CGRect = .zero
    /// 喜欢 分享 缓存 更多按钮整体frame
    var shareLoveMoreViewFrame : CGRect = .zero
    /// 用户信息的View
    var userInforViewFrame : CGRect = .zero
    /// 领取优惠券View
    var couponViewFrame : CGRect = .zero
    /// 静态view 24小时发货 正品保证图片
    var staticViewFrame : CGRect = .zero
    /// headView高度
    var headViewHeight : CGFloat = 0
    
    // MARK:- 数据
    /// 子话题尺寸数组
    lazy var topicModelArray : [RecommendTopicModel] = [RecommendTopicModel]()
    /// 标题
    var productNameAttributedString : NSMutableAttributedString = NSMutableAttributedString(string: "")
    /// 子标题
    var subProductNameAttributedString : NSMutableAttributedString = NSMutableAttributedString(string: "")
    /// 浏览
    var browseName : String = ""
    var productModel : ProductModel
    
    init(_ productModel : ProductModel) {
        self.productModel = productModel
        super.init()
        
        /// 视频F
        videoFrame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW)
        /// 金额 包邮(是否)  想要(是否)
        priceBaoyouViewFrame = CGRect(x: 0, y: videoFrame.maxY + marginTB, width: kScreenW, height: 50)
        /// 大标题
        let titleMaxSize = CGSize(width: kScreenW - 4 * marginLR, height: CGFloat(MAXFLOAT))
        let productName = productModel.product_name
        let productNameYZ = productName.sizeBoundingRect(with: titleMaxSize, font: productDetailHeadTitleFont, lineSpacing: 10)
        productNameAttributedString = productNameYZ.att
        titleLabelFrame = CGRect(x: marginLR, y: priceBaoyouViewFrame.maxY + marginTB, width: productNameYZ.size.width, height: productNameYZ.size.height)
        /// 话题
        setupTopicViewFrame(productModel)
        /// 描述
        let subTitleMaxSize = CGSize(width: kScreenW - 2 * marginLR, height: CGFloat(MAXFLOAT))
        let subProductName = productModel.product_description
        let subTitleYZ = subProductName.sizeBoundingRect(with: subTitleMaxSize, font: productDetailHeadSubTitleFont, lineSpacing: 10)
        subProductNameAttributedString = subTitleYZ.att
        subTitleLabelFrame = CGRect(x: titleLabelFrame.origin.x, y: headViewHeight + marginTB, width: subTitleYZ.size.width, height: subTitleYZ.size.height)
        /// 浏览
        browseName = "浏览\(100)"
        let liuLanSize = browseName.sizeWithFont(productDetailHeadBrowseFont)
        browseLabelFrame = CGRect(x: titleLabelFrame.origin.x, y: subTitleLabelFrame.maxY + marginTB, width: liuLanSize.width, height: liuLanSize.height)
        /// 喜欢 分享 缓存 更多按钮整体frame
        shareLoveMoreViewFrame = CGRect(x: 0, y: browseLabelFrame.maxY + marginTB, width: kScreenW, height: 30)
        /// 用户信息的View
        userInforViewFrame = CGRect(x: 0, y: shareLoveMoreViewFrame.maxY + marginTB, width: kScreenW, height: 70)
        // 领取优惠券View
        setupCouponViewFrame(productModel)
        /// 静态view
        let height = 180 / 750 * kScreenW
        staticViewFrame = CGRect(x: 0, y: headViewHeight, width: kScreenW, height: height)
        
        headViewHeight = staticViewFrame.maxY + 10
        
        
    }
    
}

extension ProductModelFrame {
    fileprivate func setupTopicViewFrame(_ productModel : ProductModel){
        if productModel.topics.count > 0{
            // 计算文本的宽度
            //            top
            //            productModel.topics = ["都在想什么呢1","都在想什么呢2","都在想什么呢3","都在想什么呢4?","都在想什么呢5?","都在想什么呢6?","都在想什么呢7?","都在想什么呢8?","都在想什么呢9?"]
            
            setupTopic(productModel)
            
        }else{
            
            topicViewFrame = CGRect(x: 0, y: titleLabelFrame.maxY, width: 0, height: 0)
            headViewHeight = topicViewFrame.maxY
        }
    }
    
    fileprivate func setupTopic(_ productModel : ProductModel){
        let marginClo : CGFloat = 15 // 列间距
        let marginRow : CGFloat = 15 // 行间距
        let titleLRMargin : CGFloat = 5 // 左右间隙
        let titleTBMargin : CGFloat = 2 // 上下间隙
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        var topicLeft : CGFloat = edgeInsets.left
        let topicRight : CGFloat = edgeInsets.right
        var topicTop : CGFloat = 0
        var rowNumber : Int = 1
        for topic in productModel.topics{
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
        topicViewFrame = CGRect(x: 0, y: titleLabelFrame.maxY + marginTB, width: kScreenW, height: lastTopicMaxY)
        headViewHeight = topicViewFrame.maxY
    }
}

// MARK:- 优惠券
extension ProductModelFrame {
    fileprivate func setupCouponViewFrame(_ productModel : ProductModel){
        let shopCoupon = productModel.user.shop_coupon
        switch shopCoupon {
        case .shop_coupon_none:
            couponViewFrame = CGRect(x: 0, y: userInforViewFrame.maxY, width: 0, height: 0)
            headViewHeight = couponViewFrame.maxY
            debugLog("没有优惠券")
        default:
            couponViewFrame = CGRect(x: 0, y: userInforViewFrame.maxY, width: kScreenW, height: 40)
            headViewHeight = couponViewFrame.maxY
            debugLog("有优惠券")
        }
    }
}
