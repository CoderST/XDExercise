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
    /// 用户头像
    fileprivate lazy var userImageView : XDUserImageView = XDUserImageView()
    /// 用户标题
    fileprivate lazy var userTitleLable : UILabel = {
        let userTitleLable = UILabel()
        userTitleLable.font = userTitleFont
        userTitleLable.textColor = .black
        return userTitleLable
    }()
    /// 用户标题
    fileprivate lazy var userSubTitleLable : UILabel = {
        let userSubTitleLable = UILabel()
        userSubTitleLable.font = userSubTitleFont
        userSubTitleLable.textColor = .gray
        return userSubTitleLable
    }()
    /// 关注
    fileprivate lazy var attentionView : XDAttentionView = XDAttentionView()
    
    /// 视频
    fileprivate lazy var recommentVideoView : RecommentVideoView = {
        let recommentVideoView = RecommentVideoView()
        recommentVideoView.tag = 2008
        return recommentVideoView
    } ()
    fileprivate lazy var videoCoverImageView : UIImageView = {
       let videoCoverImageView = UIImageView()
        videoCoverImageView.contentMode = .scaleAspectFill
        videoCoverImageView.clipsToBounds = true
        return videoCoverImageView
    }()
    
    fileprivate lazy var recommendNormalOrProduct : RecommendNormalOrProduct = RecommendNormalOrProduct()
    /// 价格
    fileprivate lazy var priceLabel : UILabel = {
       let priceLabel = UILabel()
        priceLabel.backgroundColor = .yellow
        priceLabel.font = recommentPriceFont
        return priceLabel
    }()
    /// 标题
    fileprivate lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = recommentTitleFont
        return titleLabel
    }()
    
    /// 话题View
    var recommendTopicView : RecommendTopicView?
    
    /// 评论
    fileprivate lazy var commentTableView : RecommendCommentTableView = {
       let recommendCommentTableVie = RecommendCommentTableView()
        recommendCommentTableVie.dataSource = self
        recommendCommentTableVie.delegate = self
        recommendCommentTableVie.isScrollEnabled = false
        recommendCommentTableVie.bounces = false
        recommendCommentTableVie.showsVerticalScrollIndicator = false
        recommendCommentTableVie.showsHorizontalScrollIndicator = false
        recommendCommentTableVie.register(RecommendCommentTableCell.self, forCellReuseIdentifier: RecommendCommentCellIdentifier)
        return recommendCommentTableVie
    }()
    
    /// bar
    fileprivate lazy var recommendCellBottomBarView : RecommendCellBottomBarView = RecommendCellBottomBarView()
    var videoModelFrame : VideoModelFrame?{
        didSet{
            guard let videoModelFrame = videoModelFrame else { return }
            setupFrame(videoModelFrame)
            setupData(videoModelFrame)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(recommentUserView)
        recommentUserView.addSubview(userImageView)
        recommentUserView.addSubview(userTitleLable)
        recommentUserView.addSubview(userSubTitleLable)
        recommentUserView.addSubview(attentionView)
        
        contentView.addSubview(recommentVideoView)
        recommentVideoView.addSubview(videoCoverImageView)
        
        contentView.addSubview(recommendNormalOrProduct)
        recommendNormalOrProduct.addSubview(priceLabel)
        recommendNormalOrProduct.addSubview(titleLabel)
        
        // 话题在赋值加
        
        // 评论
        contentView.addSubview(commentTableView)
        commentTableView.backgroundColor = UIColor.purple
        
        // bar
        contentView.addSubview(recommendCellBottomBarView)

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendCell{
    fileprivate func setupFrame(_ videoModelFrame : VideoModelFrame){
        
        recommentUserView.frame = videoModelFrame.userF
        userImageView.frame = videoModelFrame.userAvatarF
        userTitleLable.frame = videoModelFrame.userTitleF
        userSubTitleLable.frame = videoModelFrame.userSubTitleF
        attentionView.frame = videoModelFrame.attentionF
        
        recommentVideoView.frame = videoModelFrame.videoF
        videoCoverImageView.frame = recommentVideoView.bounds
        
        recommendNormalOrProduct.frame = videoModelFrame.normalOrProductF
        priceLabel.frame = videoModelFrame.pricesF
        titleLabel.frame = videoModelFrame.titleF
        // 话题
        if recommendTopicView != nil && contentView.subviews.contains(recommendTopicView!) == true{
            recommendTopicView!.removeFromSuperview()
        }
        recommendTopicView = videoModelFrame.recommendTopicView
        contentView.addSubview(recommendTopicView!)
        // 评论
        commentTableView.frame = videoModelFrame.tableViewFrame
        commentTableView.reloadData()
        // 底部bar
        recommendCellBottomBarView.frame = videoModelFrame.bottomBarF
    }
    
    fileprivate func setupData(_ videoModelFrame : VideoModelFrame){
        userImageView.user = videoModelFrame.videoModel.user
        userTitleLable.text = videoModelFrame.userTitle
        userSubTitleLable.text = videoModelFrame.userSubTitle
        if let url = URL(string: videoModelFrame.videoCoverImageUrl){
//            videoCoverImageView.kf.setImage(with: url, placeholder: UIImage(named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        let mediaType = videoModelFrame.videoModel.media_type
        switch mediaType {
        case .video:
            debugLog("1")
            recommentVideoView.videoModelFrame = videoModelFrame
        default:
            debugLog("2")
        }
        priceLabel.text = videoModelFrame.priceString
        titleLabel.text = videoModelFrame.title
    }
}

// MARK:- UITableViewDataSource,UITableViewDelegate
extension RecommendCell : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let videoModelFrame = videoModelFrame else { return 0 }
        return videoModelFrame.commentFrames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendCommentCellIdentifier, for: indexPath) as! RecommendCommentTableCell
        let commentFrame = videoModelFrame?.commentFrames[indexPath.row]
        cell.delegateComment = self
        cell.commentFrame = commentFrame
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let commentFrame = videoModelFrame?.commentFrames[indexPath.row]
        let height = commentFrame?.cellHeight ?? 0
        return height
    }
}

// MARK:- 评论点击用户代理
extension RecommendCell : RecommendCommentTableCellDelegate{
    func recommendCommentTableCell(_ recommendCommentTableCell: RecommendCommentTableCell, _ didClickedUser: UserInfor) {
        print(didClickedUser.nick_name)
    }
}
