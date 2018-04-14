//
//  NetWork.swift
//  data
//
//  Created by xiudou on 2017/2/13.
//  Copyright © 2017年 CoderST. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift
import CoreTelephony
import CommonCrypto
public enum MethodType {
    
    case get
    case post
}


enum NetWorkStates {
    
    case UNKNOW
    case WIFE
    case ViaWWAN
    
}

 let reachability = Reachability()!


public class NetWork: NSObject {
   public class func requestData(_ type : MethodType, URLString : String, model : String, parameters:[String : Any]? = nil,version : String? = "1.8.0",finishCallBack : @escaping (_ result : Any) -> ()){
        
        var newParameters : [String : Any] = [String : Any]()
        if parameters != nil {
            newParameters = parameters!
        }
        // operators
        newParameters["operators"] = getCarrierName()
        // network_status
        newParameters["network_status"] = "wifi"
        getNetWorkStates { (state) in
            var stateString : String = ""
            switch state{
            case .WIFE :
                stateString = "wifi"
            case .ViaWWAN :
                stateString = "wwan"
                default :
                stateString = "NO"
            }
            newParameters["network_status"] = stateString
        }
        // version
        newParameters["version"] = version
        // request_time
        let time = NSDate().timeIntervalSince1970
        newParameters["request_time"] = time
        // requestUrl
        var requestUrl = (model + URLString) as NSString
        requestUrl = requestUrl.substring(from: 1) as NSString
        newParameters["request_url"] = requestUrl
        // source
        newParameters["source"] = "iOS"
        // auth_token
        if TOKEN.characters.count > 0{
            newParameters["auth_token"] = TOKEN
        }
        // sign
        let signString = getSign(parameters: newParameters)
        let resultSign = "\(signString)\(time)xiu^*dou@2016#07#30~!bj99$&"
        let sign = md5String(str: resultSign)
        newParameters["xsign"] = sign
        // 确定请求类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        print("URL = https://xdapi2.beta.xiudou.net/Interfaces/index")
        print("parameters = \(newParameters)")
        Alamofire.request("https://xdapi2.beta.xiudou.net/Interfaces/index", method: method, parameters: newParameters).responseJSON { (response) in
            guard let result = response.result.value else {
                print("没有result")
                return
            }
            
            
            finishCallBack(result: result)
        }
        
    }
    
    fileprivate class func getSign(parameters:[String : Any]) -> String {
        let dict = parameters as NSDictionary
        guard let keys = dict.allKeys as? [String] else { return ""}
        
        var spliceStr : String = ""
        for key in keys {
            if key == "auth_token" {
                print("auth_token不需要处理")
                continue
            }
            guard let obj = dict[key] else {
                print("获取obj失败")
                continue
            }
            guard let objStirng = obj as? String else {
             
                print("objc 转 string 失败")
                continue
            }
            spliceStr = spliceStr + objStirng
            return (spliceStr as NSString).substring(to: spliceStr.characters.count - 1)
        }
        
        return ""
    }
    
    class func md5String(str:String) -> String{
        let cStr = str.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
//        let buffer = "0123456789abcdef"
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    class func getCarrierName()->String? {
        let telephonyInfo = CTTelephonyNetworkInfo()
        guard let carrier = telephonyInfo.subscriberCellularProvider else { return ""}
        return carrier.carrierName ?? ""
    }

}

extension NetWork {
    
    class func getNetWorkStates(statesCallBack : @escaping (_ states : NetWorkStates) -> ()) {
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
//           DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                    statesCallBack(.WIFE)
                } else if reachability.isReachableViaWWAN{
                    print("Reachable via Cellular")
                    statesCallBack(.ViaWWAN)
                }else {
                    statesCallBack(.UNKNOW)
            }
            }
//        }
        
                reachability.whenUnreachable = { reachability in
                    DispatchQueue.main.async {
                        print("Not reachable")
                        statesCallBack(.UNKNOW)
                    }
                    

        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
            statesCallBack(.UNKNOW)
        }
    }
    
    func stop() {
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                            name: ReachabilityChangedNotification,
                                                            object: reachability)
    }
}
