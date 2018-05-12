//
//  QianDaoView.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/26.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
protocol QianDaoViewDelegate : class {
    func qianDaoView(_ qianDaoView : QianDaoView)
}
class QianDaoView: UIView {

    weak var delegateQianDao : QianDaoViewDelegate?
    fileprivate lazy var titleLabel : UILabel = {
       let titleLabel = UILabel()
        titleLabel.clipsToBounds = true
        titleLabel.text = "签到\\n抽奖"
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .black
        titleLabel.isUserInteractionEnabled = true
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(titleLabel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(QianDaoView.tapAction))
        titleLabel.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
        titleLabel.layer.cornerRadius = frame.height * 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension  QianDaoView{
    func show(_ view : UIView){
        addSubview(view)
    }
    
    func dismiss(){
        removeFromSuperview()
    }
}

extension QianDaoView {
    @objc func tapAction(){
        delegateQianDao?.qianDaoView(self)
    }
}
