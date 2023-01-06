

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ****************BFEqualSpaceCollectionViewFlowLayout**************** -

/// cells布局（左、中、右）
typedef enum : NSUInteger {
    /// 居左
    BFEqualSpaceCollectionCellsAlignmentLeft,
    /// 居中
    BFEqualSpaceCollectionCellsAlignmentCenter,
    /// 居右
    BFEqualSpaceCollectionCellsAlignmentRight,
} BFEqualSpaceCollectionCellsAlignment;

@interface BFEqualSpaceCollectionViewFlowLayout : UICollectionViewFlowLayout

/// 每个cell 的对齐方式
@property (nonatomic, assign) BFEqualSpaceCollectionCellsAlignment cellsAlignment ;

/// 两个Cell之间的距离
@property (nonatomic, assign) CGFloat cellSpacing;

@end


#pragma mark - ****************BFMoveableTagView**************** -

@interface BFMoveableTagView : UIView

- (instancetype)initWithDataSource:(NSArray *)dataSource;

@property (nonatomic, strong) BFEqualSpaceCollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong) UICollectionView *collectionView;

/// 数据
@property (nonatomic, strong) NSArray <NSString *> *data;

/// 标题
@property (nonatomic, strong) NSString *headTitle;

/// 编辑状态 默认NO
@property (nonatomic,assign) BOOL isEditing;

/// 标题高度 默认 40(小于0 隐藏header)
@property (nonatomic,assign) CGFloat titleSectionHeight;

/// 每个选项的除文字高度外额外增加的高度，默认20
@property (nonatomic,assign) CGFloat itemAdditionalHeight;

/// 每个选项的除文字宽度外额外增加的宽度，默认(8 * GetScreenWidthRatio)
@property (nonatomic,assign) CGFloat itemHorizontalMargin;

/// 每个选项的背景色
@property (nonatomic, strong) UIColor *itemBackgroundColor;

/// 每个选项的字体颜色
@property (nonatomic, strong) UIColor *itemTextColor;

/// 每个选项的圆角
@property (nonatomic, assign) CGFloat itemCornerRadius;

/// item排列（居左、居中、居右）
@property (nonatomic, assign) BFEqualSpaceCollectionCellsAlignment collectionCellsAlignment;

/// 是否允许单个删除
@property (nonatomic, assign) BOOL allowSinglyRemove;

/// 删除所有记录
@property (nonatomic, copy) void (^ didRemoveAll)(void);

/// 删除单个记录
@property (nonatomic, copy) void (^ didRemoveItem)(NSUInteger index);

/// 点击item
@property (nonatomic, copy) void (^ didClickItem)(NSUInteger index, NSString *itemContent);

/// 插入某个选项
/// @param item 字符串
- (void)insertItemAtFirst:(NSString * _Nullable)item;

/// 删除最后一个选项
- (void)removeLastItem;

@end


#pragma mark - ****************BFMoveableTagCollectionViewCell**************** -

@interface BFMoveableTagCollectionViewCell : UICollectionViewCell

/// 内容
@property (nonatomic, strong) UILabel *titleLabel;

/// 删除按钮
@property (nonatomic, strong) UIButton *deleteButton;

/// 背景颜色
@property (nonatomic, strong) UIColor *cellBackgroundColor;

/// 点击删除按钮事件
@property (nonatomic, copy) void (^ deleteButtonDidClick)(void);

/// 长按cell事件
@property (nonatomic, copy) void (^ longPressActionBlock)(void);

@end


#pragma mark - ****************BFMoveableTagCollectionReusableHeaderView**************** -

@interface BFMoveableTagCollectionReusableHeaderView : UICollectionReusableView

/// 标题
@property (nonatomic, strong) UILabel *headerLabel;

/// 编辑按钮
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, copy) void (^ editButtonDidClick)(UIButton *button);


@end


NS_ASSUME_NONNULL_END
