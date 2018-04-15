//
//  RecommendMainVC.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/14.
//  Copyright © 2018年 CoderST. All rights reserved.
//  推荐主页面

import UIKit
fileprivate let kRecommendMainVCCollectionViewIdentifier = "kRecommendMainVCCollectionViewIdentifier"
class RecommendMainVC: UIViewController {

    fileprivate lazy var recommentVM : RecommendVM = RecommendVM()
    
    // MARK:- 懒加载
    // 轮播图的view
    fileprivate lazy var recommendCycleView : RecommendCycleView = {
        
        let recommendCycleView = RecommendCycleView()
        return recommendCycleView
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        title = "推荐"
        view.addSubview(collectionView)
        // 添加子控间
        collectionView.addSubview(recommendCycleView)
        // 设置布局尺寸
        setupUI()
        // 刷新网络请求
        networkLoadDatas()
    }

}

extension RecommendMainVC{
    fileprivate func setupUI(){
        recommendCycleView.frame = CGRect(x: 0, y: -kSycleHei, width: kScreenW, height: kSycleHei)
        
        // 设置collectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: kSycleHei, left: 0, bottom: 0, right: 0)
    }
}

extension RecommendMainVC{
    func networkLoadDatas(){
        recommentVM.loadRecommendDatas(successCallBack: {
            self.recommendCycleView.recommendCycleModelArray = self.recommentVM.recommendModel?.list?.recommend
            self.collectionView.reloadData()
        }, stateCallBack: { (message) in
            
        }) { (error) in
            
        }
    }
}

// MARK:- UICollectionViewDataSource
extension RecommendMainVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        debugLog(recommentVM.recommendModel?.list?.video.count ?? 0)
        return recommentVM.recommendModel?.list?.video.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRecommendMainVCCollectionViewIdentifier, for: indexPath) as! RecommendCell
        cell.contentView.backgroundColor = UIColor.randomColor()
        return cell
        
    }
    
}

// MARK:- UICollectionViewDelegateFlowLayout
extension RecommendMainVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size  = CGSize(width: kScreenW, height:  kRowHei)
        return size
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let anchorFramelist = anchorviewModel.anchorFramelist
//        let liveVC = STLiveAnchoViewController()
//        //        liveVC.anchorFrame = anchorFrame
//        // 1 判断数组是否有值
//        if anchorFramelist.count == 0{
//            return
//        }
//        // 2 传递数组和当前indexpath
//        liveVC.showDatasAndIndexPath(anchorFramelist, indexPath)
//        present(liveVC, animated: true, completion: nil)
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0){
            navigationController?.setNavigationBarHidden(true, animated: false)
        }else{
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
}
