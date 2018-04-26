//
//  RegisterVM.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/17.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit

class RegisterVM: NSObject {

}

extension RegisterVM{
    /// 登录
    func registerSignIn(successCallBack : @escaping ()->(), stateCallBack : @escaping (_ message : String)->(), failedCallBack : @escaping (_ erroe : Error)->()){
        let parameters = [
            "username" : "25667017399",
            "password" : "123456",
            "come_form_app" : "0.0"
        ]
        
        NetWork.requestData(.post, URLString: SIGN_IN_URL, model: USER_URL, parameters: parameters, version: version_10) { (result) in
            guard let resultDict = result as? NSDictionary else { return }
            debugLog(resultDict)
//            if let recommendMainModel = RecommendMainModel.deserialize(from: resultDict){
//                if recommendMainModel.code == 0{
//
//                    successCallBack()
//                }else{
//                }
//            }
            
            //            debugLog(recommendModel)
        }
    }
}
