//
//  XDUserImageView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/23.
//  Copyright © 2018年 CoderST. All rights reserved.
//  用户头像

import UIKit
protocol XDUserImageViewDelegate : class {
    /// 用户头像点击事件
    func didSelectUserImageView(_ userImageView : XDUserImageView)
}
fileprivate let scale : CGFloat = 0.8
class XDUserImageView: UIView {
    /// 代理
    weak var delegateUserImageView : XDUserImageViewDelegate?
    /// 头像
    fileprivate lazy var userAvatarView : UIImageView = UIImageView()
    /// 等级
    fileprivate lazy var verifiedView : UIImageView = UIImageView()
    
    var user : User?{
        didSet{
            guard let user = user else { return }
            // 添加头像
            setupUserAvatar(user)
            // 添加等级
            setupUserVerified(user)
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userAvatarView)
        addSubview(verifiedView)
        userAvatarView.isUserInteractionEnabled = true
        verifiedView.isUserInteractionEnabled = true
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userAvatarView.frame = bounds
        verifiedView.frame.size = verifiedView.image?.size ?? CGSize.zero
        verifiedView.frame.origin.x = frame.width - verifiedView.frame.size.width * scale
        verifiedView.frame.origin.y = frame.height - verifiedView.frame.size.height * scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI
extension XDUserImageView{
    fileprivate func setupUserAvatar(_ user : User){
        let avatarString = user.avatar
        guard let url = URL(string: avatarString) else { return }
        userAvatarView.kf.setImage(with: url, placeholder: UIImage(named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    fileprivate func setupUserVerified(_ user : User){
        guard let certification =  user.certification else { return }
        var verifiedName : String = ""
        verifiedView.isHidden = false
        if certification.if_vip == .vip_ok{
            verifiedName = "geren"
        }else if certification.if_official_vip == .official_ok{
            verifiedName = "daren"
        }else if certification.if_celebrity_vip == .celebrity_ok{
            verifiedName = "guanfang"
        }else{
            verifiedView.isHidden = true
        }
        verifiedView.image = UIImage(named: verifiedName)
    }
}

// MARK:- 点击
extension XDUserImageView{
    @objc fileprivate func tapAction(_ tap : UITapGestureRecognizer){
        print("---")
        delegateUserImageView?.didSelectUserImageView(self)
    }
}
