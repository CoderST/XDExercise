//
//  RecommendMainVC.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/14.
//  Copyright © 2018年 CoderST. All rights reserved.
//  推荐主页面

import UIKit
import SVProgressHUD
fileprivate let kRecommendMainVCCellIdentifier = "kRecommendMainVCCellIdentifier"
var currentPlayerIngCell : UICollectionViewCell?
class RecommendMainVC: UIViewController {
    /// 正在播放视频的cell
    fileprivate var playingCell : RecommendCell?
    /// 显示视频的view
    fileprivate var clPlayerView : CLPlayerView?
    /// 是否自动播放
    fileprivate let isAutoPlay : Bool = true
    /// 刚开始进入界面 标记第一个cell是否移除界面
    fileprivate var firstCellIsOutWindow : Bool = false
    /// 不是自动播放情况下,点击播放按钮添加的CLPlayerView的数组
    fileprivate lazy var clPlayerViewArray : [CLPlayerView] = [CLPlayerView]()

    /// 首页VM
    fileprivate lazy var recommentVM : RecommendVM = RecommendVM()
    /// 登录VM
    fileprivate lazy var registerVM : RegisterVM = RegisterVM()
    
    // MARK:- 懒加载
    // gif动画
    fileprivate lazy var gifView : GifView = {
        
        let gifView = GifView()
        gifView.delegateGif = self
        return gifView
        
    }()
    // 轮播图的view
    fileprivate lazy var recommendCycleView : RecommendCycleView = {
        
        let recommendCycleView = RecommendCycleView()
        recommendCycleView.delegateCycle = self
        return recommendCycleView
        
    }()
    
    // 签到抽奖
    fileprivate lazy var qianDaoView : QianDaoView = {
       let qianDaoView = QianDaoView()
        
        return qianDaoView
    }()
    
    /// 答题
    fileprivate lazy var datiButton : UIButton = {
       let datiButton = UIButton()
        datiButton.backgroundColor = .red
        
        return datiButton
    }()
    
    // collectionView
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        // 默认值(如果改动可以添加代理方法)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        // 创建UICollectionView
        let frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        let collectionView = UICollectionView(frame:frame, collectionViewLayout: layout)
//        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(RecommendCell.self, forCellWithReuseIdentifier: kRecommendMainVCCellIdentifier)
        return collectionView;
        
    }()
    var array : [String] = [String]()
    var label : UILabel!
    var count : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "推荐"
        view.addSubview(collectionView)
        // 添加子控间
        collectionView.addSubview(recommendCycleView)
        // 设置布局尺寸
        setupUI()
        // 刷新网络请求
        networkLoadDatas()
        // 添加gif
//        addGIFViewAnimation()
        // 或者最新token
        getNewToken()
        
        // 测试定时器
//        let time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
//        RunLoop.main.add(time, forMode: .commonModes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths{
            let cell = collectionView.cellForItem(at: indexPath)
            
            if  indexPath.item == 0{
                let cell = cell as! RecommendCell
                didPlayClickButton(cell, indexPath)
            }
        }
    }

    @objc func timeAction(){
        count += 1
        debugLog(count)
    }
}

