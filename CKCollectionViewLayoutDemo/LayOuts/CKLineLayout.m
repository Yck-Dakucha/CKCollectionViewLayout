//
//  CKLineLayout.m
//  CKCollectionViewLayoutDemo
//
//  Created by Yck on 16/3/10.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKLineLayout.h"
@interface CKLineLayout ()

@property (nonatomic, assign) BOOL    isLayout;
@property (nonatomic, assign) BOOL    isPageEnabled;
@property (nonatomic, assign) CGFloat move_x;

@end

@implementation CKLineLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.move_x             = 0;
        self.scrollDirection    = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}
/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 * 1.prepareLayout --> 用来做布局的初始化操作
 * 2.layoutAttributesForElementsInRect:
 */
- (void)prepareLayout {
    [super prepareLayout];
    if (!self.isLayout) {
        CGFloat inset           = self.collectionView.frame.size.width * 0.5 - self.itemSize.width * 0.5;//这样设置是为了第一个及最后一个视图在collectionView的中间位置
        self.sectionInset       = UIEdgeInsetsMake(0, inset, 0, inset);//section的偏移量（上左下右）
        self.minimumLineSpacing = 10;
        self.isLayout = YES;
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
/**
 *  返回布局属性,设置缩放
 *
 *  @param rect 显示的区域
 *
 *  @return 布局属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //先取出系统已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    //计算collectionView最中心点的X坐标,这里的中心店需加上偏移量
    CGFloat centerX = self.collectionView.frame.size.width * 0.5 + self.collectionView.contentOffset.x;
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        //原cell的中心与要显示的中心及collectionView的最中心点之间的距离
        CGFloat spacing = ABS(centerX - attributes.center.x);
        //根据间距算出缩放的比例
        CGFloat scale = 1 - spacing/self.collectionView.frame.size.width;
        //设置缩放
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}


#pragma mark -  设置单页翻页效果
- (void)ck_setPageingEnable:(BOOL)isPagingEnabled {
    _isPageEnabled = isPagingEnabled;
}
#pragma mark -  设置需要停留的位置
/**
 *  它的返回值，就决定了collectionView停止滚动时的偏移量,这个方法在你手离开屏幕之前会调用，也就是cell即将停止滚动的时候
 *  这个方法返回的参数(CGPoint)proposedContentOffset，这是它本应该停留的位置，最终停留的的值。而
 *  (CGPoint)targetContentOffsetForProposedContentOffset:
 *  这个是你最终返回的值，也就是你要它停留到哪儿的值（这个参数决定你要cell最后停留在哪儿）
 *
 *  @param proposedContentOffset 本应该停留的位置
 *  @param velocity
 *
 *  @return 决定你要cell最后停留在哪儿
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    proposedContentOffset.y = 0;
    if (_isPageEnabled) {
        proposedContentOffset.x = [self ck_pageEnabledMove:proposedContentOffset];
    }else {
        proposedContentOffset.x = [self ck_currentMove:proposedContentOffset];
    }
    
    return proposedContentOffset;
}
/**
 *  它的返回值决定了视图刷新后或者初始化后将要显示的位置，这里用来设置在切换后再切换回来仍然记录刚才位置
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    proposedContentOffset.x = self.move_x;
    return proposedContentOffset;
}
#pragma mark -  单页翻页效果
- (CGFloat)ck_pageEnabledMove:(CGPoint)proposedContentOffset {
    CGFloat set_x = proposedContentOffset.x;
    if (set_x > _move_x) {
        _move_x += self.itemSize.width + self.minimumLineSpacing;
    }else if (set_x < _move_x){
        _move_x -= self.itemSize.width + self.minimumLineSpacing;
    }
    set_x = _move_x;
//    NSLog(@"set_x >>>>> %f",set_x);
    return set_x;
}
#pragma mark -  默认翻页效果
- (CGFloat)ck_currentMove:(CGPoint)proposedContentOffset {
    //最终显示的区域
    CGRect lastRect;
    lastRect.origin.x = proposedContentOffset.x;
    lastRect.origin.y = 0;
    lastRect.size = self.collectionView.frame.size;
    
    //获取Super计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:lastRect];
    //计算collectionView最中心点的X坐标,这里的中心店需加上偏移量
    CGFloat centerX = self.collectionView.frame.size.width * 0.5 + proposedContentOffset.x;
    //存放最小的间距值
    CGFloat minSpacing = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (ABS(minSpacing) > ABS(attributes.center.x - centerX)) {
            minSpacing = attributes.center.x - centerX;
        }
    }
    proposedContentOffset.x += minSpacing;
    _move_x = proposedContentOffset.x;
    return _move_x;
}

@end
