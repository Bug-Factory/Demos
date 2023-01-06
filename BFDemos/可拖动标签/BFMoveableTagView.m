
#import "BFMoveableTagView.h"

static NSString * const collectionCellIdentifier = @"collectionCellIdentifier";
static NSString * const collectionHeaderReuseIdentifier = @"collectionHeaderReuseIdentifier";
static NSString * const rotationAnimationKey = @"rotationAnimationKey";

#define DefaultTextFont kFontSize(14)

#define HorizontalMargin (16 * ScreenWidthRatio)
#define CellTextHorizontaltMargin (8 * ScreenWidthRatio)
//CGFloat CellTextHorizontaltMargin = 8;

/// 编辑状态
typedef enum : NSUInteger {
    /// 正常状态
    MoveableTagStateNormal,
    /// 编辑状态
    MoveableTagStateEditing
} MoveableTagState;

@interface BFMoveableTagView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 编辑状态
@property (nonatomic, assign) MoveableTagState editState;

@end

@implementation BFMoveableTagView

- (instancetype)init {
    if (self = [super init]) {
        [self initiateSelfWithData:nil];
    }
    return self ;
}

- (instancetype)initWithDataSource:(NSArray *)dataSource {
    if (self = [super init]) {
        [self initiateSelfWithData:dataSource];
    }
    return self ;
}

- (void)initiateSelfWithData:(NSArray *)dataSource {
    
    self.itemAdditionalHeight = 20;
    
    self.dataArray = [NSMutableArray arrayWithArray:dataSource];
    _data = dataSource;
    
    // CollectionView
    _collectionViewFlowLayout = [[BFEqualSpaceCollectionViewFlowLayout alloc] init];
//    _collectionViewFlowLayout.sectionHeadersPinToVisibleBounds = YES;
    _collectionViewFlowLayout.cellSpacing = 9 * ScreenWidthRatio;
    _collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, HorizontalMargin, 0, HorizontalMargin);
    _collectionViewFlowLayout.cellsAlignment = BFEqualSpaceCollectionCellsAlignmentLeft;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:_collectionViewFlowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = UIColor.clearColor;
    [_collectionView registerClass:[BFMoveableTagCollectionViewCell class] forCellWithReuseIdentifier:collectionCellIdentifier];
    [_collectionView registerClass:[BFMoveableTagCollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderReuseIdentifier];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)insertItemAtFirst:(NSString *)item {
    [self.dataArray removeObject:item];
    [self.dataArray insertObject:item atIndex:0];
    [self.collectionView reloadData];
}

- (void)removeLastItem {
    [self.dataArray removeLastObject];
    [self.collectionView reloadData];
}

- (void)setData:(NSArray<NSString *> *)data {
    _data = data;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:data];
    [self.collectionView reloadData];
}

- (void)setItemBackgroundColor:(UIColor *)itemBackgroundColor {
    _itemBackgroundColor = itemBackgroundColor;
    [self.collectionView reloadData];
}

- (void)setItemTextColor:(UIColor *)itemTextColor {
    _itemTextColor = itemTextColor;
    [self.collectionView reloadData];
}

- (void)setItemCornerRadius:(CGFloat)itemCornerRadius {
    _itemCornerRadius = itemCornerRadius;
    [self.collectionView reloadData];
}

