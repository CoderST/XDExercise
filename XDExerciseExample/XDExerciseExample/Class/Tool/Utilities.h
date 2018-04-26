//
//  Utilities.h
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/15.
//  Copyright © 2018年 CoderST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
#pragma mark - MD5加密
+(NSString *) md5:(NSString *)str;
+(NSString *) anotherMD5:(NSString *)str;
#pragma mark - 字典转字符串
+(NSString*)dictionaryToString:(NSDictionary*)dic;
@end
