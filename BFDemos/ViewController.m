//
//  ViewController.m
//  BFDemos
//
//  Created by FCN2021 on 2022/12/21.
//

#import "ViewController.h"
#import "PagerViewController.h"
#import "BFGaugeViewTestViewController.h"

@interface ControllerModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *controllerName;

- (instancetype)initWithControllerName:(NSString *)controllerName title:(NSString *)title;
@end

@implementation ControllerModel

- (instancetype)initWithControllerName:(NSString *)controllerName title:(NSString *)title {
    if (self = [super init]) {
        _title = title;
        _controllerName = controllerName;
    }
    return self;
}

@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _controllers = @[
        [[ControllerModel alloc] initWithControllerName:NSStringFromClass(PagerViewController.class) title:@"分页TYPagerController"],
        [[ControllerModel alloc] initWithControllerName:NSStringFromClass(BFGaugeViewTestViewController.class) title:@"圆形带刻度进度条"],
    ];
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        make.left.right.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _controllers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 * ScreenHeightRatio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    ControllerModel *model = _controllers[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ControllerModel *model = _controllers[indexPath.row];
    Class targetClass = NSClassFromString(model.controllerName);
    UIViewController *viewController = [[targetClass alloc] init];
    viewController.title = model.title;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end