- (void)setCollectionCellsAlignment:(BFEqualSpaceCollectionCellsAlignment)collectionCellsAlignment {
    _collectionCellsAlignment = collectionCellsAlignment;
    _collectionViewFlowLayout.cellsAlignment = collectionCellsAlignment;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate FlowLayout -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf
    BFMoveableTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    NSString *contentString = self.dataArray[indexPath.row];
    cell.titleLabel.text = contentString;
    cell.cellBackgroundColor = self.itemBackgroundColor ? : UIColor.whiteColor;
    if (self.itemTextColor) {
        cell.titleLabel.textColor = self.itemTextColor;
    }
    if (self.itemCornerRadius) {
        cell.layer.cornerRadius = self.itemCornerRadius;
    }
    
    [self checkCellEditingState:cell];
    //删除点击事件
    cell.deleteButtonDidClick = ^{
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        if (weakSelf.dataArray.count == 0 && weakSelf.editState == MoveableTagStateEditing) {
            weakSelf.editState = MoveableTagStateNormal;
        }
        [weakSelf.collectionView reloadData];
        if (weakSelf.didRemoveItem) {
            weakSelf.didRemoveItem(indexPath.row);
        }
    };
    
    [cell setNeedsDisplay];
    
    if (self.allowSinglyRemove && !cell.longPressActionBlock) {
        cell.longPressActionBlock = ^{
            weakSelf.editState = MoveableTagStateEditing;
            [weakSelf.collectionView reloadData];
        };
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *contentString = self.dataArray[indexPath.row];
    
    NSStringDrawingOptions stringDrawingOptions = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *stringAttributes = @{NSFontAttributeName : DefaultTextFont};
    
    //有时候计算不准确，导致label字符串...
    CGFloat width = [contentString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:stringDrawingOptions attributes:stringAttributes context:nil].size.width + 1;
    
    CGFloat maxWidth = collectionView.frame.size.width - (HorizontalMargin + CellTextHorizontaltMargin) * 2;
    if (width > maxWidth) {
        width = maxWidth;
    }
    CGFloat height = [contentString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:stringDrawingOptions attributes:stringAttributes context:nil].size.height + self.itemAdditionalHeight;
    
    return CGSizeMake(width + CellTextHorizontaltMargin * 2, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BFMoveableTagCollectionReusableHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderReuseIdentifier forIndexPath:indexPath];
        headerView.editButton.hidden = !self.isEditing;
        headerView.headerLabel.text = @"历史搜索";
        [self cheakIsEditorState:headerView];
        headerView.editButtonDidClick = ^(UIButton * _Nonnull button) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.collectionView reloadData];
            if (weakSelf.didRemoveAll) {
                weakSelf.didRemoveAll();
            }
        };
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (self.titleSectionHeight == 0) {
        height = 40;
    }else if (self.titleSectionHeight > 0) {
        height = self.titleSectionHeight;
    }
    return  CGSizeMake(collectionView.frame.size.width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BFMoveableTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    
    [self setLayerSpeedOnCell:cell];
    self.editState = MoveableTagStateNormal;
    [self.collectionView reloadData];
    
    if (_didClickItem) {
        _didClickItem(indexPath.row, self.dataArray[indexPath.row]);
    }
}

/// 判断是否是编辑状态
- (void)cheakIsEditorState:(BFMoveableTagCollectionReusableHeaderView *)headerView {
    switch (self.editState) {
        case MoveableTagStateNormal: {
            headerView.editButton.selected = NO;
        }
            break;
            
        case MoveableTagStateEditing: {
            headerView.editButton.selected = YES;
        }
            break;
            
        default:
            break;
    }
    headerView.editButton.hidden = !self.isEditing ;
}

/// 是否显示删除按钮
- (void)checkCellEditingState:(BFMoveableTagCollectionViewCell *)cell {
    switch (self.editState) {
        case MoveableTagStateNormal: {
            cell.deleteButton.hidden = YES ;
            [self setLayerSpeedOnCell:cell];
        }
            break;
            
        case MoveableTagStateEditing: {
            cell.deleteButton.hidden = NO ;
            [self startShakingWithCell:cell];
        }
            break;
            
        default:
            break;
    }
}

/// 开始抖动
- (void)startShakingWithCell:(BFMoveableTagCollectionViewCell*)cell {
    CABasicAnimation *animation = (CABasicAnimation *)[cell.layer animationForKey:rotationAnimationKey];
    if (animation == nil) {
        [self shakeCell:cell];
    }else {
        [self setLayerSpeedOnCell:cell];
    }
}

- (void)setLayerSpeedOnCell:(BFMoveableTagCollectionViewCell *)cell {
    cell.layer.speed = 1;
}


- (void)shakeCell:(BFMoveableTagCollectionViewCell *)cell {
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置属性，周期时长
    [animation setDuration:0.08];
    
    if (cell.size.width > SCREEN_WIDTH / 2) {
        //抖动角度
        animation.fromValue = @(-M_1_PI / 30);
        animation.toValue = @(M_1_PI / 30);
    }else{
        //抖动角度
        animation.fromValue = @(-M_1_PI / 6);
        animation.toValue = @(M_1_PI / 6);
    }
    
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [cell.layer addAnimation:animation forKey:rotationAnimationKey];
}

@end

#pragma mark - ****************BFEqualSpaceCollectionViewFlowLayout**************** -

@interface BFEqualSpaceCollectionViewFlowLayout()

/// 居中对齐的时候，cell所有的宽度 ，好算间隙
@property (nonatomic, assign) CGFloat sumWidth;

@end

@implementation BFEqualSpaceCollectionViewFlowLayout


- (instancetype)init {
    
    if (self = [super init]) {
        //默认上下垂直滑动
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 5; //左右默认距离
        self.minimumInteritemSpacing = 5; // 上下默认距离
        self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _cellSpacing = 5.0; //默认cell距离
        _cellsAlignment = BFEqualSpaceCollectionCellsAlignmentCenter; //默认居中
    }
    return self;
}

- (void)setCellSpacing:(CGFloat)cellSpacing {
    
    _cellSpacing = cellSpacing ;
    self.minimumInteritemSpacing = cellSpacing;
    self.minimumLineSpacing = cellSpacing ;
}

