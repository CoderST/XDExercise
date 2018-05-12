//
//  CacheHelper.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/5/8.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import YYCache
class CacheHelper: NSObject {

    fileprivate let NetworkResponseCache = "NetworkResponseCache"
    fileprivate var cache : YYCache!
    //创建一个静态或者全局变量，保存当前单例实例值
    private static let scacheHelper = CacheHelper()
    //私有化构造方法
    private override init() {
        cache = YYCache(name: NetworkResponseCache)
    }
    
    //提供一个公开的用来去获取单例的方法
//    func cacheHelperInstance() ->CacheHelper {
//        //返回初始化好的静态变量值
//        return scacheHelper
//    }
    
    /**
     *  缓存网络数据
     *
     *  @param responseCache 服务器返回的数据
     *  @param key           缓存数据对应的key值,推荐填入请求的URL
     */
//    +(void)saveResponseCache:(id)responseCache forKey:(NSString *)key;
    
    func saveCache(responseCache : Any, key : String){
        cache.setObject(responseCache as! NSCoding, forKey: key)
    }

}
