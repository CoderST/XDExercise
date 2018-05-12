//
//  XDVideoTool.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/11.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
protocol XDVideoToolDelegate : class {
//    func playButtonClick(viewCell : )
}
class XDVideoTool: UIView {

    fileprivate var mediaPlayer : VMediaPlayer?
    
    fileprivate lazy var playOrPauseButton : UIButton = {
       let playOrPauseButton = UIButton()
        playOrPauseButton.backgroundColor = .red
        return playOrPauseButton
    }()
    /**
     *快速初始化
     */
    func initWithFrame(frame : CGRect, _ videoURL : String){
        self.frame = frame
        self.backgroundColor = .black
        let width : CGFloat = 40
        let height = width
        let x : CGFloat = (frame.width - width) * 0.5
        let y : CGFloat = (frame.height - width) * 0.5
//        playOrPauseButton.frame = CGRect(x: x, y: <#T##CGFloat#>, width: width, height: height)
//        [self initUI:videoURL];
        initUI(videoURL)
        /// 添加手势
//        [self addRecognizer];
    }
    
    func initUI(_ vedioUrl : String){
//        let medis = VMediaPlayer.sharedInstance()
        mediaPlayer = VMediaPlayer.sharedInstance()
        mediaPlayer?.setupPlayer(withCarrierView: self, with: self)
    
        guard let videoUrl = URL(string: vedioUrl) else{
            
            print("url不存在")
            return
        }
        mediaPlayer?.setDataSource(videoUrl)
        mediaPlayer?.setVideoFillMode(.init(1))
        mediaPlayer?.prepareAsync()
        
        
    }
    
    /**
     快速重置播放器
     可以在无需alloc一个新的播放器对象之前清除上一播放器对象残留数据
     */
//    - (void) resetVedio;
    func resetVedio(){
        mediaPlayer?.reset()
    }
    
    /**
     设置播放器资源
     */
//    - (void) setDataSource:(NSString *)vedioUrl;
    func setDataSource(vedioUrl : String){
        guard let videoUrl = URL(string: vedioUrl) else{
            
            print("url不存在")
            return
        }
        mediaPlayer?.setDataSource(videoUrl)
    }
    
    /**
     设置播放器资源(注册播放器)
     播放视屏之前的资源准备，完成以后会调用 mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg代理 开始播放
     */
//    - (void) prepareAsyncVedio;
    func prepareAsyncVedio(){
        mediaPlayer?.prepareAsync()
    }
    
    /**
     开始播放视屏
     */
//    - (void) startVedio;
    func startVedio(){
        mediaPlayer?.start()
    }
    
    /**
     暂停视屏播放
     */
//    - (void) pauseVedio;
    func pauseVedio(){
        mediaPlayer?.pause()
    }
    
    /**
     关闭播放器
     */
//    - (void)close;
    func close(){
        
    }
    
    /**
     取消注册播放器（资源回收）
     */
//    -(BOOL)unSetupPlayer;
    func unSetupPlayer()->Bool{
        let resultBool = mediaPlayer?.unSetupPlayer() ?? false
        return resultBool
    }
    
    /**
     重新设置播放器Frame
     */
//    - (void) setVedioFrame:(CGRect)frame;
    func setVedioFrame(frame : CGRect){
        
    }
    
}

// MARK:- 播放器代理
extension XDVideoTool : VMediaPlayerDelegate{
    //    Vitamio播放器准备完成可以准备播放
    func mediaPlayer(_ player: VMediaPlayer!, didPrepared arg: Any!) {
        player.start()
    }
    
    func mediaPlayer(_ player: VMediaPlayer!, playbackComplete arg: Any!) {
        player.reset()
    }
    func mediaPlayer(_ player: VMediaPlayer!, error arg: Any!) {
        print("-------播放器内部错误")
    }
    
}
