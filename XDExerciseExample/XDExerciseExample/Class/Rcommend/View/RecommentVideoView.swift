//
//  RecommentVideoView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/16.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
protocol RecommentVideoViewDelegate : class {
    func didPlayClickButton(_ recommentVideoView : RecommentVideoView , _ indexPath : IndexPath)
}
class RecommentVideoView: UIView {

    weak var delegateVideoView : RecommentVideoViewDelegate?
    
    fileprivate lazy var videoCoverImageView : UIImageView = {
        let videoCoverImageView = UIImageView()
        videoCoverImageView.contentMode = .scaleAspectFill
        videoCoverImageView.clipsToBounds = true
        return videoCoverImageView
    }()
    
    
    fileprivate lazy var playButton : UIButton = {
       let playButton = UIButton()
        playButton.backgroundColor = .red
        return playButton
    }()
    
    
    fileprivate lazy var stPlayer = STPlayer()
    
    
    
    var  videoModelFrame : VideoModelFrame?{
        didSet{
            guard let videoModelFrame = videoModelFrame else { return }
            if let url = URL(string: videoModelFrame.videoCoverImageUrl){
                videoCoverImageView.kf.setImage(with: url, placeholder: UIImage(named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
        }
    }
    
    var isHiddenPlayer: Bool?{
        didSet{
            guard let isHiddenPlayer = isHiddenPlayer else { return }
            playButton.isHidden = isHiddenPlayer
//            zfpPlayerView.isHidden = isHiddenPlayer
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        addSubview(videoCoverImageView)
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(RecommentVideoView.buttonAction), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoCoverImageView.frame = bounds
        playButton.frame = CGRect(x: 100, y: 60, width: 40, height: 40)
    }
    
    @objc func buttonAction(){
        
//            delegateVideoView?.didPlayClickButton(self,index)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommentVideoView : WMPlayerDelegate{
    //点击播放暂停按钮代理方法
    func wmplayer(_ wmplayer: WMPlayer!, clickedPlayOrPause playOrPauseBtn: UIButton!) {
        
    }
    
    //点击关闭按钮代理方法
    func wmplayer(_ wmplayer: WMPlayer!, clickedClose closeBtn: UIButton!) {
        
    }
    //点击全屏按钮代理方法
    func wmplayer(_ wmplayer: WMPlayer!, clickedFullScreenButton fullScreenBtn: UIButton!) {
        
    }
    //单击WMPlayer的代理方法
    func wmplayer(_ wmplayer: WMPlayer!, singleTaped singleTap: UITapGestureRecognizer!) {
        
    }
    //双击WMPlayer的代理方法
    func wmplayer(_ wmplayer: WMPlayer!, doubleTaped doubleTap: UITapGestureRecognizer!) {
        
    }
    
    ///播放状态
    //播放失败的代理方法
    func wmplayerFailedPlay(_ wmplayer: WMPlayer!, wmPlayerStatus state: WMPlayerState) {
        
    }
    
    //准备播放的代理方法
    func wmplayerReady(toPlay wmplayer: WMPlayer!, wmPlayerStatus state: WMPlayerState) {
        // 发送通知
    }
    //播放完毕的代理方法
    func wmplayerFinishedPlay(_ wmplayer: WMPlayer!) {
        
    }
}
