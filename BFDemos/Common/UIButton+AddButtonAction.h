//
//  UIButton+ButtonBlock.h
//  DKUHomeClient


#import <UIKit/UIKit.h>

#import <objc/runtime.h>

///回调类型
typedef void (^ButtonActionBlock)(UIButton *sender);

@interface UIButton (AddButtonAction)

///添加回调方法
- (void)addActionForControlEvents:(UIControlEvents)controlEvent actionBlock:(ButtonActionBlock)action;

@end
