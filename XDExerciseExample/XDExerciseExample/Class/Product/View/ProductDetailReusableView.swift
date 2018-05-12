//
//  ProductDetailReusableView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/6.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit

class ProductDetailReusableView: UICollectionReusableView {
    
    fileprivate lazy var titleLabel : UILabel = {
       let titleLabel = UILabel()
        titleLabel.textColor = .red
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()
    
    var buyCommentModel : ProductDetailBuyCommentModel?{
        
        didSet{
            
            guard let buyCommentModel = buyCommentModel else { return }
            titleLabel.text = buyCommentModel.headTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }
}
