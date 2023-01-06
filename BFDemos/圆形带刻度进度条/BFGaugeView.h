

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 进度条动画方式
typedef enum : NSUInteger {
    /// 连续动画，从上一个值继续滑动
    ProgressAnimationStyleContinuously,
    /// 每次设值从原点开始滑动
    ProgressAnimationStyleFromOrigin
} ProgressAnimationStyle;

@interface BFGaugeView : UIView

/// 圆环起点（默认-215°）
@property (nonatomic, assign) CGFloat startAngle;

/// 圆环终点（默认35°）
@property (nonatomic, assign) CGFloat endAngle;

/// 进度
@property (nonatomic, assign) CGFloat progress;

/// 环形进度条宽度（默认8）
@property (nonatomic, assign) CGFloat progressBarWidth;

/// 环形进度条颜色
@property (nonatomic, strong) UIColor *progressBarColor;

/// 分割点边长
@property (nonatomic, assign) CGFloat dotLength;

/// 分割点个数
@property (nonatomic, assign) NSUInteger numberOfDots;

/// 区间刻度名
@property (nonatomic, strong) NSArray <NSString *> *intervalDials;

/// 点刻度名
@property (nonatomic, strong) NSArray <NSString *> *dotDials;

/// 数值
@property (nonatomic, strong) UILabel *valueLabel;

/// title
@property (nonatomic, strong) UILabel *titleLabel;

/// 分割点高亮颜色
@property (nonatomic, strong) UIColor *dotHighlightedColor;

/// 分割点正常颜色
@property (nonatomic, strong) UIColor *dotNormalColor;

/// 进度条动画方式
@property (nonatomic, assign) ProgressAnimationStyle progressAnimationStyle;

/// 加载动画开关
- (void)loading:(BOOL)loading;

@end

NS_ASSUME_NONNULL_END
