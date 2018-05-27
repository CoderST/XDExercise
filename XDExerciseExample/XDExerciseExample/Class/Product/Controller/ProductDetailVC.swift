//
//  ProductDetailVC.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/29.
//  Copyright © 2018年 CoderST. All rights reserved.
//  商品详情页

import UIKit
import FDFullscreenPopGesture
fileprivate let ProductDetailCellIdentifier = "ProductDetailCellIdentifier"
fileprivate let ProductDetailReusableViewIdentifier = "ProductDetailReusableViewIdentifier"
enum ProductDetailVC_Type:String{
    case normal_product = "0" // 正常商品
    case spick_product = "1" // 秒杀商品
}
class ProductDetailVC: UIViewController {

    fileprivate lazy var productDeatilVM : ProductDetailVM = ProductDetailVM()
    
    fileprivate lazy var productDeatilHeadView : ProductDetailHeadView = ProductDetailHeadView()
    
    // 返回button
    fileprivate lazy var backButton : UIButton = {
       let backButton = UIButton()
        backButton.backgroundColor = .red
        backButton.frame = CGRect(x: 0, y: 70, width: 40, height: 40)
        return backButton
    }()
    
    // collectionView
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        // 设置layout属性
        let layout = XDPlanFlowLayout()
        layout.naviHeight = 0
        let width = kScreenW
        // 默认值(如果改动可以添加代理方法)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: kScreenW, height: 20)
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.register(ProductDetailCell.self, forCellWithReuseIdentifier: ProductDetailCellIdentifier)
        collectionView.register(ProductDetailReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ProductDetailReusableViewIdentifier)
        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.backgroundColor = UIColor.gray
        return collectionView;
        }()
    
    var productDetailVCType : ProductDetailVC_Type = .normal_product
    var videoFrame : VideoModelFrame?{
        didSet{
            guard let videoFrame = videoFrame else { return }
            // 数据传递给headview
            
            // 取出ID
            let productID = videoFrame.videoModel.product_id
            loadProductDetailData(productID, productDetailVCType.rawValue)
            loadProductDetailCellDatas(productID)
        }
    }
    
    var product_id : String?{
        didSet{
            guard let productID = product_id else { return }
            // 数据传递给headview
            
            // 取出ID
            loadProductDetailData(productID, productDetailVCType.rawValue)
            loadProductDetailCellDatas(productID)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fd_prefersNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
        setupUI()
        // 取消布局
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
}

// MARK:- UI
extension ProductDetailVC {
    fileprivate func setupUI(){
        view.addSubview(collectionView)
        collectionView.addSubview(productDeatilHeadView)
        
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        // 设置collectionView的内边距
//        collectionView.contentOffset = CGPoint(x: 0, y: 20)
    }
    
    @objc fileprivate func backButtonAction(){
//        popViewController(animated: true)
        /*
         if (self.navigationController.topViewController == self)
         { [self.navigationController popViewControllerAnimated:YES]; } else { [self dismissViewControllerAnimated:YES completion:nil]; }
         */
//        if let topViewController = navigationController?.topViewController{
//            if topViewController == self{
//                navigationController?.popViewController(animated: true)
//            }else{
//                dismiss(animated: true, completion: nil)
//            }
//        }
        
        
//        if (self.presentingViewController) { [self dismissViewControllerAnimated:YES completion:nil]; } else { [self.navigationController popViewControllerAnimated:YES]; }
        
        if presentingViewController != nil{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
}

// MARK:- 网络请求
extension ProductDetailVC{
    fileprivate func loadProductDetailData(_ productID : String, _ isSpikeProduct : String){
        let token = kTOKEN
        productDeatilVM.loadProductDetailDatas(productID, token, productDetailVCType.rawValue, successCallBack: {
            debugLog("请求到数据了")
            let headHeight = self.productDeatilVM.productModelFrame?.headViewHeight ?? 0
            self.collectionView.contentInset = UIEdgeInsets(top: headHeight, left: 0, bottom: 0, right: 0)
            self.productDeatilHeadView.frame = CGRect(x: 0, y: -headHeight, width: kScreenW, height: headHeight)
            self.productDeatilHeadView.productModelFrame = self.productDeatilVM.productModelFrame
            self.collectionView.contentOffset.y = -headHeight
        }, stateCallBack: { (message) in
            // 请求不到数据 加载首页传递过来的数据
            debugLog("没请求到",file: message)
        }) { () in
            // 请求不到数据 加载首页传递过来的数据
            debugLog("错误信息")
        }
    }

    fileprivate func loadProductDetailCellDatas(_ product_id : String){
        productDeatilVM.loadProductDetailCellDatas(product_id, successCallBack: {
            debugLog("cell的数据")
            self.collectionView.reloadData()
        }, stateCallBack: { (message) in
            
        }) {
            
        }
    }
}

// MARK:- UICollectionViewDataSource
extension ProductDetailVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return productDeatilVM.buyCommentModelGroup.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        let buyCommentModel = productDeatilVM.buyCommentModelGroup[section]
        let anyModel = buyCommentModel.modelList
        return anyModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailCellIdentifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let size = CGSize(width: kScreenW, height: 50)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ProductDetailReusableViewIdentifier, for: indexPath) as! ProductDetailReusableView
        // 获取数据传递
        let buyCommentModel = productDeatilVM.buyCommentModelGroup[indexPath.section]
        view.buyCommentModel = buyCommentModel
//        view.titleString = delegate?.stCollectionHeadInSection?(self, at: indexPath)
        
        return view
    }
}
