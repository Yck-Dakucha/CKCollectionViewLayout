//
//  CKCircleLayout.m
//  CKCollectionViewLayoutDemo
//
//  Created by Yck on 16/3/11.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKCircleLayout.h"

@interface CKCircleLayout ()

@property (nonatomic, strong) NSMutableArray *attributesArray;

@end

@implementation CKCircleLayout

- (void)prepareLayout {
    [super prepareLayout];
    [self.attributesArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
    }
    
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //圆心位置
    CGFloat collectinoCenterX = self.collectionView.frame.size.width * 0.5;
    CGFloat collectinoCenterY = self.collectionView.frame.size.height * 0.5;
    //半径
    CGFloat radius = (self.collectionView.frame.size.height - 80) * 0.5;
    //设置attributes
    attributes.size = CGSizeMake(75, 75);
    if (count == 1) {
        attributes.center = CGPointMake(collectinoCenterX, collectinoCenterY);
    }else {
        CGFloat angle = (2 * M_PI / count) * indexPath.item;
        CGFloat centerX = collectinoCenterX + radius * sin(angle);
        CGFloat centerY = collectinoCenterY + radius * cos(angle);
        attributes.center = CGPointMake(centerX, centerY);
    }
    
    return attributes;
    
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark -  懒加载
- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

@end
