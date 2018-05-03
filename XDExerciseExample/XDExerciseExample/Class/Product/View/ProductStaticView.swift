//
//  ProductStaticView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/3.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit

class ProductStaticView: UIView {
    fileprivate lazy var imageView : UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.image = UIImage(named: "product_detail_zbq")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
