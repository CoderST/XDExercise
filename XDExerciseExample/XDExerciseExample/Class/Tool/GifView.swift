//
//  GifView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/16.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import Kingfisher
protocol GifViewDelegate : class {
    func didGifView(_ gifView : GifView)
}
class GifView: UIView {
    fileprivate lazy var gifImageView : UIImageView = {
        let gifImageView = UIImageView()
        gifImageView.isUserInteractionEnabled = true
        return gifImageView
    } ()
    weak var delegateGif : GifViewDelegate?
    var imageName : String?{
        didSet{
            guard let imageName = imageName else { return }
            guard let filePath = Bundle.main.path(forResource: imageName, ofType: nil) else {
                debugLog("没有找到图片路径")
                return
                
            }
            let gifurl = URL(fileURLWithPath: filePath)
            gifImageView.kf.setImage(with: gifurl)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(gifImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(GifView.tapAction))
        gifImageView.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gifImageView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GifView{
    
    @objc func tapAction(){
        delegateGif?.didGifView(self)
    }
    
    func removeAll(){
        gifImageView.frame = .zero
        removeAll()
    }
    
    func hidden(){
        isHidden = true
    }
    
    func show(){
        isHidden = false
    }
}
