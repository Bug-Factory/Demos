

/**
 1、常用宏定义
 2、常量定义

 宏命名: 三选一
 全部大写，单词间用 _ 分隔。[不带参数]
 　　例子: #define THIS_IS_AN_MACRO @"THIS_IS_AN_MACRO"
 以字母 k 开头，后面遵循大驼峰命名。[不带参数]
 　　例子：#define kWidth self.frame.size.width
 小驼峰命名。[带参数]
 　　#define getImageUrl(url) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,url]]
 **/
#import <UIKit/UIKit.h>
#ifndef MacroConst_h
#define MacroConst_h


////调试输出
//#ifndef __OPTIMIZE__
//#define NSLog(...) NSLog(@"\n\n %s 第%d行  输出内容:\n\n%@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
//#else
//#define NSLog(...)
//#endif

///使用真机屏蔽无用网络日志的调试输出
#ifndef __OPTIMIZE__
#define DKLogString [NSString stringWithFormat:@"%s", __func__].lastPathComponent
#define DKLogDataString [DKCommonTools getCurrentDate]
#define NSLog(...) printf("\n%s  第%d行  输出内容:\n\n%s\n\n",[DKLogString UTF8String],__LINE__,[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#else
#define NSLog(...)
#endif
#pragma - mark 设备类型
#define kIsIpad (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)

#pragma - mark 常用宏定义

/// weak声明
#define kWeakSelf __weak __typeof(self) weakSelf = self;

#define kStrongSelf __strong __typeof(self) strongSelf = weakSelf;

///全局Window
#define SINGLE_WINDOWS [UIApplication sharedApplication].delegate.window
/// 图片
#define kImg(name) [UIImage imageNamed:name]
///适配320 字体  12 mini 360
#define kFontValue(value) (SCREEN_WIDTH <= 360) ? value - 2 : value

/// APP默认字体：等宽字体
#define kFontSize(value) kMonospacedFontSize(kFontValue(value)) //[UIFont systemFontOfSize:kFontValue(value)]
///等宽字体
#define kMonospacedFontSize(value) [UIFont fontWithName:@"Helvetica Neue" size:kFontValue(value)]
/// APP默认加粗字体：等宽加粗
#define kBoldFontSize(value)  [UIFont fontWithName:@"HelveticaNeue-Bold" size:kFontValue(value)] //[UIFont boldSystemFontOfSize:kFontValue(value)]
/// 自定义通用字体
#define kFontNameSize(fontType,value) [UIFont fontWithName:fontType size:value]
/// 苹方-简 中黑体
#define kPFFont_Medium(value) [UIFont fontWithName:@"PingFangSC-Medium" size:value]
/// 苹方-简 中粗体
#define kPFFont_Semibold(value) [UIFont fontWithName:@"PingFangSC-Semibold" size:kFontValue(value)]
/// 苹方-简 细体
#define kPFFont_Light(value) [UIFont fontWithName:@"PingFangSC-Light" size:value]
/// 苹方-简 极细体
#define kPFFont_Ultralight(value) [UIFont fontWithName:@"PingFangSC-Ultralight" size:value]
/// 苹方-简 常规体
#define kPFFont_Regular(value) [UIFont fontWithName:@"PingFangSC-Regular" size:value]
/// 苹方-简 纤细体
#define kPFFont_Thin(value) [UIFont fontWithName:@"PingFangSC-Thin" size:value]





#pragma - mark - 设备尺寸相关

///屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

///状态栏高度
#define SafeAreaStatusHeight [UIApplication sharedApplication].statusBarFrame.size.height

///适配iPhoneX导航栏高度，88
#define SafeAreaTopHeight (SafeAreaStatusHeight + 44)

/// 适配iPhoneX底部距离，34
#define SafeAreaBottomHeight (SafeAreaStatusHeight > 20 ? 34 : 0)

///适配iPhoneX横屏时，底部白条高度
#define SafeAreaLandscapeBottom (SafeAreaStatusHeight > 20 ? 20 : 0)

///TabBar高度
#define SafeTabBarHeight (SafeAreaStatusHeight > 20 ? (49.0 + 34.0):(49.0))

#define IPAD_IPhone_POPViewWidht (UI_IS_IPAD ? kScreenW * 3 / 5 : (SCREEN_WIDTH - 30))

///iPhoneX和iPhone8状态栏高度差
#define BangGapToNormalHeight (SafeAreaStatusHeight - 20)
#define ControlModuleWidth (SCREEN_WIDTH - 18 * 2 - cardRowSpacing * (cardRowCount - 1)) / cardRowCount
#define ScheduleControlModuleWidth (UI_IS_IPAD ? (SCREEN_WIDTH - GetRealWidth(154)) / 3 : (SCREEN_WIDTH - 35) / 2)
//#define ScheduleControlModuleWidth ((UI_IS_IPAD) ? (ControlModuleWidth) :(SCREEN_WIDTH - 35) / 2)
///不同屏幕高度转换，用iphone6的高度去计算比例
#define GetRealHeight(height) (height / (UI_IS_IPAD ? 1024.0 : 667.0) * SCREEN_HEIGHT)
///不同屏幕宽度转换，用iphone6的宽度去计算比例
#define GetRealWidth(width) (width / (UI_IS_IPAD ? 768.0 : 375.0) * SCREEN_WIDTH)
#define GetRealWidthLandscape(width) (width / (UI_IS_IPAD ? 768.0 : 375.0) * SCREEN_HEIGHT)
///屏幕宽度比例，本手机屏幕和iPhone6屏幕宽度比
#define ScreenWidthRatio (SCREEN_WIDTH / (UI_IS_IPAD ? 768.0 : 375.0))
///屏幕高度比例，本手机屏幕和iPhone6屏幕高度比
#define ScreenHeightRatio (SCREEN_HEIGHT / (UI_IS_IPAD ? 1024.0 : 667.0))
#define kIgnoreTableViewInsert(tableView) {if (@available(iOS 11.0, *)) {if ([tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;}} else {}}


#pragma - mark - 设备相关

//判断设备型号
#define UI_IS_LANDSCAPE         ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)
#define UI_IS_IPAD              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE4           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS       (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations
#define UI_IS_IPHONEX           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height > 736.0)
#define UI_IS_IPHONEX_LANDSCAPE           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.width > 736.0)
#define UI_IS_IOS8_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define UI_IS_IPHONE5_LANDSCAPE (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.width == 568.0)

///获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
///手机别名： 用户定义的名称
#define IOS_PHONE_NAME [[UIDevice currentDevice] name]
///设备名称
#define IOS_PHONE_DEVICENAME [[UIDevice currentDevice] systemName]
///手机型号
#define IOS_PHONE_DEVICEMODEL [[UIDevice currentDevice] model]

///获取APP当前Version版本
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
///获取APP当前Build版本
#define APP_BUILD_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
///获取APP的包名Bounld_Identifier
#define APP_BID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
///获取APP名称
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#endif /* MacroConst_h */
