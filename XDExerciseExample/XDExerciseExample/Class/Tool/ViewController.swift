//
//  ViewController.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/3.
//  Copyright © 2018年 CoderST. All rights reserved.
//  分段视频录制

import UIKit
import GPUImage
import AVFoundation
import Photos
import AVKit
import SVProgressHUD
class ViewController: UIViewController , AVCaptureFileOutputRecordingDelegate {
    
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    fileprivate let captureSession = AVCaptureSession()
    //将捕获到的视频输出到文件
    fileprivate let fileOutput = AVCaptureMovieFileOutput()
    
    //录制、
    fileprivate lazy var recordButton : UIButton = {
        let recordButton = UIButton(frame: CGRect(x:0,y:0,width:120,height:50))
        recordButton.backgroundColor = UIColor.red
        recordButton.layer.masksToBounds = true
        recordButton.setTitle("按住录像", for: .normal)
        recordButton.layer.cornerRadius = 20.0
        recordButton.layer.position = CGPoint(x: self.view.bounds.width/2,
                                              y:view.bounds.height-50)
        recordButton.addTarget(self, action: #selector(onTouchDownRecordButton(_:)),
                               for: .touchDown)
        recordButton.addTarget(self, action: #selector(onTouchUpRecordButton(_:)),
                               for: .touchUpInside)
        return recordButton
    }()
    //保存按钮
    fileprivate lazy var saveButton : UIButton = {
        let saveButton = UIButton(frame: CGRect(x:0,y:0,width:70,height:50))
        saveButton.backgroundColor = UIColor.gray
        saveButton.layer.masksToBounds = true
        saveButton.setTitle("保存", for: .normal)
        saveButton.layer.cornerRadius = 20.0
        
        saveButton.layer.position = CGPoint(x: view.bounds.width - 60,
                                            y:view.bounds.height - 50)
        saveButton.addTarget(self, action: #selector(onClickStopButton(_:)),
                             for: .touchUpInside)
        return saveButton
    }()
    
    fileprivate lazy var backButton : UIButton = {
       let backButton = UIButton(frame: CGRect(x: 10, y: view.bounds.height - 50, width: 30, height: 30))
        backButton.backgroundColor = .yellow
        backButton.setTitle("返回", for: .normal)
        backButton.setTitleColor(.red, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        backButton.addTarget(self, action: #selector(backButtonAction(_:)),
                             for: .touchUpInside)
        return backButton
    }()
    
    //保存所有的录像片段数组
    fileprivate var videoAssets = [AVAsset]()
    //保存所有的录像片段url数组
    fileprivate var assetURLs = [String]()
    //单独录像片段的index索引
    fileprivate var appendix: Int32 = 1
    
    //最大允许的录制时间（秒）
    fileprivate let totalSeconds: Float64 = 15.00
    //每秒帧数
    fileprivate var framesPerSecond:Int32 = 30
    //剩余时间
    fileprivate var remainingTime : TimeInterval = 15.0
    
    //表示是否停止录像
    fileprivate var stopRecording: Bool = false
    //剩余时间计时器
    fileprivate var timer: Timer?
    //进度条计时器
    fileprivate var progressBarTimer: Timer?
    //进度条计时器时间间隔
    fileprivate var incInterval: TimeInterval = 0.05
    //进度条
    fileprivate var progressBar: UIView = UIView()
    //当前进度条终点位置
    fileprivate var oldX: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // AVMutableComposition
        
        //视频输入设备
        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        //添加视频、音频输入设备
        guard let kvideoDevice = videoDevice else {
            debugLog("没有视频输入设备")
            return
            
        }
        let videoInput = try! AVCaptureDeviceInput(device: kvideoDevice)
        self.captureSession.addInput(videoInput)
        
        //音频输入设备
        let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
        guard let kaudioDevice = audioDevice else {
            debugLog("没有音频输入设备")
            return
            
        }
        let audioInput = try! AVCaptureDeviceInput(device: kaudioDevice)
        self.captureSession.addInput(audioInput)
        
        //添加视频捕获输出
        let maxDuration = CMTimeMakeWithSeconds(totalSeconds, framesPerSecond)
        self.fileOutput.maxRecordedDuration = maxDuration
        self.captureSession.addOutput(fileOutput)
        
        //使用AVCaptureVideoPreviewLayer可以将摄像头的拍摄的实时画面显示在ViewController上
        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        //预览窗口是正方形，在屏幕居中（显示的也是摄像头拍摄的中心区域）
        videoLayer.frame = CGRect(x:0, y:view.bounds.height/4,
                                  width: view.bounds.width,
                                  height: view.bounds.width)
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
        
        //添加按钮
        setupButton()
        
        //启动session会话
        captureSession.startRunning()
        
        //添加进度条
        setupProgessBar()
    }
    
