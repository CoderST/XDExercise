//
//  RecommendCycleView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/15.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import SDCycleScrollView
class RecommendCycleView: UIView {

    fileprivate lazy var cycleScrollView : SDCycleScrollView = {
        let cycleScrollView = SDCycleScrollView()
        return cycleScrollView
    }()
    
    fileprivate lazy var imagePathsArray : [String] = [String]()
    
    var recommendCycleModelArray : [Recommend]?{
        
        didSet{
            guard let recommendCycleModelArray = recommendCycleModelArray else { return }
            for (index, recommend) in recommendCycleModelArray.enumerated(){
                imagePathsArray.append(recommend.recommend_images)
//                if index == 0{
//                    break
//                }
            }
            cycleScrollView.imageURLStringsGroup = imagePathsArray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        addSubview(cycleScrollView)
        cycleScrollView.placeholderImage = UIImage(named: "")
        cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
        cycleScrollView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cycleScrollView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendCycleView : SDCycleScrollViewDelegate{
    /** 点击图片回调 */
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        guard let recommendCycleModelArray = recommendCycleModelArray else { return }
        let recommendModel = recommendCycleModelArray[index]
        debugLog(recommendModel.recommend_images)
    }
}
