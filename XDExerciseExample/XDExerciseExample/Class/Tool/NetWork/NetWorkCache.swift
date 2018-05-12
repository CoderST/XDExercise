//
//  NetWorkCache.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/8.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import YYCache
class NetWorkCache: NSObject {

    fileprivate static let kPPNetworkResponseCache = "kPPNetworkResponseCache"
    fileprivate static var shareInstance : YYCache? = YYCache(name: kPPNetworkResponseCache)

    private override init() {
    }
    
    // MARK:- 对外接口
    /// 异步缓存网络数据,根据请求的 URL与parameters
    class func setHttpCache(httpData : Any, _ API_URL : String, _ parameters : [String : Any]){
        setHttpCachePrivate(httpData: httpData, API_URL, parameters)
    }
    
    /// 根据请求的 URL与parameters 同步取出缓存数据
    class func httpCacheForURL( _ API_URL : String, _ parameters : [String : Any])->[String : Any]{
        return httpCacheForURLPrivate(API_URL, parameters)
    }
    
    /// 获取网络缓存的总大小 bytes(字节)
    class func getAllHttpCacheSize()->Int{
        return getAllHttpCacheSize()
    }
    
    /// 删除所有网络缓存
    class func removeAllHttpCache(){
        return removeAllHttpCachePrivate()
    }
}

// MARK:- 私有方法
extension NetWorkCache {
    
    /**
     *  异步缓存网络数据,根据请求的 URL与parameters
     *  做KEY存储数据, 这样就能缓存多级页面的数据
     *
     *  @param httpData   服务器返回的数据
     *  @param URL        请求的URL地址
     *  @param parameters 请求的参数
     */
    class fileprivate func setHttpCachePrivate(httpData : Any, _ API_URL : String, _ parameters : [String : Any]){
        let cacheKey = cacheKeyWithURL(API_URL: API_URL, parameters) as String
        if let data = httpData as? [String : Any]{
            let newdata = data as NSCoding
            debugLog("newdata = \(data) -> \(newdata)")
            shareInstance?.setObject(newdata, forKey: cacheKey, with: {
                debugLog("缓存成功")
            })
        }else{
            print("data没有遵循NSCoding")
        }
    }
    
    
    /**
     *  根据请求的 URL与parameters 同步取出缓存数据
     *
     *  @param URL        请求的URL
     *  @param parameters 请求的参数
     *
     *  @return 缓存的服务器数据
     */
    class fileprivate func httpCacheForURLPrivate( _ API_URL : String, _ parameters : [String : Any])->[String : Any]{
        let cacheKey = cacheKeyWithURL(API_URL: API_URL, parameters) as String
        guard let shareInstance = shareInstance else {
            
            return [:]
            
        }
        guard let data = shareInstance.object(forKey: cacheKey) else {
            
            return [:]
        }
        guard let dataDict = data as? [String : Any] else {
            return [:]
        }
        return dataDict
    }
    
    /// 获取网络缓存的总大小 bytes(字节)
    class fileprivate func getAllHttpCacheSizePrivate()->Int{
        let dataSize = shareInstance?.diskCache.totalCost() ?? 0
        return dataSize
    }
    
    /// 删除所有网络缓存
    class fileprivate func removeAllHttpCachePrivate(){
        // [_dataCache.diskCache removeAllObjects];
        shareInstance?.diskCache.removeAllObjects {
            print("删除缓存结束")
        }
    }
    
    
    // 对parameters进行处理,因为工程中的字段参数每一次都是不一样的,所以在取缓存的时候就取不出老数据
    /*
     api_url
     url
     current_page 不一定有
     */
    
    class fileprivate func cacheKeyWithURL(API_URL : String, _ parameters : [String : Any]) ->NSString{
        var resultString : NSString = ""
        var newParameters : [String : Any] = [String : Any]()
        newParameters["API_URL"] = API_URL
        guard let request_url = parameters["request_url"] as? String else { return resultString}
        newParameters["request_url"] = request_url
        if let current_page = parameters["current_page"]{
            if current_page is String {
                newParameters["current_page"] = current_page
            }else if current_page is Int{
                let currentPage = current_page as! Int
                newParameters["current_page"] = String(currentPage)
            }else{
                print(current_page)
            }
        }
        
        do {
            let stringData = try JSONSerialization.data(withJSONObject: newParameters, options: .init(rawValue: 0))
            let paraString = NSString.init(data: stringData, encoding: String.Encoding.utf8.rawValue) ?? ""
            
//            debugLog("cacheKey == \(paraString)")
            let string = API_URL + (paraString as String)
            resultString = string as NSString
            return resultString
        } catch  {
            print("错误==",error);
        }
        
        return resultString
    }
}
