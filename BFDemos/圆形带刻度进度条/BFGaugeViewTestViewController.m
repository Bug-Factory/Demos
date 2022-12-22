//
//  BFGaugeViewTestViewController.m
//  BFDemos
//
//  Created by FCN2021 on 2022/12/22.
//

#import "BFGaugeViewTestViewController.h"
#import "BFGaugeView.h"

@interface BFGaugeViewTestViewController ()

@end

@implementation BFGaugeViewTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BFGaugeView *signalGauge = [[BFGaugeView alloc] init];
    [self.view addSubview:signalGauge];
    [signalGauge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(200 * ScreenWidthRatio);
    }];
    signalGauge.intervalDials = @[@"极差", @"差", @"较差", @"一般", @"较好", @"好"];
    signalGauge.dotDials = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7"];
    signalGauge.numberOfDots = 7;
    signalGauge.valueLabel.font = kFontSize(24);
    signalGauge.valueLabel.text = @"--";
    signalGauge.titleLabel.text = @"强度";
    signalGauge.progressBarColor = UIColor.systemPurpleColor;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        signalGauge.progress = 0.3;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            signalGauge.progress = 0.8;
            signalGauge.progressBarColor = UIColor.systemGreenColor;
            signalGauge.valueLabel.text = @"100";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                signalGauge.progress = 0.1;
                signalGauge.progressBarColor = UIColor.systemGrayColor;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    signalGauge.progressAnimationStyle = ProgressAnimationStyleFromOrigin;
                    signalGauge.progress = 0.1;
                    signalGauge.progressBarColor = UIColor.systemGreenColor;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        signalGauge.progress = 0.9;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            signalGauge.progress = 0.4;
                        });
                    });
                });
            });
        });
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
