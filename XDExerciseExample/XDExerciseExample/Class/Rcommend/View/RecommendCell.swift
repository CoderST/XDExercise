//
//  RecommendCell.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/14.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit

class RecommendCell: UICollectionViewCell {
    fileprivate lazy var recommentUserView : RecommentUserView = RecommentUserView()
    
    fileprivate lazy var recommentVideoView : RecommentVideoView = RecommentVideoView()
    
    fileprivate lazy var recommendNormalOrProduct : RecommendNormalOrProduct = RecommendNormalOrProduct()
    
    var videoModelFrame : VideoModelFrame?{
        didSet{
            guard let videoModelFrame = videoModelFrame else { return }
            recommentUserView.frame = videoModelFrame.userF
            recommentVideoView.frame = videoModelFrame.videoF
            recommendNormalOrProduct.frame = videoModelFrame.normalOrProductF
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(recommentUserView)
        contentView.addSubview(recommentVideoView)
        contentView.addSubview(recommendNormalOrProduct)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
