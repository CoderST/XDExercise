//
//  RecommentVideoView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/16.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import ZFPlayer
class RecommentVideoView: UIView {

    fileprivate lazy var zfpModel : ZFPlayerModel = ZFPlayerModel()
//    static let playerView = ZFPlayerView.shared()
    fileprivate lazy var zfpPlayerView : ZFPlayerView = {
       let zfpPlayerView = ZFPlayerView.shared()!
//        zfpPlayerView.delegate = self
        zfpPlayerView.stopPlayWhileCellNotVisable = true
        return zfpPlayerView
    }()
    
    
    fileprivate lazy var playButton : UIButton = {
       let playButton = UIButton()
        playButton.backgroundColor = .red
        return playButton
    }()
    
    var  videoModelFrame : VideoModelFrame?{
        didSet{
            guard let videoModelFrame = videoModelFrame else { return }
            debugLog(tag)
            


        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        addSubview(zfpPlayerView)
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(RecommentVideoView.buttonAction), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        zfpPlayerView.frame = bounds
        playButton.frame = CGRect(x: 100, y: 60, width: 40, height: 40)
        debugLog(frame)
        debugLog(zfpPlayerView.frame)
    }
    
    @objc func buttonAction(){
        guard let videoModelFrame = videoModelFrame else { return }
        let controlView = ZFPlayerControlView()
        zfpModel.fatherViewTag = tag
        let index = videoModelFrame.indexPathItem
        let indexPath = NSIndexPath(item: index, section: 0)
        zfpModel.indexPath = indexPath as IndexPath!
        zfpModel.placeholderImageURLString = videoModelFrame.videoCoverImageUrl
        //            zfpModel.placeholderImage = UIImage(named: "avatar_default")
        if let collectionView = videoModelFrame.collectionView{
            zfpModel.scrollView = collectionView
        }
        if let url = URL(string: "http://v1.mukewang.com/3e35cbb0-c8e5-4827-9614-b5a355259010/L.mp4"){
            
//            zfpModel.resolutionDic = ["高清" : "http://v1.mukewang.com/3e35cbb0-c8e5-4827-9614-b5a355259010/L.mp4"]
            zfpModel.videoURL = url
        }
        
        
        zfpPlayerView.playerLayerGravity = .resizeAspectFill
        zfpPlayerView.delegate = self
        zfpPlayerView.playerControlView(controlView, playerModel: zfpModel)
        //            zfpPlayerView.playerModel(zfpModel)
                    zfpPlayerView.autoPlayTheVideo()
        //            zfpPlayerView.reset(toPlayNewVideo: zfpModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommentVideoView : ZFPlayerDelegate{
    
}
