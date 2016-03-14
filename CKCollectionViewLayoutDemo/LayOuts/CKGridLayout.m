//
//  CKGridLayout.m
//  CKCollectionViewLayoutDemo
//
//  Created by Yck on 16/3/14.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKGridLayout.h"
@interface CKGridLayout()

@property (nonatomic, assign) CGFloat move_y;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;

@end

@implementation CKGridLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.move_y = 0;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self.attributesArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat width = self.collectionView.frame.size.width * 0.5;
        CGFloat height;
        CGFloat x;
        CGFloat y;
        switch (i) {
            case 0:
                x = 0;
                y = 0;
                height = width;
                attributes.frame = CGRectMake(x, y, width, height);
                break;
            case 1:
                x = width;
                y = 0;
                height = width * 0.5;
                attributes.frame = CGRectMake(x, y, width, height);
                break;
            case 2:
                x = width;
                y = width * 0.5;
                height = width * 0.5;
                attributes.frame = CGRectMake(x, y, width, height);
                break;
            case 3:
                x = 0;
                y = width;
                height = width * 0.5;
                attributes.frame = CGRectMake(x, y, width, height);
                break;
            case 4:
                x = 0;
                y = width * 1.5;
                height = width * 0.5;
                attributes.frame = CGRectMake(x, y, width, height);
                break;
            case 5:
                x = width;
                y = width;
                height = width;
                attributes.frame = CGRectMake(x, y, width, height);
                break;
            default:
            {
                UICollectionViewLayoutAttributes *att = self.attributesArray[i % 6];
                CGRect frame = att.frame;
                frame.origin.y += (i / 6) * 2 * width;
                attributes.frame = frame;
                break;
            }
        }
        [self.attributesArray addObject:attributes];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}
- (CGSize)collectionViewContentSize
{
    int count = (int)[self.collectionView numberOfItemsInSection:0];
    int rows = (count + 3 - 1) / 3;
    CGFloat rowH = self.collectionView.frame.size.width * 0.5;
    return CGSizeMake(0, rows * rowH);
}
//如果要切换布局，这个方法一定要实现
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributesArray[indexPath.row];
    
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    proposedContentOffset.y = self.move_y;
    return proposedContentOffset;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    self.move_y = proposedContentOffset.y;
    return proposedContentOffset;
}

#pragma mark -  懒加载
- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

@end