extension RecommendMainVC{
    fileprivate func setupUI(){
        recommendCycleView.frame = CGRect(x: 0, y: -kSycleHei, width: kScreenW, height: kSycleHei)
        
        // 设置collectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
//        // 签到
//        view.addSubview(qianDaoView)
//        /// 答题
//        view.addSubview(datiButton)
//        qianDaoView.delegateQianDao = self
//        let width : CGFloat = 40
//        qianDaoView.frame = CGRect(x: kScreenW - width - recommentMargin, y: 400, width: width, height: width)
//        datiButton.frame = CGRect(x: kScreenW - 30, y: qianDaoView.frame.maxY + 10, width: 20, height: 20)
    }
}
// MARK:- 网络请求
extension RecommendMainVC{
    func networkLoadDatas(){
        recommentVM.loadRecommendDatas(successCallBack: {[weak self] in
            self?.recommendCycleView.imagePathsArray = self?.recommentVM.imagePathsArray
            self?.collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
                
                //进入界面播放
                if self?.isAutoPlay == true{
                    
                    self?.playVideoInVisiableCells()
                }
            }
          
        }, stateCallBack: { (message) in
            SVProgressHUD.showInfo(withStatus: message)
        }) { (error) in
            let eoo = error as NSError
            SVProgressHUD.showError(withStatus: String(eoo.code))
        }
    }
    
    func getNewToken(){
//        registerVM.registerSignIn(successCallBack: {
//            
//        }, stateCallBack: { (message) in
//            
//        }) { (error) in
//            
//        }
    }
}

// MARK:- UICollectionViewDataSource
extension RecommendMainVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return recommentVM.videoModelFrameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRecommendMainVCCellIdentifier, for: indexPath) as! RecommendCell
        cell.indexPathCell = indexPath
        let videoF = recommentVM.videoModelFrameArray[indexPath.item]
        videoF.collectionView = collectionView
        videoF.collectionView = collectionView
        videoF.indexPathItem = indexPath.item
        cell.videoModelFrame = videoF
        cell.delegateRecommendCell = self
        return cell
        
    }
    
}

// MARK:- UICollectionViewDelegateFlowLayout
extension RecommendMainVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let videoF = recommentVM.videoModelFrameArray[indexPath.item]
        let size  = CGSize(width: kScreenW, height:  videoF.cellHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoF = recommentVM.videoModelFrameArray[indexPath.item]
        let video = videoF.videoModel
        switch video.type {
        case .product:
            let productDetailVC = ProductDetailVC()
            productDetailVC.videoFrame = videoF
            navigationController?.pushViewController(productDetailVC, animated: true)
        default:
            let normalVC = ViewController()
//            present(normalVC, animated: true, completion: nil)
//            navigationController?.pushViewController(normalVC, animated: true)
            debugLog("点击了日常")
        }
    }
}




// MARK:- 私人代理
// 轮播图点击事件
extension RecommendMainVC : RecommendCycleViewDelegate,GifViewDelegate,QianDaoViewDelegate{
  
    func recommendCycleViewCycleScrollView(_ recommendCycleView: RecommendCycleView, didSelectItemAt index: Int) {
        guard let listArray = recommentVM.recommendMainModel?.list else { return }
        let remommend = listArray.recommend[index]
        debugLog(remommend.recommend_images)
    }
    
    func didGifView(_ gifView: GifView) {
        debugLog("点击了gif")
    }
    
    func qianDaoView(_ qianDaoView: QianDaoView) {
        let token = "NPr9OVVKOaHSeqOrNmziX6ckb1PGlgEuRnucNdO5KNvf6MU5dXMGhVZKjSU2OAql437vpGNMdNT1zvS%2BuWh6lw%3D%3D"
        debugLog("hhhhhh")
        // vc.url = [NSString stringWithFormat:@"%@%@%@.html?auth_token=%@&client=iOS",H5_URL,INTEGRAL,INTEGRAL_USER_SIGN,TOKEN];
        let activityVC = MoreActivityVC()
//        kNavigation().pushViewController(activityVC, animated: true)
        present(activityVC, animated: true, completion: nil)
    }
}

