//
//  ProductDetailHeadView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/2.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import SDCycleScrollView
class ProductDetailHeadView: UIView {
    
    fileprivate lazy var cycleScrollView : SDCycleScrollView = SDCycleScrollView()
    /// 价格等
    fileprivate lazy var priceBaoyouView : ProductDetailPriceBaoyouView = ProductDetailPriceBaoyouView()
    /// 标题
    fileprivate lazy var productNameLabel : UILabel = {
       let productNameLabel = UILabel()
        productNameLabel.numberOfLines = 0
        productNameLabel.textColor = productDetailHeadTitleColor
        productNameLabel.font = productDetailHeadTitleFont
        return productNameLabel
    }()
    /// 话题
    fileprivate lazy var topicView : TopicView = TopicView()
    /// 子标题描述
    fileprivate lazy var subProductNameLabel : UILabel = {
        let subProductNameLabel = UILabel()
        subProductNameLabel.numberOfLines = 0
        subProductNameLabel.textColor = productDetailHeadSubTitleColor
        subProductNameLabel.font = productDetailHeadSubTitleFont
        return subProductNameLabel
    }()
    /// 浏览
    fileprivate lazy var browseNameLabel : UILabel = {
        let browseNameLabel = UILabel()
        browseNameLabel.font = productDetailHeadBrowseFont
        return browseNameLabel
    }()
    /// 喜欢 分享 缓存 更多按钮整体frame
    fileprivate lazy var shareLoveMoreView : ShareLoveMoreView = ShareLoveMoreView()
    /// 用户信息的View
    fileprivate lazy var  productDetailUserInforView : ProductDetailUserInforView = ProductDetailUserInforView()
    /// 领取优惠券View
    fileprivate lazy var couponView : CouponView = CouponView()
    /// 静态view 24小时发货 正品保证图片
    fileprivate lazy var staticView : ProductStaticView = ProductStaticView()
    /// 灰色地板
    fileprivate lazy var grayBottomView : UIView = {
       let grayBottomView = UIView()
        grayBottomView.backgroundColor = .gray
        return grayBottomView
    }()
    
    fileprivate lazy var imageGroup : [String] = [String]()
    
    var videoFrame : VideoModelFrame?{
        didSet{
            guard let videoFrame = videoFrame else { return }
            
        }
    }
    
    var productModelFrame : ProductModelFrame?{
        didSet{
            guard let productModelFrame = productModelFrame else { return }
            
            setupFrame(productModelFrame)
            
            setupData(productModelFrame)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupCycleScrollView()
        addSubview(priceBaoyouView)
        addSubview(productNameLabel)
        addSubview(topicView)
        addSubview(subProductNameLabel)
        addSubview(browseNameLabel)
        addSubview(shareLoveMoreView)
        addSubview(productDetailUserInforView)
        addSubview(couponView)
        addSubview(staticView)
        addSubview(grayBottomView)

        topicView.delegateTopic = self
        priceBaoyouView.backgroundColor = .red
        productNameLabel.backgroundColor = .yellow
        topicView.backgroundColor = .red
    }
    
    fileprivate func setupCycleScrollView(){
        addSubview(cycleScrollView)
        cycleScrollView.placeholderImage = UIImage(named: "avatar_default")
        cycleScrollView.delegate = self
        cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 私有方法
extension ProductDetailHeadView {
    
    fileprivate func setupData(_ productModelFrame : ProductModelFrame){
        setupCycleScrollViewImageGroup(productModelFrame)
        productNameLabel.attributedText = productModelFrame.productNameAttributedString
        subProductNameLabel.attributedText = productModelFrame.subProductNameAttributedString
        browseNameLabel.text = productModelFrame.browseName
        topicView.collectionViewReloadData()
    }
    
    fileprivate func setupFrame(_ productModelFrame : ProductModelFrame){
        cycleScrollView.frame = productModelFrame.videoFrame
        priceBaoyouView.frame = productModelFrame.priceBaoyouViewFrame
        productNameLabel.frame = productModelFrame.titleLabelFrame
        topicView.frame = productModelFrame.topicViewFrame
        subProductNameLabel.frame = productModelFrame.subTitleLabelFrame
        browseNameLabel.frame = productModelFrame.browseLabelFrame
        productDetailUserInforView.frame = productModelFrame.userInforViewFrame
        couponView.frame = productModelFrame.couponViewFrame
        shareLoveMoreView.frame = productModelFrame.shareLoveMoreViewFrame
        staticView.frame = productModelFrame.staticViewFrame
        grayBottomView.frame = productModelFrame.grayBottomViewFrame
    }
    
    fileprivate func setupCycleScrollViewImageGroup(_ productModelFrame : ProductModelFrame){
        let productModel = productModelFrame.productModel
        let videoImageList = productModel.video_image_list
        imageGroup.removeAll()
        for videoImage in videoImageList{
            let imageS = videoImage.image_url
            imageGroup.append(imageS)
            
        }
        cycleScrollView.imageURLStringsGroup = imageGroup
    }
}

extension ProductDetailHeadView : SDCycleScrollViewDelegate{
    /// 点击图片
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        
    }
    /// 图片滚动
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        
    }
}

extension ProductDetailHeadView : TopicViewDelegate{
  
    func topicCount(_ topicView: TopicView, numberOfItemsInSection: Int) -> Int {
        guard let productModelFrame = productModelFrame else { return 0 }
        let topicModelArray = productModelFrame.topicModelArray
        let count = topicModelArray.count
        return count
    }
    
    func topicName(_ topicView: TopicView, indexPath: IndexPath) -> String {
        guard let productModelFrame = productModelFrame else { return "" }
        let topicModel = productModelFrame.topicModelArray[indexPath.item]
        
        return topicModel.topicTitle
    }
    
    func topicSize(_ topicView: TopicView, indexPath: IndexPath) -> CGSize {
        guard let productModelFrame = productModelFrame else { return CGSize.zero}
        let topicModel = productModelFrame.topicModelArray[indexPath.item]
        return CGSize(width: topicModel.topicFrame.width, height: topicModel.topicFrame.height)
    }
    
    func topicView(_ topicView: TopicView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