    //创建按钮
    fileprivate func setupButton(){
        //添加按钮到视图上
        view.addSubview(recordButton)
        view.addSubview(saveButton)
        view.addSubview(backButton)
    }
    
    fileprivate func setupProgessBar(){
        progressBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width,
                                   height: view.bounds.height * 0.1)
        progressBar.backgroundColor = UIColor(red: 4, green: 3, blue: 3, alpha: 0.5)
        view.addSubview(progressBar)
    }
    
    deinit {
        SVProgressHUD.dismiss()
    }
}

// MARK:- 代理方法
extension ViewController {
    //录像开始的代理方法
    func fileOutput(_ output: AVCaptureFileOutput,
                    didStartRecordingTo fileURL: URL,
                    from connections: [AVCaptureConnection]) {
        startProgressBarTimer()
        startTimer()
    }
    
    //录像结束的代理方法
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection], error: Error?) {
        let asset = AVURLAsset(url: outputFileURL, options: nil)
        var duration : TimeInterval = 0.0
        duration = CMTimeGetSeconds(asset.duration)
        print("生成视频片段：\(asset)")
        videoAssets.append(asset)
        assetURLs.append(outputFileURL.path)
        remainingTime = remainingTime - duration
        
        //到达允许最大录制时间，自动合并视频
        if remainingTime <= 0 {
            mergeVideos()
        }
    }
}

