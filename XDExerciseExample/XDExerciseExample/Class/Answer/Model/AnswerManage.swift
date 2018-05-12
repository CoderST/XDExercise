//
//  AnswerManage.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/10.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
enum AnswerManageType:Int{
    /// 未开始
    case UNBEGIN = 0
    /// 即将开始 倒计时中
    case COUNTDOWN
    /// 开始中 答题中
    case START
    /// 已结束
    case END
}

let TimeActionNotification = "TimeActionNotification"

class AnswerManage: NSObject {

    static let shareInstant : AnswerManage = AnswerManage()
    
    var timeInterval : TimeInterval = 0
    var time : Timer?
    
    /// 开始倒计时
    func startCount(){
        
        time = Timer(timeInterval: 1, target: self, selector: #selector(AnswerManage.timeAction), userInfo: nil, repeats: true)
        RunLoop.main.add(time!, forMode: .commonModes)
    }
    
    func reload() {
        timeInterval = 0
    }
    
    @objc func timeAction() {
        timeInterval = timeInterval + 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TimeActionNotification), object: nil, userInfo: ["timeInterval" : timeInterval])
    }
    
    func timeInvalidate() {
        timeInterval = 0
        time?.invalidate()
        time = nil
    }
    
}