// MARK:- 私有方法
extension RecommendMainVC{
    fileprivate func addGIFViewAnimation(){
        view.addSubview(gifView)
        let gifW : CGFloat = 110
        let gifH : CGFloat = 60
        gifView.imageName = "answerEntrance.gif"
        gifView.frame = CGRect(x: kScreenW - gifW - recommentMargin, y: kScreenH - gifH - 5 * recommentMargin, width: gifW, height: gifH)
    }
    
    
    fileprivate func creatPlayerView(_ cell : RecommendCell) ->CLPlayerView{
        let videoF = cell.videoModelFrame?.videoF ?? CGRect.zero
        let playerView = CLPlayerView(frame: videoF)
        // 由于内部封装问题,模式必须写在前面(已修复)
        let urlS = cell.videoModelFrame?.videoUrl ?? ""
        guard let url = URL(string: urlS) else {
            SVProgressHUD.showError(withStatus: "没有UIL")
            return CLPlayerView()
            
        }
        playerView.url = url
        playerView.fillMode = .ResizeAspect
        return playerView
    }
    
    /// 第一次加载播放第一个cell视频逻辑
    fileprivate func playVideoInVisiableCells(){
        /*下面是我实际项目中代码。在这里你需要做的就是获得第一个有视频的cell，并进行播放和记录。播放视频可以抽到一个方法中，需要的就是播放视频所在的cell以及视频播放所需要的地址URL等。可以仿照我的进行写代码，当然，如果你的每个cell类型相同且都有视频，你可以直接获取可见的cell NSArray *visiableCells = [self.tableView visibleCells]; 判断 visiableCells.count是否大于0，正在播放的cell就是第一个了。
         接下来我们说一说播放视频- (void)initPlayerView:(DiscoverVideoCell *)cell playClick:(ConventionsModel *)convention
         */
        // 找到下一个要播放的cell(最在屏幕中心的)
        var firstCell : RecommendCell?
        let visiableCells = collectionView.visibleCells
        //存放大框播放视频
        for cell in visiableCells{
            // 判断cell的类型是播放视频的类型
            guard let recommendCell = cell as? RecommendCell else { continue }
            // 取出cell模型
            let videoModelFrame = recommendCell.videoModelFrame
            let type = videoModelFrame?.videoModel.media_type ?? .image
            if type == .video{
                let oneCell = cell as! RecommendCell
                firstCell = oneCell
                break
            }
        }
        if firstCell != nil{
            initPlayerView(cell: firstCell!, firstCell?.videoModelFrame)
        }
        
    }
    
    /// 滚动停止逻辑
    fileprivate func handleScrollPlaying(_ scrollView : UIScrollView){
        var finnalCell : RecommendCell?
        // 找到下一个要播放的cell(最在屏幕中心的)
        let visiableCells = collectionView.visibleCells
        
        //存放大框播放视频
        var tempVideoCells : [RecommendCell] = [RecommendCell]()
        for (_, visiableCell) in visiableCells.enumerated(){
            // 判断这个cell是不是需要播放的视频cell
            // 是不是播放类型的cell
            
            // 取出cell模型
            guard let recommendVisiableCell = visiableCell as? RecommendCell else { continue }
            let videoModelFrame = recommendVisiableCell.videoModelFrame
            let type = videoModelFrame?.videoModel.media_type ?? .image
            if type == .video{
                tempVideoCells.append(recommendVisiableCell)
            }
        }
        
        var indexPaths : [IndexPath] = [IndexPath]()
        var gap = CGFloat(MAXFLOAT)
        for videoCell in tempVideoCells{
            guard let index = collectionView.indexPath(for: videoCell)else { continue }
            indexPaths.append(index)
            
            //计算距离屏幕中心最近的cell
            let coorCentre = videoCell.superview?.convert(videoCell.center, to: nil)
            let delta = fabs((coorCentre?.y ?? 0) - UIScreen.main.bounds.height * 0.5)
            if (delta < gap) {
                gap = delta;
                finnalCell = videoCell
            }
        }
        
        // 注意, 如果正在播放的cell和finnalCell是同一个cell, 不应该在播放(如果是循环引用的cell要做处理 用url来做判断)
        let playingCellUrlstring = playingCell?.videoModelFrame?.videoUrl
        let finnalCellUrlstring = finnalCell?.videoModelFrame?.videoUrl
        if (playingCell == nil && finnalCell != nil && playingCellUrlstring != finnalCellUrlstring){
            // 1:如果播放器存在.销毁
            if (clPlayerView != nil) {
                clPlayerView?.destroyPlayer()
                clPlayerView = nil;
            }
            
            // 2:创建新的播放
            initPlayerView(cell: finnalCell!, finnalCell?.videoModelFrame)
            playingCell = finnalCell;
            return;
        }else{
            print("自己看着这么办吧",playingCellUrlstring , finnalCellUrlstring,playingCell,finnalCell)
        }
        
    }
    