// MARK:- 时间
extension ViewController {
    //剩余时间计时器
    func startTimer() {
        timer = Timer(timeInterval: remainingTime, target: self,
                      selector: #selector(ViewController.timeout), userInfo: nil,
                      repeats:true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    //录制时间达到最大时间
    @objc func timeout() {
        stopRecording = true
        print("时间到。")
        fileOutput.stopRecording()
        timer?.invalidate()
        progressBarTimer?.invalidate()
    }
    
    //进度条计时器
    func startProgressBarTimer() {
        progressBarTimer = Timer(timeInterval: incInterval, target: self,
                                 selector: #selector(ViewController.progress),
                                 userInfo: nil, repeats: true)
        RunLoop.current.add(progressBarTimer!, forMode: .defaultRunLoopMode)
    }
}

// MARK:- 点击方法
extension ViewController {
    //按下录制按钮，开始录制片段
    @objc func  onTouchDownRecordButton(_ sender: UIButton){
        if(!stopRecording) {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let outputFilePath = "\(documentsDirectory)/output-\(appendix).mov"
            appendix += 1
            let outputURL = URL(fileURLWithPath: outputFilePath)
            let fileManager = FileManager.default
            if(fileManager.fileExists(atPath: outputFilePath)) {
                
                do {
                    try fileManager.removeItem(atPath: outputFilePath)
                } catch _ {
                }
            }
            print("开始录制：\(outputFilePath) ")
            fileOutput.startRecording(to: outputURL, recordingDelegate: self)
        }
    }
    
    //松开录制按钮，停止录制片段
    @objc func  onTouchUpRecordButton(_ sender: UIButton){
        if(!stopRecording) {
            timer?.invalidate()
            progressBarTimer?.invalidate()
            fileOutput.stopRecording()
        }
    }
    
    
    //修改进度条进度
    @objc func progress() {
        let progressProportion: CGFloat = CGFloat(incInterval / totalSeconds)
        let progressInc: UIView = UIView()
        progressInc.backgroundColor = UIColor(red: 55/255, green: 186/255, blue: 89/255,
                                              alpha: 1)
        let newWidth = progressBar.frame.width * progressProportion
        progressInc.frame = CGRect(x: oldX , y: 0, width: newWidth,
                                   height: progressBar.frame.height)
        oldX = oldX + newWidth
        progressBar.addSubview(progressInc)
    }
    
    //保存按钮点击
    @objc func onClickStopButton(_ sender: UIButton){
        mergeVideos()
    }
    
    // 返回
    @objc func backButtonAction(_ sender: UIButton){
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- 合并视频片段
extension ViewController {
    func mergeVideos() {
        if videoAssets.count == 0 {
            SVProgressHUD.showInfo(withStatus: "没有视频片段")
            return
        }
        let duration = totalSeconds
        
        let composition = AVMutableComposition()
        //合并视频、音频轨道
        let firstTrack = composition.addMutableTrack(
            withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
        let audioTrack = composition.addMutableTrack(
            withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())
        
        var insertTime: CMTime = kCMTimeZero
        
        SVProgressHUD.showInfo(withStatus: "正在合并压缩视频,请您稍等...")
        SVProgressHUD.show()
        for asset in videoAssets {
            print("合并视频片段：\(asset)")
            do {
                try firstTrack?.insertTimeRange(
                    CMTimeRangeMake(kCMTimeZero, asset.duration),
                    of: asset.tracks(withMediaType: AVMediaType.video)[0] ,
                    at: insertTime)
            } catch _ {
            }
            do {
                try audioTrack?.insertTimeRange(
                    CMTimeRangeMake(kCMTimeZero, asset.duration),
                    of: asset.tracks(withMediaType: AVMediaType.audio)[0] ,
                    at: insertTime)
            } catch _ {
            }
            
            insertTime = CMTimeAdd(insertTime, asset.duration)
        }
        //旋转视频图像，防止90度颠倒
        firstTrack?.preferredTransform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        
        //定义最终生成的视频尺寸（矩形的）
        print("视频原始尺寸：", firstTrack!.naturalSize)
        let renderSize = CGSize(width: firstTrack!.naturalSize.height,
                                height:firstTrack!.naturalSize.height)
        print("最终渲染尺寸：", renderSize)
        
        //通过AVMutableVideoComposition实现视频的裁剪(矩形，截取正中心区域视频)
        let videoComposition = AVMutableVideoComposition()
        videoComposition.frameDuration = CMTimeMake(1, framesPerSecond)
        videoComposition.renderSize = renderSize
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(
            kCMTimeZero,CMTimeMakeWithSeconds(Float64(duration), framesPerSecond))
        
        let transformer: AVMutableVideoCompositionLayerInstruction =
            AVMutableVideoCompositionLayerInstruction(assetTrack: firstTrack!)
        let t1 = CGAffineTransform(translationX: firstTrack!.naturalSize.height,
                                   y: -(firstTrack!.naturalSize.width - firstTrack!.naturalSize.height)/2)
        let t2 = t1.rotated(by: CGFloat.pi/2)
        let finalTransform: CGAffineTransform = t2
        transformer.setTransform(finalTransform, at: kCMTimeZero)
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        //获取合并后的视频路径
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                .userDomainMask,true)[0]
        let destinationPath = documentsPath + "/mergeVideo-\(arc4random()%1000).mov"
        print("合并后的视频：\(destinationPath)")
        let videoPath = URL(fileURLWithPath: destinationPath as String)
        let exporter = AVAssetExportSession(asset: composition,
                                            presetName:AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileType.mov
        exporter.videoComposition = videoComposition //设置videoComposition
        exporter.shouldOptimizeForNetworkUse = true
        exporter.timeRange = CMTimeRangeMake(
            kCMTimeZero,CMTimeMakeWithSeconds(Float64(duration), framesPerSecond))
        exporter.exportAsynchronously(completionHandler: {
            //将合并后的视频保存到相册
            self.exportDidFinish(session: exporter)
        })
    }
}

extension ViewController {
    // MARK:- 将合并后的视频保存到相册
    func exportDidFinish(session: AVAssetExportSession) {
        print("视频合并成功！")
        SVProgressHUD.dismiss()
        let outputURL = session.outputURL!
        //将录制好的录像保存到照片库中
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            DispatchQueue.main.async {
                //重置参数
                self.reset()
                
                //弹出提示框
                let alertController = UIAlertController(title: "视频保存成功",
                                                        message: "是否需要回看录像？",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                    action in
                    //录像回看
                    self.reviewRecord(outputURL: outputURL)
                })
                let cancelAction = UIAlertAction(title: "取消", style: .cancel,
                                                 handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true,
                             completion: nil)
            }
        })
    }
}

// MARK:- 视频保存成功，重置各个参数，准备新视频录制
extension ViewController {
    func reset() {
        //删除视频片段
        for assetURL in assetURLs {
            if(FileManager.default.fileExists(atPath: assetURL)) {
                do {
                    try FileManager.default.removeItem(atPath: assetURL)
                } catch _ {
                }
                print("删除视频片段: \(assetURL)")
            }
        }
        
        //进度条还原
        let subviews = progressBar.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        //各个参数还原
        videoAssets.removeAll(keepingCapacity: false)
        assetURLs.removeAll(keepingCapacity: false)
        appendix = 1
        oldX = 0
        stopRecording = false
        remainingTime = totalSeconds
    }
}

// MARK:- 录像回看
extension ViewController {
    func reviewRecord(outputURL: URL) {
        //定义一个视频播放器，通过本地文件路径初始化
        let player = AVPlayer(url: outputURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
