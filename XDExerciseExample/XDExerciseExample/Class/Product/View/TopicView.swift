//
//  TopicView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/3.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
@objc protocol TopicViewDelegate : class {
    func topicCount(_ topicView : TopicView,numberOfItemsInSection: Int)->Int
    func topicSize(_ topicView : TopicView,indexPath: IndexPath)->CGSize
    func topicName(_ topicView : TopicView,indexPath: IndexPath)->String
    
//    @objc optional func topicView(_ topicView : TopicView, didSelectItemAt indexPath: IndexPath)
}
fileprivate let TopicCollectionViewCellIdentifier = "TopicCollectionViewCellIdentifier"
class TopicView: UIView {

    weak var delegateTopic : TopicViewDelegate?
    // collectionView
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        //        layout.naviHeight = 0
        let width = kScreenW
        // 默认值(如果改动可以添加代理方法)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCellIdentifier)
        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView;
        }()
    
    
    func collectionViewReloadData(){
        collectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopicView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = delegateTopic?.topicCount(self, numberOfItemsInSection: section) ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCellIdentifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.randomColor()
        
        return cell
    }
}

extension TopicView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = delegateTopic?.topicSize(self, indexPath: indexPath) ?? CGSize.zero
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegateTopic?.topicView!(self, didSelectItemAt: indexPath)
    }
}

