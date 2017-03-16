//
//  BBTagManager.m
//  标签管理
//
//  Created by 项羽 on 17/1/9.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import "BBTagManager.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "BBTagCell.h"
#import "BBTagHeaderReusableView.h"

#define BTMWeakObj(o) __weak typeof(o) weak##o = o;

@interface BBTagManager()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateLeftAlignedLayout>
{
    NSIndexPath *_currentIndexPath;
    CGSize _snapSize;//保存截图的大小
    UIImageView *_snapedImageView;
}

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)CollectionCellViewStatus editCellStatus;
@property (nonatomic,assign)CollectionHeaderViewStatus editHeaderStatus;

@end

static NSString *reuseID = @"BBTagCell";
static NSString *headerID = @"BBTagHeaderReusableView";
@implementation BBTagManager

-(instancetype)initWithDataSource:(NSMutableArray<NSArray *> *)datas selectedIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        
        self.dataSource = datas;
        if (index >= 0) {
            _highlightedIndex = index;
        }else
        {
            _highlightedIndex = 0;
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self setupUI];
}


-(void)setupUI
{
    self.editCellStatus = CollectionCellViewStatusDefault;//默认状态
    self.editHeaderStatus = CollectionHeaderViewStatusDefault;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    CGSize sSize = scrollView.frame.size;
    sSize.height +=10;
    scrollView.contentSize = sSize;
    [self addSubview:scrollView];
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(100, 50);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1.0f];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //此处给其增加长按手势，用此手势触发cell移动效果
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    longGesture.minimumPressDuration = 0.25;
    [_collectionView addGestureRecognizer:longGesture];
    [scrollView addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"BBTagCell" bundle:nil] forCellWithReuseIdentifier:reuseID];
    [_collectionView registerNib:[UINib nibWithNibName:@"BBTagHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
}

             
#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    NSArray *tempArray = self.dataSource[section];
    return tempArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    BBTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    if (indexPath.section == 0) {//只有第一组显示关闭按钮
        cell.editStatus = self.editCellStatus;
    }else{
        cell.editStatus = CollectionCellViewStatusDefault;
    }
    
    if (indexPath.section == 0 && indexPath.item == 0) {
        cell.closeBtn.hidden = YES;
    }
    
    NSArray *tempArray = self.dataSource[indexPath.section];
    cell.tagTitle.text = tempArray[indexPath.item];
    return  cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        BBTagHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
        headerView.editStatus = self.editHeaderStatus;
        headerView.statusLabel.hidden = indexPath.section == 0 ? NO : YES;
        headerView.editBtn.hidden = indexPath.section == 0 ? NO : YES;
        BTMWeakObj(self)
        if (indexPath.section == 0) {
            headerView.editBtnClickHandler = ^(UIButton *eBtn){
                
                eBtn.selected = !eBtn.selected;
                if (eBtn.selected) {
                    weakself.editCellStatus = CollectionCellViewStatusEditing;
                    weakself.editHeaderStatus = CollectionHeaderViewStatusEditing;
                    [weakself.collectionView reloadData];
                }else{
                    weakself.editCellStatus = CollectionCellViewStatusDefault;
                    weakself.editHeaderStatus = CollectionHeaderViewStatusDefault;
                    [weakself.collectionView reloadData];
                }
            };
        }
        
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *title = self.dataSource[indexPath.section][indexPath.item];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0f]
                                 };
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGSize tempSize = size;
    tempSize.width += 23;
    tempSize.height += 16;
    size = tempSize;
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(10, 17, 10, 17);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 5;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    switch (self.editHeaderStatus) {
        case CollectionHeaderViewStatusDefault:
        {
            if (indexPath.section == 1) {
                [self moveItemForEditingWithIndexPath:indexPath];
            }else if (indexPath.section == 0){
                //dismiss
                if ([self.delegate respondsToSelector:@selector(BBTagManager:finishEditingDataSource:)]) {
                    [self.delegate BBTagManager:self finishEditingDataSource:self.dataSource];
                }
            }
        }
            break;
        case CollectionHeaderViewStatusEditing:
        {
            //编辑状态下第一个item不变
            if (indexPath.section == 0 && indexPath.item == 0) {return;}
            [self moveItemForEditingWithIndexPath:indexPath];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - my Method

-(void)moveItemForEditingWithIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *toIndexPath;
    if (indexPath.section == 0) {
        toIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    }else if (indexPath.section == 1){
        NSMutableArray *toSection = self.dataSource[0];
        toIndexPath = [NSIndexPath indexPathForItem:toSection.count inSection:0];
    }
    [self moveItemWithOldIndexPath:indexPath toIndexPath:toIndexPath];
    [self.collectionView reloadItemsAtIndexPaths:@[toIndexPath]];
}

//长按手势移动
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture
{
    //1 获取当前手势的位置
    CGPoint location = [longGesture locationInView:self.collectionView];
    //2 获取这个位置对应的在collectionView中的indexPath, 注意这个indexPath可能为nil(比如手指没有在cell的位置上时)
    NSIndexPath *locationIndexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (locationIndexPath.section == 0 && locationIndexPath.item == 0) {
        if (!_currentIndexPath) {//说明直接点得第一个item
            return;
        }else{//不是点得第一个item（在滑动过程中不让第一个item参与编辑）
            locationIndexPath = _currentIndexPath;
        }
    }
    //3 通过当前手势的状态不同的处理
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:
        {//给item截图放大并隐藏
            if (locationIndexPath) {
                _currentIndexPath = locationIndexPath;
                BBTagCell *cell = (BBTagCell *)[self.collectionView cellForItemAtIndexPath:locationIndexPath];
                _snapedImageView = [self getTheCellSnap:cell];
                //设置截图的大小, 以达到和手指同步移动
                _snapSize = CGSizeMake(location.x - cell.frame.origin.x, location.y - cell.frame.origin.y);
                _snapedImageView.center = cell.center;
                _snapedImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                cell.alpha = 0.0;
                [self.collectionView addSubview:_snapedImageView];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (_snapedImageView == nil) {return;}
            //让截图跟随手指的位置
            CGRect frame = _snapedImageView.frame;
            frame.origin.x = location.x - _snapSize.width;
            frame.origin.y = location.y - _snapSize.height;
            _snapedImageView.frame = frame;
            NSIndexPath *oldIndexPath = _currentIndexPath;
            NSIndexPath *toIndexPath = locationIndexPath;
            //第一个item不参与改变
            if (toIndexPath.section == 0 && toIndexPath.item == 0) {
                toIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            }
            if (toIndexPath == nil) {return;}
            
            if (toIndexPath != oldIndexPath) {
                
                [self moveItemWithOldIndexPath:oldIndexPath toIndexPath:toIndexPath];
                BBTagCell *cell = (BBTagCell *)[self.collectionView cellForItemAtIndexPath:toIndexPath];
                cell.alpha = 0.0;
                _currentIndexPath = toIndexPath;
                
            }
            
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            NSIndexPath *oldIndexPath = _currentIndexPath;
            BBTagCell *cell = (BBTagCell *)[self.collectionView cellForItemAtIndexPath:oldIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                _snapedImageView.transform = CGAffineTransformIdentity;
                _snapedImageView.frame = cell.frame;
            } completion:^(BOOL finished) {
                [_snapedImageView removeFromSuperview];
                _snapedImageView = nil;
                _currentIndexPath = nil;
                cell.alpha = 1.0;
                [self.collectionView reloadData];
            }];
            
        }
            break;
            
        default:
            break;
    }
    
}

