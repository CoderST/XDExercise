//
//  ProductDetailVM.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/29.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit

class ProductDetailVM: NSObject {
    var productModelFrame : ProductModelFrame?
    var buyShowModel : BuyShowModel?
    var commentModel : CommentModel?
    
    var buyCommentModelGroup : [ProductDetailBuyCommentModel] = [ProductDetailBuyCommentModel]()
//    var section : Int = 0
}

extension ProductDetailVM{
    /// 商品详情头部信息
    func loadProductDetailDatas(_ product_id : String, _ authToken : String = "", _ isSpikeProduct : String, successCallBack : @escaping ()->(), stateCallBack : @escaping (_ message : String)->(), failedCallBack : @escaping ()->()){
        let parameters : [String : Any] = [
            "product_id" : product_id,
            "auth_token" : authToken,
            "spike" : isSpikeProduct
        ]
        NetWork.requestData(.post, URLString: PRODUCT_DETAIL, model: PRODUCT_URL, parameters: parameters, version: "2.8.0") { (result) in
            guard let resultDict = result as? NSDictionary else {
                //                failedCallBack("后台数据错误")
                failedCallBack()
                return
            }
            //            debugLog(resultDict)
            if let productModel = ProductModel.deserialize(from: resultDict){
                if productModel.code == 0{
                    let productModelFrame = ProductModelFrame(productModel)
                    self.productModelFrame = productModelFrame
                    successCallBack()
                }else{
                    debugLog(productModel.code)
                }
                
                
            }
        }
    }
}

extension ProductDetailVM {
    /// 加载买家秀和评论(第一页)
    func loadProductDetailCellDatas(_ product_id : String,  successCallBack : @escaping ()->(), stateCallBack : @escaping (_ message : String)->(), failedCallBack : @escaping ()->()){
        self.buyCommentModelGroup.removeAll()
        let group = DispatchGroup()
        let parameters : [String : Any] = [
            "product_id" : product_id,
            "page" : 1
        ]
        group.enter()
        NetWork.requestData(.post, URLString: BUYERS_SHOW_LIST, model: INDEX_URL, parameters: parameters, version: "2.5.9") { (result) in
            guard let resultDict = result as? NSDictionary else {
                //                failedCallBack("后台数据错误")
                //                failedCallBack()
                return
            }
            if let buyShowModel = BuyShowModel.deserialize(from: resultDict){
                if buyShowModel.code == 0{
                    self.buyShowModel = buyShowModel
                    //                    let productModelFrame = ProductModelFrame(productModel)
                    //                    self.productModelFrame = productModelFrame
                    //                    successCallBack()
                }else if(buyShowModel.code == 2){
                    let message = resultDict["message"] as? String ?? ""
                    //                    stateCallBack(message)
                }
                
            }
            group.leave()
        }
        
        
        /// 加载评论
        let parametersComment : [String : Any] = ["id" : product_id,
                                                  "current_page" : 1,
                                                  "item_count":10,
                                                  "type":1
            
        ]
        group.enter()
        NetWork.requestData(.post, URLString: GET_HOT_COMMENT_LIST, model: COMMENT_URL, parameters: parametersComment, version: "2.7.32"){(result) in
            guard let resultDict = result as? NSDictionary else {
                //                failedCallBack("后台数据错误")
                //                failedCallBack()
                return
            }
            if let commentModel = CommentModel.deserialize(from: resultDict){
            if commentModel.code == 0{
                self.commentModel = commentModel
                //                    let productModelFrame = ProductModelFrame(productModel)
                //                    self.productModelFrame = productModelFrame
                //                    successCallBack()
            }
            }
            group.leave()
        }
        
        // 对数据进行排序
        group.notify(queue: DispatchQueue.main) { () -> Void in
            //            self.anchorGroups.insert(self.prettyGroup, at: 0)
            //            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            //            finishCallBack()
            if self.buyShowModel != nil && self.buyShowModel!.list.count > 0{
                let productDetailSCModel = ProductDetailBuyCommentModel()
                productDetailSCModel.modelList = self.buyShowModel!.list
                productDetailSCModel.headTitle = "买家秀\(self.buyShowModel?.buyer_show_total ?? 0)"
                self.buyCommentModelGroup.append(productDetailSCModel)
            }
            if self.commentModel != nil && self.commentModel!.list.count > 0{
                /// 新鲜
                let refreshCommentModelList = self.commentModel!.list
                if refreshCommentModelList.count > 0{
                    let productDetailSCModel = ProductDetailBuyCommentModel()
                    productDetailSCModel.modelList = refreshCommentModelList
                    productDetailSCModel.headTitle = "新鲜评论\(self.commentModel?.total ?? 0)"
                    self.buyCommentModelGroup.append(productDetailSCModel)
                }
                
                /// 热门
                let hotCommentModelList = self.commentModel!.hot_list
                if hotCommentModelList.count > 0{
                    let productDetailSCModel = ProductDetailBuyCommentModel()
                    productDetailSCModel.modelList = hotCommentModelList
                    productDetailSCModel.headTitle = "热门评论\(self.commentModel?.hot_total ?? 0)"
                    self.buyCommentModelGroup.append(productDetailSCModel)
                }
            }
            successCallBack()
        }
    }
    
}

extension ProductDetailVM {
    // 加载更多评论数据
    func loadProductDetailMoreCommentDatas(_ product_id : String, _ currentPage : Int, successCallBack : @escaping ()->(), stateCallBack : @escaping (_ message : String)->(), failedCallBack : @escaping ()->()){
        
    }
}
