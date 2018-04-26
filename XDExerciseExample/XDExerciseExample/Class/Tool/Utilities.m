//
//  Utilities.m
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/15.
//  Copyright © 2018年 CoderST. All rights reserved.
//

#import "Utilities.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation Utilities
+(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString *) anotherMD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
    
}

+(NSString*)dictionaryToString:(NSDictionary*)dic{
    NSArray* keys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString* str1 = obj1;
        NSString* str2 = obj2;
        return [str1 compare:str2];
    }];
    NSMutableString* spliceStr = [NSMutableString string];
    for(NSString* key in keys){
        if([key isEqualToString:@"auth_token"]){
            continue;
        }
        id object = [dic objectForKey:key];
        if([object isMemberOfClass:NSNumber.class]){
            [spliceStr appendFormat:@"%@=%zd&",key,[object stringValue]];
        }else{
            [spliceStr appendFormat:@"%@=%@&",key,object];
        }
    }
    if(spliceStr.length>0){
        return [spliceStr substringToIndex: spliceStr.length-1];
    }else{
        return @"";
    }
    
}
@end