//移动item
-(void)moveItemWithOldIndexPath:(NSIndexPath *)oldIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //将嵌套数组中得数组转为NSMutableArray
    NSMutableArray *tempArray = self.dataSource;
    for (int i=0; i<tempArray.count; i++) {
        [tempArray replaceObjectAtIndex:i withObject:[tempArray[i] mutableCopy]];
    }
    
    if (toIndexPath.section == oldIndexPath.section) {//同一secton交换
        
        //先更新数据源
        NSMutableArray *orignalSection = tempArray[oldIndexPath.section];
        if (toIndexPath.item > oldIndexPath.item) {
            for (NSUInteger i = oldIndexPath.item; i < toIndexPath.item ; i ++) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
            }
        }else{
            for (NSUInteger i = oldIndexPath.item; i > toIndexPath.item ; i --) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
        }
        //再移动cell
        [self.collectionView moveItemAtIndexPath:oldIndexPath toIndexPath:toIndexPath];
        
    }
    if (toIndexPath.section != oldIndexPath.section) {//不同section交换
        
        NSMutableArray *oldSection = tempArray[oldIndexPath.section];
        NSMutableArray *toSection = tempArray[toIndexPath.section];
        [toSection insertObject:oldSection[oldIndexPath.item] atIndex:toIndexPath.item];
        [oldSection removeObjectAtIndex:oldIndexPath.item];
        [self.collectionView moveItemAtIndexPath:oldIndexPath toIndexPath:toIndexPath];
    }
    
    //    NSLog(@"------%@",self.dataSource);
}

//截图
-(UIImageView *)getTheCellSnap:(UIView *)targetView
{
    UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, false, 0.0);
    [targetView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *gottenImageView = [[UIImageView alloc] initWithImage:img];
    
    return gottenImageView;
}









@end
