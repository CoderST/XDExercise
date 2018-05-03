//
//  XDCustomVew.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/2.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
protocol XDCustomVewDelegate : class {
    func didCustomVew(_ customVew : XDCustomVew)
}
fileprivate let titleLabelFont = UIFont.systemFont(ofSize: 10)
class XDCustomVew: UIView {

    var delegate : XDCustomVewDelegate?
    
    fileprivate lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    fileprivate lazy var titleLabel : UILabel = {
       let titleLabel = UILabel()
        titleLabel.font = titleLabelFont
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    init(frame: CGRect,_ imageName : String) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        imageView.image = UIImage(named: imageName)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(XDCustomVew.tapAction))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 获取图片尺寸大小
        let imageSize = imageView.image?.size ?? CGSize.zero
        // 获取文本尺寸大小
        let titleSize = titleLabel.text?.sizeWithFont(titleLabelFont) ?? CGSize.zero
        imageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        titleLabel.frame = CGRect(x: imageView.frame.maxX + 10, y: 0, width: titleSize.width, height: imageView.frame.height)
        
        frame.size = CGSize(width: titleLabel.frame.maxX, height: imageView.frame.height)
    }

}

extension XDCustomVew {
    func setTitle(_ favedCount : Int){
        titleLabel.text = "\(favedCount)"
    }
}

extension XDCustomVew {
    @objc func tapAction(){
        delegate?.didCustomVew(self)
    }
}
