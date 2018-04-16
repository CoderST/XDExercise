//
//  RecommendVM.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/14.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import HandyJSON
import SVProgressHUD
class RecommendVM: NSObject {

    var recommendMainModel : RecommendMainModel?
    
    var imagePathsArray : [String] = [String]()
    var videoModelFrameArray : [VideoModelFrame] = [VideoModelFrame]()
    
    fileprivate var current_page : Int = 1
    
}

extension RecommendVM{
    /// 下拉刷新
     func loadRecommendDatas(successCallBack : @escaping ()->(), stateCallBack : @escaping (_ message : String)->(), failedCallBack : @escaping (_ erroe : Error)->()){
        let parameters = [
            "current_page" : "1",
            "item_count" : "\(item_count)"
        ]
        
        NetWork.requestData(.post, URLString: GET_HOME_RECOMMEND_LIST, model: INDEX_URL, parameters: parameters, version: version_285) { (result) in
            debugLog(result)
            guard let resultDict = result as? NSDictionary else { return }
//            guard let resultDIC = resultDict["list"] as? [String : Any] else { return }
            if let recommendMainModel = RecommendMainModel.deserialize(from: resultDict){
                if recommendMainModel.code == 0{
//                    self.recommendMainModel = recommendMainModel
                    self.videoModelFrameArray.removeAll()
                    
                    /// 处理轮播数据
                    if let recommendArray = recommendMainModel.list?.recommend{
                        for (index, recommend) in recommendArray.enumerated(){
                            self.imagePathsArray.append(recommend.recommend_images)

                        }
                    }
                    
                    /// 处理frame数据
                    guard let list = recommendMainModel.list else { return }
                    for video in list.video{
                        let videoF = VideoModelFrame(video)
                        self.videoModelFrameArray.append(videoF)
                    }
//
                    successCallBack()
                }else{
                    SVProgressHUD.showInfo(withStatus: resultDict["message"] as? String ?? "")
                }
            }
            
//            debugLog(recommendModel)
        }
    }
    
    /// 上拉加载更多
     func loadMoreRecommendDatas(){
        let parameters = [
            "current_page" : "\(current_page)",
            "item_count" : "\(item_count)"
        ]
        NetWork.requestData(.post, URLString: GET_HOME_RECOMMEND_LIST, model: INDEX_URL, parameters: parameters, version: version_285) { (result) in
            
        }
    }
}
