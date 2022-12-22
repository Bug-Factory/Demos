//
//  DKGaugeView.m
//  DKUHomeClient
//
//  Created by FCN2021 on 2022/12/13.
//  Copyright © 2022 Daikin (China) Investment Co., Ltd. Technology Development Research Institute. All rights reserved.
//

#import "BFGaugeView.h"
#import "UIView+UIStyle.h"

// 角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


#define SelfWidth self.frame.size.width
#define SelfHeight self.frame.size.height

// 环形进度条中心半径
#define AnnulusCenterRadii (SelfWidth / 2 - _progressBarWidth)

@interface BFGaugeView() {
    /// 环形进度条
    CAShapeLayer *_annulusLayer;
    
    /// 上一次进度值
    CGFloat _lastProgress;
}

/// 环形总度数
@property (nonatomic, assign) CGFloat totalAngle;

/// 分割点数组
@property (nonatomic, strong) NSMutableArray *dotViewArray;

/// 区间刻度label数组
@property (nonatomic, strong) NSMutableArray *intervalDialLabelArray;

/// 点刻度label数组
@property (nonatomic, strong) NSMutableArray *dotDialLabelArray;

/// 加载动画图片
@property (nonatomic, strong) UIImageView *loadingImageView;


@end

@implementation BFGaugeView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.clearColor;
        [self createSubviews];
        [self initiateData];
    }
    return self;
}

- (void)createSubviews {
    
    
    
}

/// 加载动画开关
- (void)loading:(BOOL)loading {
    self.valueLabel.hidden = loading;
    self.loadingImageView.hidden = !loading;
    if (loading) {
        [self.loadingImageView addRotationAnimationWithAnimationViewWithTime:2.5];
    }else {
        [self.loadingImageView endRotationAnimation];
    }
}

- (void)initiateData {
    _startAngle = -215;
    _endAngle = 35;
    _progress = 0;
    _progressBarWidth = 8;
    _progressBarColor = UIColor.systemRedColor;
    _dotLength = _progressBarWidth - 2;
    _numberOfDots = 0;
    _lastProgress = 0;
    _dotNormalColor = UIColor.systemGrayColor;
    _dotHighlightedColor = UIColor.systemPinkColor;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef progressContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(progressContext, _progressBarWidth);
    CGContextSetRGBStrokeColor(progressContext, 246.0 / 255.0, 246.0 / 255.0, 246.0 / 255.0, 1);
    
    CGFloat centerX = SelfWidth / 2;
    CGFloat centerY = SelfHeight / 2;
    
    //绘制环形进度条底框
    CGContextAddArc(progressContext, centerX, centerY, AnnulusCenterRadii, DEGREES_TO_RADIANS(_startAngle), DEGREES_TO_RADIANS(_endAngle), 0);
    CGContextDrawPath(progressContext, kCGPathStroke);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(centerX,centerY) radius:AnnulusCenterRadii startAngle:DEGREES_TO_RADIANS(_startAngle) endAngle:DEGREES_TO_RADIANS(_endAngle) clockwise:YES];
    
    [_annulusLayer removeFromSuperlayer];
    _annulusLayer = [CAShapeLayer layer];
    _annulusLayer.path = path.CGPath;
    _annulusLayer.fillColor = [UIColor clearColor].CGColor;
    _annulusLayer.strokeColor = _progressBarColor.CGColor;
    _annulusLayer.lineWidth = _progressBarWidth;
    _annulusLayer.lineCap = @"butt";
    _annulusLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layer insertSublayer:_annulusLayer atIndex:0];
    
    [self drawLineAnimatedWithLayer:_annulusLayer fromValue:_lastProgress endValue:_progress];
}


// 动画绘制进度条
- (void)drawLineAnimatedWithLayer:(CALayer*)layer fromValue:(CGFloat)fromValue endValue:(CGFloat)endValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    animation.toValue = [NSNumber numberWithFloat:endValue];
    [layer addAnimation:animation forKey:@"strokeEndAnimation"];
}

#pragma mark - setter方法 -

- (void)setDotNormalColor:(UIColor *)dotNormalColor {
    _dotNormalColor = dotNormalColor;
    [self updateDotColor];
}

- (void)setDotHighlightedColor:(UIColor *)dotHighlightedColor {
    _dotHighlightedColor = dotHighlightedColor;
    [self updateDotColor];
}

/// 更新分割点颜色
- (void)updateDotColor {
    // 最后一个高亮点下标
    // n个点，均分成 n - 1 份
    // 进度等于点所在位置时高亮，进度为0时 置为-1，将第一个点熄灭
    CGFloat lastHighlightedIndex = _progress == 0 ? -1 : _progress * (_numberOfDots - 1);
    for (int i = 0; i < self.dotViewArray.count; i++) {
        UIView *dotView = self.dotViewArray[i];
        dotView.backgroundColor = i <= lastHighlightedIndex ? _dotHighlightedColor : _dotNormalColor;
    }
}

