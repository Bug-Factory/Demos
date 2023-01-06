

#import "PagerSubcontroller.h"
#import <Masonry.h>
#import "MacroConst.h"

@interface subcontrollerCollectionViewCell : UICollectionViewCell

@end

@implementation subcontrollerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:random() % 255 / 255.0 green:random() % 255 / 255.0 blue:random() % 255 / 255.0 alpha:random() % 9 / 10.0 + 0.1];
        self.layer.cornerRadius = 10;
//        self.layer.shadowColor = UIColor.redColor;
//        self.layer.shadowOffset = CGSizeMake(0,0);
//        self.layer.shadowOpacity = 1;
//        self.layer.shadowRadius = 4;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
}

@end



@interface PagerSubcontroller () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation PagerSubcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initiateSubviews];
}

- (void)initiateSubviews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(100, 112);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 16;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[subcontrollerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(subcontrollerCollectionViewCell.class)];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    subcontrollerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(subcontrollerCollectionViewCell.class) forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
