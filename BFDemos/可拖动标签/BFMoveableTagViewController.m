//
//  BFMoveableTagViewController.m
//  BFDemos
//
//  Created by FCN2021 on 2022/12/23.
//

#import "BFMoveableTagViewController.h"
#import "BFMoveableTagView.h"

@interface BFMoveableTagViewController ()

@end

@implementation BFMoveableTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BFMoveableTagView *moveableTagView = [[BFMoveableTagView alloc] init];
    
    
    moveableTagView.itemAdditionalHeight = 5;
    moveableTagView.itemBackgroundColor = UIColor.lightGrayColor;
    moveableTagView.itemTextColor = UIColor.lightTextColor;
    moveableTagView.itemCornerRadius = 8;
    moveableTagView.titleSectionHeight = 40;
    moveableTagView.collectionCellsAlignment = BFEqualSpaceCollectionCellsAlignmentLeft;
    moveableTagView.collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(40, 10, 0, 10);
    moveableTagView.allowSinglyRemove = YES;
    [self.view addSubview:moveableTagView];
    [moveableTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    moveableTagView.data = @[@"是对方", @"突然好", @"收到", @"俄方位粉丝问他问题", @"是", @"热个人高温范围为个人个地方很热", @"大噶都个人噶人😂", @"的", @"阿斯顿发哇俄方说法", @"而通过读书氛围", @"hello"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        moveableTagView.isEditing = YES;
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