- (void)setProgressBarColor:(UIColor *)progressBarColor {
    _progressBarColor = progressBarColor;
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress {
    if (self.progressAnimationStyle == ProgressAnimationStyleContinuously) {
        _lastProgress = _progress;
    }
    _progress = progress;
    [self drawLineAnimatedWithLayer:_annulusLayer fromValue:_lastProgress endValue:_progress];
    [self updateDotColor];
}


- (void)setNumberOfDots:(NSUInteger)numberOfDots {
    _numberOfDots = numberOfDots;
    
    [self prepareSelfForNewSubviewsWithArray:self.dotViewArray];
    
    // 创建新的dot
    CGFloat intervalAngle = self.totalAngle / (numberOfDots - 1);
    for (int i = 0; i < numberOfDots; i++) {
        UIView *dotView = [[UIView alloc] init];
        dotView.backgroundColor = _dotNormalColor;
        dotView.layer.cornerRadius = _dotLength / 2;
        dotView.clipsToBounds = YES;
        [self addSubview:dotView];
        [self bringSubviewToFront:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(_dotLength);
            make.centerX.mas_equalTo(AnnulusCenterRadii * cosf(DEGREES_TO_RADIANS(_startAngle + i * intervalAngle)));
            make.centerY.mas_equalTo(AnnulusCenterRadii * sinf(DEGREES_TO_RADIANS(_startAngle + i * intervalAngle)));
        }];
        [self.dotViewArray addObject:dotView];
    }
}

- (void)setIntervalDials:(NSArray<NSString *> *)intervalDials {
    _intervalDials = intervalDials;
    
    [self prepareSelfForNewSubviewsWithArray:self.intervalDialLabelArray];
    
    // 创建新的label
    // 假设含有分割点，总弧度均分intervalDials.count份，设置label弧度时再加intervalAngle / 2
    CGFloat intervalAngle = self.totalAngle / (intervalDials.count);
    for (int i = 0; i < intervalDials.count; i++) {
        [self.intervalDialLabelArray addObject:[self createDialLabelWithTitle:intervalDials[i] angle:_startAngle + i * intervalAngle + intervalAngle / 2]];
    }
}

- (void)setDotDials:(NSArray<NSString *> *)dotDials {
    _dotDials = dotDials;
    
    [self prepareSelfForNewSubviewsWithArray:self.dotDialLabelArray];
    
    // 创建新的label
    CGFloat intervalAngle = self.totalAngle / (dotDials.count - 1);
    for (int i = 0; i < dotDials.count; i++) {
        [self.intervalDialLabelArray addObject:[self createDialLabelWithTitle:dotDials[i] angle:_startAngle + i * intervalAngle]];
    }
}

/// 移除原来view并布局父视图
- (void)prepareSelfForNewSubviewsWithArray:(NSMutableArray *)targetArray {
    // 移除原来view
    for (UIView *view in targetArray) {
        [view removeFromSuperview];
    }
    [targetArray removeAllObjects];
    
    // 父视图布局，以获取圆环半径
    [self.superview layoutIfNeeded];
}

/// 创建刻度label
- (UILabel *)createDialLabelWithTitle:(NSString *)title angle:(CGFloat)angle {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = UIColor.darkTextColor;
    label.font = kFontSize(14);
    label.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(angle) + M_PI_2);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo((AnnulusCenterRadii + 25) * cosf(DEGREES_TO_RADIANS(angle)));
        make.centerY.mas_equalTo((AnnulusCenterRadii + 25) * sinf(DEGREES_TO_RADIANS(angle)));
    }];
    return label;
}

#pragma mark - getter方法 -

- (CGFloat)totalAngle {
    return _endAngle - _startAngle;
}

- (NSMutableArray *)dotViewArray {
    if (!_dotViewArray) {
        _dotViewArray = [NSMutableArray array];
    }
    return _dotViewArray;
}

- (NSMutableArray *)intervalDialLabelArray {
    if (!_intervalDialLabelArray) {
        _intervalDialLabelArray = [NSMutableArray array];
    }
    return _intervalDialLabelArray;
}

- (NSMutableArray *)dotDialLabelArray {
    if (!_dotDialLabelArray) {
        _dotDialLabelArray = [NSMutableArray array];
    }
    return _dotDialLabelArray;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [self createDefaultTitleValueLabel];
        [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.7);
        }];
    }
    return _valueLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self createDefaultTitleValueLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(1.35);
        }];
    }
    return _titleLabel;
}

- (UILabel *)createDefaultTitleValueLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor.darkTextColor;
    [self addSubview:label];
    return label;
}

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] initWithImage:kImg(@"loadingRound")];
        [self addSubview:_loadingImageView];
        [_loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self.valueLabel);
            make.width.height.mas_equalTo(50 * ScreenWidthRatio);
        }];
    }
    return _loadingImageView;
}

@end