//返回所有cell的布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *layoutAttributes = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    // if 是居中显示，那么直接返回系统的布局
    if (_cellsAlignment == BFEqualSpaceCollectionCellsAlignmentCenter) {
        return layoutAttributes;
    }
    
    //用来临时存放一行的Cell数组
    NSMutableArray *layoutAttributesTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < layoutAttributes.count; i ++) {
        
        // 当前cell的位置信息
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[i];
        
        // 上一个cell 的位置信
        UICollectionViewLayoutAttributes *previousAttr = i == 0 ? nil : layoutAttributes[i - 1];
        
        //下一个cell 位置信息
        UICollectionViewLayoutAttributes *nextAttr = i + 1 == layoutAttributes.count ?
        nil : layoutAttributes[i + 1];
        
        //加入临时数组
        [layoutAttributesTemp addObject:currentAttr];
        _sumWidth += currentAttr.frame.size.width;
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        //如果当前cell是单独一行
        if (currentY != previousY && currentY != nextY) {
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
                _sumWidth = 0.0;
            }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
                [layoutAttributesTemp removeAllObjects];
                _sumWidth = 0.0;
            }else {
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }else if ( currentY != nextY) {
            //如果下一个cell在本行，开始调整Frame位置
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}

//这调整Frame位置
- (void)setCellFrameWith:(NSMutableArray*)layoutAttributes {
    CGFloat nowWidth = 0.0;
    switch (_cellsAlignment) {
        case BFEqualSpaceCollectionCellsAlignmentLeft: {
            nowWidth = self.sectionInset.left;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + self.cellSpacing;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
        }
            break;
        case BFEqualSpaceCollectionCellsAlignmentCenter: {
            nowWidth = (self.collectionView.frame.size.width - _sumWidth - ((layoutAttributes.count - 1) * _cellSpacing)) / 2;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + self.cellSpacing;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
        }
            break;
            
        case BFEqualSpaceCollectionCellsAlignmentRight: {
            nowWidth = self.collectionView.frame.size.width - self.sectionInset.right;
            for (NSInteger index = layoutAttributes.count - 1 ; index >= 0 ; index-- ) {
                UICollectionViewLayoutAttributes * attributes = layoutAttributes[index];
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth - nowFrame.size.width;
                attributes.frame = nowFrame;
                nowWidth = nowWidth - nowFrame.size.width - _cellSpacing;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
        }
            break;
    }
}

@end


#pragma mark - ****************BFMoveableTagCollectionViewCell**************** -

@implementation BFMoveableTagCollectionViewCell {
    UIView *_backgroundView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
        [self initiateSubviews];
    }
    return self;
}

- (void)initiateSubviews {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)];
    [self addGestureRecognizer:longPress];
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:_backgroundView];
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = RGB(51, 51, 51);
    _titleLabel.font = DefaultTextFont;
    _titleLabel.numberOfLines = 0;
    [_backgroundView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CellTextHorizontaltMargin);
        make.right.mas_equalTo(-CellTextHorizontaltMargin);
        make.centerY.mas_equalTo(0);
    }];
    
    _deleteButton = [[UIButton alloc] init];
    [_deleteButton setTitle:@"x" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_deleteButton];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
    }];
    _deleteButton.titleEdgeInsets = UIEdgeInsetsMake(-12, 10, 12, -10 );
}

- (void)deleteButtonClick {
    if (_deleteButtonDidClick) {
        _deleteButtonDidClick();
    }
}

- (void)longPressAction {
    if (_longPressActionBlock) {
        _longPressActionBlock();
    }
}

- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor {
    _cellBackgroundColor = cellBackgroundColor;
    _backgroundView.backgroundColor = cellBackgroundColor;
}


//- (void)drawRect:(CGRect)rect {
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    //    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
//
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5];  //打开这个就是个圆弧矩形
//    CGContextAddPath(ctx, path.CGPath);
//
//    UIColor *color;
//    color = self.cellBackgroundColor ? self.cellBackgroundColor : [UIColor whiteColor];
//
//    //    CGContextStrokePath(ctx);
//    [color setFill];
//
//    CGContextDrawPath(ctx, kCGPathFill); //填充
//    UIGraphicsEndImageContext(); //关闭上下文
//}

@end


#pragma mark - ****************BFMoveableTagCollectionReusableHeaderView**************** -


@implementation BFMoveableTagCollectionReusableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initiateSubviews];
    }
    return self;
}

- (void)initiateSubviews {
    _headerLabel = [[UILabel alloc] init];
    _headerLabel.font = kBoldFontSize(14);
    _headerLabel.textColor = UIColor.darkTextColor;
    [self addSubview:_headerLabel];
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HorizontalMargin);
        make.centerY.mas_equalTo(0);
    }];
    
    _editButton = [[UIButton alloc] init];
    [_editButton setImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_editButton];
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-HorizontalMargin);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(24);
    }];
}

- (void)editButtonClick:(UIButton *)button {
    if (_editButtonDidClick) {
        _editButtonDidClick(button);
    }
}


@end
