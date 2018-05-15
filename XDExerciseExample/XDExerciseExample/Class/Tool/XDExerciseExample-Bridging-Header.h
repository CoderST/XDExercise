#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X          (XD_IS_IPHONE && XD_SCREEN_MAX_LENGTH == 812.0)

/// 导航条高度
#define XD_APPLICATION_TOP_BAR_HEIGHT (XD_IS_IPHONE_X?88.0f:64.0f)
/// tabBar高度
#define XD_APPLICATION_TAB_BAR_HEIGHT (XD_IS_IPHONE_X?83.0f:49.0f)
/// 工具条高度 (常见的高度)
#define XD_APPLICATION_TOOL_BAR_HEIGHT_44  44.0f
#define XD_APPLICATION_TOOL_BAR_HEIGHT_49  49.0f
/// 状态栏高度
#define XD_APPLICATION_STATUS_BAR_HEIGHT (XD_IS_IPHONE_X?44:20.0f)


// 适配AF
#ifndef TARGET_OS_IOS

#define TARGET_OS_IOS TARGET_OS_IPHONE

#endif

#ifndef TARGET_OS_WATCH

#define TARGET_OS_WATCH 0

#endif


// 输出日志 (格式: [时间] [哪个方法] [哪行] [输出内容])
#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%zd行] 💕 %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

// 日记输出宏
#ifdef DEBUG // 调试状态, 打开LOG功能
#define XDLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define XDLog(...)
#endif

// 打印方法
#define XDLogFunc XDLog(@"%s", __func__)


// 打印请求错误信息
#define XDLogErrorMessage  XDLog(@"错误请求日志-----【 %@ 】--【 %@ 】",[self class] , error.XD_message)


// KVO获取监听对象的属性 有自动提示
// 宏里面的#，会自动把后面的参数变成c语言的字符串
#define XDKeyPath(objc,keyPath) @(((void)objc.keyPath ,#keyPath))




// 是否为iOS7+
#define XDIOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 是否为4inch
#define XDFourInch ([UIScreen mainScreen].bounds.size.height == 568.0)

// 屏幕总尺寸
#define XDMainScreenBounds  [UIScreen mainScreen].bounds
#define XDMainScreenHeight  [UIScreen mainScreen].bounds.size.height
#define XDMainScreenWidth   [UIScreen mainScreen].bounds.size.width

// IOS版本
#define XDIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

// 销毁打印
#define XDDealloc XDLog(@"\n =========+++ %@  销毁了 +++======== \n",[self class])

// 是否为空对象
#define XDObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define XDStringIsEmpty(__string) ((__string.length == 0) || XDObjectIsNil(__string))

// 字符串不为空
#define XDStringIsNotEmpty(__string)  (!XDStringIsEmpty(__string))

// 数组为空
#define XDArrayIsEmpty(__array) ((XDObjectIsNil(__array)) || (__array.count==0))

// 取消ios7以后下移
#define XDDisabledAutomaticallyAdjustsScrollViewInsets \
if (XDIOSVersion>=7.0) {\
self.automaticallyAdjustsScrollViewInsets = NO;\
}

// AppCaches 文件夹路径
#define XDCachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

// App DocumentDirectory 文件夹路径
#define XDDocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]

// 系统放大倍数
#define XDScale [[UIScreen mainScreen] scale]

/**
 *  Frame PX  ---> Pt 6的宽度 全部向下取整数
 */
#define XDPxConvertPt(__Px) floor((__Px) * XDMainScreenWidth/375.0f)
/**
 *  Frame PX  ---> Pt 6的宽度 返回一个合适的值 按钮手指触摸点 44
 */
#define XDFxConvertFitPt(__px) (MAX(XDPxConvertPt(__Px),44))


// 设置图片
#define XDImageNamed(__imageName) [UIImage imageNamed:__imageName]


/// 适配iPhone X + iOS 11
#define  XDAdjustsScrollViewInsets_Never(__scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([__scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = __scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

#import "Utilities.h"
#import "WebViewJavascriptBridge.h"
#import "CLPlayerView.h"
#import "WMPlayer.h"
#import "Masonry.h"
// 三方视屏头文件

