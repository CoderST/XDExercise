//
//  RecommendMainVC.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/14.
//  Copyright © 2018年 CoderST. All rights reserved.
//  推荐主页面

import UIKit
import SVProgressHUD
fileprivate let kRecommendMainVCCollectionViewIdentifier = "kRecommendMainVCCollectionViewIdentifier"
class RecommendMainVC: UIViewController {

    fileprivate lazy var recommentVM : RecommendVM = RecommendVM()
    
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
        let collectionView = UICollectionView(frame:self.view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(RecommendCell.self, forCellWithReuseIdentifier: kRecommendMainVCCollectionViewIdentifier)
        return collectionView;
        
    }()
    var array : [String] = [String]()
    var label : UILabel!
    var count : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

//        perform(Selector(("test")), with: nil, afterDelay: 3)

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

    @objc func timeAction(){
        count += 1
        debugLog(count)
    }
}

extension RecommendMainVC{
    fileprivate func setupUI(){
        recommendCycleView.frame = CGRect(x: 0, y: -kSycleHei, width: kScreenW, height: kSycleHei)
        
        // 设置collectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: kSycleHei, left: 0, bottom: 0, right: 0)
        
        // 签到
        view.addSubview(qianDaoView)
        /// 答题
        view.addSubview(datiButton)
        qianDaoView.delegateQianDao = self
        let width : CGFloat = 40
        qianDaoView.frame = CGRect(x: kScreenW - width - recommentMargin, y: 400, width: width, height: width)
        datiButton.frame = CGRect(x: kScreenW - 30, y: qianDaoView.frame.maxY + 10, width: 20, height: 20)
    }
}
// MARK:- 网络请求
extension RecommendMainVC{
    func networkLoadDatas(){
        recommentVM.loadRecommendDatas(successCallBack: {
            self.recommendCycleView.imagePathsArray = self.recommentVM.imagePathsArray
            self.collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRecommendMainVCCollectionViewIdentifier, for: indexPath) as! RecommendCell
        let videoF = recommentVM.videoModelFrameArray[indexPath.item]
        videoF.collectionView = collectionView
        videoF.indexPathItem = indexPath.item
        cell.videoModelFrame = videoF
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0){
            navigationController?.setNavigationBarHidden(true, animated: false)
        }else{
            navigationController?.setNavigationBarHidden(false, animated: false)
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
}