    /// 创建clPlayerView逻辑
    fileprivate func initPlayerView(cell : RecommendCell, _ convention : VideoModelFrame?){
        // 1 记录正在播放的cell
        playingCell = cell
        // 2 清楚上个播放器
        clPlayerView?.destroyPlayer()
        clPlayerView = nil
        // 3 创建新的播放器
        //        let playerView = CLPlayerView(frame: cell.videoFrame)
        //        playerView.url = convention?.url
        //        playerView.fillMode = .ResizeAspect
        let playerView = creatPlayerView(cell)
        clPlayerView = playerView
        // 4 添加到需要显示的控件上
        cell.contentView.addSubview(playerView)
        
        //5 视频地址 调用外部变量必须加[weak self] in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            // your code here
            
            self?.clPlayerView?.playVideo()
            // 添加到数组(添加到数组操作放到block外面导致一个问题没理解:在didPlayButton方法中contains方法返回一直是false,放在这就好了)
            self?.clPlayerViewArray.append(playerView)
        }
        
        //返回按钮点击事件回调
        clPlayerView?.backButton({ (button) in
            print("返回按钮点击")
        })
        
        //播放完成回调
        clPlayerView?.endPlay({[weak self] in
            print("播放完成")
            //销毁播放器
            self?.clPlayerView?.destroyPlayer()
            self?.clPlayerView = nil
        })
        
    }
}

extension RecommendMainVC : RecommendCellDelegate{
//    func didPlayer(_ recommendCell: RecommendCell, _ zfpPlayerView: ZFPlayerView) {
//        currentPlayerIngCell = recommendCell
//        currentZfpPlayerView = zfpPlayerView
//    }
    
    func didPlayClickButton(_ recommendCell: RecommendCell, _ indexPath: IndexPath) {
        let videoModelFrame = recommentVM.videoModelFrameArray[indexPath.item]
        let urls = videoModelFrame.videoUrl
    }
}

    // MARK:- scrollowView代理
extension RecommendMainVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
   
        if playingCell != nil{
            /* 我发现作者对于内存的释放有一点问题，播放器销毁后内存并没有下降
             * clPlayerView?.calculateScrollOffset(tableView, cell: playingCell!)
             */
            let cellRect = collectionView.convert(playingCell!.frame, to: collectionView)
            let rectInSuperview = collectionView.convert(cellRect, to: view)
            if rectInSuperview.origin.y > kScreenH || rectInSuperview.origin.y + rectInSuperview.size.height < 0{
                print("移除了playingCell")
                playingCell = nil
                // 2 移除数组中的clPlayerView
                if clPlayerView != nil{
                    clPlayerView!.destroyPlayer()
                    let bool = clPlayerViewArray.contains(clPlayerView!)
                    if bool == true{
                        let index = clPlayerViewArray.index(of: clPlayerView!)
                        clPlayerViewArray.remove(at: index!)
                    }
                    clPlayerView = nil
                }
                
                firstCellIsOutWindow = true
                
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if isAutoPlay == true{
                if firstCellIsOutWindow == true{
                    
                    handleScrollPlaying(scrollView)
                }
            }

        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isAutoPlay == true{
            
            if firstCellIsOutWindow == true{
                
                handleScrollPlaying(scrollView)
            }
        }

    }
}


