//
//  ViewController.m
//  BFDemos
//
//  Created by FCN2021 on 2022/12/21.
//

#import "ViewController.h"
//#import "PagerViewController.h"

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

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    _dataArray = @[@"PagerViewController"];
    
    self.view.backgroundColor = UIColor.redColor;
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow.safeAreaInsets);
    }];
}

@end

