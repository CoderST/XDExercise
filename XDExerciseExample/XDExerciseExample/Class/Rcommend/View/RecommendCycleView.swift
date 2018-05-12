//
//  RecommendCycleView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/15.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import SDCycleScrollView
protocol RecommendCycleViewDelegate : class{
    func recommendCycleViewCycleScrollView(_ recommendCycleView: RecommendCycleView, didSelectItemAt index: Int)
}
class RecommendCycleView: UIView {

    weak var delegateCycle : RecommendCycleViewDelegate?
    
    fileprivate lazy var cycleScrollView : SDCycleScrollView = {
        let cycleScrollView = SDCycleScrollView()
        return cycleScrollView
    }()
    
    var imagePathsArray : [String]?{
        
        didSet{
            guard let imagePathsArray = imagePathsArray else { return }
       
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
        delegateCycle?.recommendCycleViewCycleScrollView(self, didSelectItemAt: index)
    }
    
    
}
