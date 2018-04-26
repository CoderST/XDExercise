//
//  RecommendTopicView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/24.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit

class RecommendTopicView: UIView {


    var topicModelArray : [RecommendTopicModel]?{
        didSet{
            guard let topicModelArray = topicModelArray else { return }
            if var mysuperViews = superview?.subviews{
                mysuperViews.removeAll()
            }
            for topicModel in topicModelArray{
                let topicLabel = UILabel()
                topicLabel.textAlignment = .center
                topicLabel.layer.borderWidth = 0.5
                topicLabel.layer.borderColor = UIColor.red.cgColor
                topicLabel.font = recommentTopicFont
                topicLabel.text = topicModel.topicTitle
                topicLabel.frame = topicModel.topicFrame
                addSubview(topicLabel)
                
                // 添加手势 处理事件
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
