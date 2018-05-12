//
//  XDAttentionView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/23.
//  Copyright © 2018年 CoderST. All rights reserved.
//  关注

import UIKit
protocol XDAttentionViewDelegate : class {
    /// 关注点击事件
    func didSelectAttentionView(_ attentionView : XDAttentionView)
}
class XDAttentionView: UIView {
    weak var delegateAttention : XDAttentionViewDelegate?
    var attentionButtonTitle : String?{
        didSet{
            guard let attentionButtonTitle = attentionButtonTitle else { return }
            attentionButton.setTitle(attentionButtonTitle, for: .normal)
        }
    }
    /// 关注
    fileprivate lazy var attentionButton : UIButton = {
    
        let attentionButton = UIButton()
        attentionButton.backgroundColor = .black
        attentionButton.setTitle("关注", for: .normal)
        attentionButton.setTitleColor(.white, for: .normal)
        attentionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return attentionButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(attentionButton)
        attentionButton.addTarget(self, action: #selector(tapAction(_:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attentionButton.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 点击
extension XDAttentionView{

    @objc fileprivate func tapAction(_ button : UIButton){
        delegateAttention?.didSelectAttentionView(self)
    }
}
