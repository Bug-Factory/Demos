//
//  UIButton+ButtonBlock.m
//  DKUHomeClient


#import "UIButton+AddButtonAction.h"

@implementation UIButton (AddButtonAction)

static char overviewKey;

- (void)addActionForControlEvents:(UIControlEvents)event actionBlock:(ButtonActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ButtonActionBlock block = (ButtonActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block(self);
    }
}


@end
