//
//  PagerViewController.m
//  TYPagerControllerUpdateDemo
//
//  Created by FCN2021 on 2022/11/11.
//

#import "PagerViewController.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "PagerSubcontroller.h"


static NSString * const pageViewReuseIdentifier = @"pageViewReuseIdentifier";

#define TabBarHeight (25)
#define PageViewToTabBarSpace (15)

@interface PagerViewController () <TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource, TYPagerControllerDelegate>

@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSMutableArray *tabBarTitleArray;
@property (nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation PagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tabBarTitleArray = [NSMutableArray arrayWithArray:@[
        @"史蒂夫",
//        @"a",
        @"等",
        @"史蒂夫史蒂夫闻风丧胆服务",
        @"史蒂夫色",
        @"史蒂夫",
//        @"a",
//        @"等",
//        @"史蒂夫史蒂夫闻风丧胆服务",
//        @"史蒂夫色",
//        @"史蒂夫",
//        @"a",
//        @"等",
//        @"史蒂夫史蒂夫闻风丧胆服务",
//        @"史蒂夫色",
//        @"史蒂夫",
//        @"a",
//        @"等",
//        @"史蒂夫史蒂夫闻风丧胆服务",
//        @"史蒂夫色",
    ]];
    _contentArray = [NSMutableArray arrayWithArray:@[
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",@"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
        @"d",
    ]];
    
    _tabBar = [[TYTabPagerBar alloc] init];
    _tabBar.layout.progressColor = UIColor.blueColor;
    _tabBar.layout.selectedTextColor = UIColor.systemRedColor;
    _tabBar.layout.normalTextColor = UIColor.blackColor;
    _tabBar.layout.normalTextFont = [UIFont systemFontOfSize:14];
    _tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:16];
    _tabBar.layout.progressWidth = 0;
    _tabBar.layout.cellSpacing = 10;
    _tabBar.layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _tabBar.dataSource = self;
    _tabBar.delegate = self;
    [_tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:_tabBar];
    [_tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.height.mas_equalTo(_tabBarTitleArray.count <= 1 ? 0 : TabBarHeight);
    }];
    
    _pagerController = [[TYPagerController alloc] init];
    _pagerController.layout.prefetchItemCount = 1;
    _pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    _pagerController.delegate = self;
    _pagerController.dataSource = self;
    [self addChildViewController:_pagerController];
    [self.view addSubview:_pagerController.view];
    [_pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_tabBar.mas_bottom);
    }];
    [self reloadData];
    
}


#pragma mark - TYTabPagerBarDataSource -

- (NSInteger)numberOfItemsInPagerTabBar {
    return _tabBarTitleArray.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _tabBarTitleArray[index];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate -

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _tabBarTitleArray[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return _tabBarTitleArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    PagerSubcontroller *subcontroller = [[PagerSubcontroller alloc] init];
    return subcontroller;
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    if (_tabBarTitleArray.count == 2) {
        _tabBar.layout.barStyle = TYPagerBarStyleCoverView;
        _tabBar.layout.progressRadius = 0.1;
        _tabBar.layout.cellWidth = (SCREEN_WIDTH - 80) / 2;
    } else {
        _tabBar.layout.barStyle = TYPagerBarStyleProgressBounceView;
        _tabBar.layout.cellWidth = 0;
        _tabBar.layout.progressRadius = 0;
    }
    [_tabBar reloadData];
    [_pagerController reloadData];
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
