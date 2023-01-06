

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 边框类型(位移枚举)
typedef NS_ENUM(NSInteger, UIBorderSideType) {
    UIBorderSideTypeAll    = 0,
    UIBorderSideTypeTop    = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft   = 1 << 2,
    UIBorderSideTypeRight  = 1 << 3,
};

@interface UIView (UIStyle)

/// 设置view指定位置的边框
/// @param color 边框颜色
/// @param borderWidth  边框宽度
/// @param borderType  边框类型 例子: UIBorderSideTypeTop|UIBorderSideTypeBottom
- (UIView *)borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;

/// 指定位置设置圆角
/// @param radius 圆角
/// @param corners 指定位置
- (void)setCornerRadius:(CGFloat)radius ByRoundingCorners:(UIRectCorner)corners;

/// 画虚线
/// @param lineLength  虚线的宽度
/// @param lineSpacing 虚线的间距
/// @param lineColor 虚线的颜色
- (void)drawDashLineWithLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;


#pragma mark ---- 动画
/// 旋转动画
/// @param timeInterval 时间 s
- (void)addRotationAnimationWithAnimationViewWithTime:(NSTimeInterval)timeInterval;
/// 移除旋转动画
- (void)endRotationAnimation;

- (void)addBgGradientWithGradientBorderWidth:(CGFloat)borderWidth withGradientBorderColor:(UIColor* _Nullable)borderColor withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint withStartColor:(UIColor *)startColor withEndColor:(UIColor *)endColor;

@end

NS_ASSUME_NONNULL_END
