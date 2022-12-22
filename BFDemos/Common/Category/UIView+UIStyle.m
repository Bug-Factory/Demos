//
//  UIView+UIStyle.m
//  DKUHomeClient
//
//  Created by Fcny on 2021/11/5.
//  Copyright © 2021 Daikin (China) Investment Co., Ltd. Technology Development Research Institute. All rights reserved.
//

#import "UIView+UIStyle.h"
static char gradientLayerKey;

@interface UIView()
@property(nonatomic,strong)CAGradientLayer *gradientLayer;
@end

@implementation UIView (UIStyle)

- (CAGradientLayer *)gradientLayer{
    return objc_getAssociatedObject(self, &gradientLayerKey);
}
- (void)setGradientLayer:(CAGradientLayer *)gradientLayer{
    objc_setAssociatedObject(self, &gradientLayerKey, gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    
    [self layoutIfNeeded];
    
    if (borderType == UIBorderSideTypeAll) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = color.CGColor;
        return self;
    }

    /// 左侧
    if (borderType & UIBorderSideTypeLeft) {
        /// 左侧线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.f, 0.f) toPoint:CGPointMake(0.0f, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
      
    /// 右侧
    if (borderType & UIBorderSideTypeRight) {
        /// 右侧线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(self.frame.size.width, 0.0f) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
      
    /// top
    if (borderType & UIBorderSideTypeTop) {
        /// top线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(self.frame.size.width, 0.0f) color:color borderWidth:borderWidth]];
    }
      
    /// bottom
    if (borderType & UIBorderSideTypeBottom) {
        /// bottom线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, self.frame.size.height) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
      
    return self;
}
  
- (CAShapeLayer *)addLineOriginPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth {
  
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p0];
    [bezierPath addLineToPoint:p1];
      
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    return shapeLayer;
}

/// 指定位置设置圆角
/// @param radius 圆角
/// @param corners 指定位置
- (void)setCornerRadius:(CGFloat)radius ByRoundingCorners:(UIRectCorner)corners {
    
    [self layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    //设置大小
    maskLayer.frame = self.bounds;
    
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}


/**
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLineWithLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
     
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
     
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
     
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
     
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0);
     
    [shapeLayer setPath:path];
    CGPathRelease(path);
     
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}



#pragma mark ---- 动画
/// 旋转动画
/// @param timeInterval 时间 s
- (void)addRotationAnimationWithAnimationViewWithTime:(NSTimeInterval)timeInterval{
    CAAnimation *animation = [self.layer animationForKey:@"rotation"];
    if (animation) { return; }
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:4 * M_PI];
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.duration = timeInterval;
    rotationAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:rotationAnimation forKey:@"rotation"];
}

/// 移除旋转动画
- (void)endRotationAnimation {
    CAAnimation *animation = [self.layer animationForKey:@"rotation"];
    if (!animation) { return; }
    [self.layer removeAnimationForKey:@"rotation"];
}


- (void)addBgGradientWithGradientBorderWidth:(CGFloat)borderWidth withGradientBorderColor:(UIColor* _Nullable)borderColor withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint withStartColor:(UIColor *)startColor withEndColor:(UIColor *)endColor{
    [self layoutIfNeeded];
    
    [self.gradientLayer removeFromSuperlayer];
    
    CAGradientLayer *_gradientLayer = [[CAGradientLayer alloc]init];
    _gradientLayer.locations = @[@0,@0.85];
//    _gradientLayer.colors = @[(id)HexColor(@"F1F1F1").CGColor,(id)[UIColor whiteColor].CGColor];
//    [_gradientLayer setStartPoint:CGPointMake(0, 0)];
//    [_gradientLayer setEndPoint:CGPointMake(1, 0)];
    _gradientLayer.colors = @[(id)startColor.CGColor,(id)endColor.CGColor];
    [_gradientLayer setStartPoint:startPoint];
    [_gradientLayer setEndPoint:endPoint];
    if (borderColor) {
        _gradientLayer.borderColor = borderColor.CGColor;
    }
    _gradientLayer.borderWidth = borderWidth;
    _gradientLayer.cornerRadius = self.layer.cornerRadius;
    _gradientLayer.masksToBounds = YES;
    [self.layer insertSublayer:_gradientLayer atIndex:0];
    _gradientLayer.frame = self.bounds;
    self.gradientLayer = _gradientLayer;

}

@end
