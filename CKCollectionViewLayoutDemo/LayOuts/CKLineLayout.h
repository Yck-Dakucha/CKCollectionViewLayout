//
//  CKLineLayout.h
//  CKCollectionViewLayoutDemo
//
//  Created by Yck on 16/3/10.
//  Copyright © 2016年 CK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKLineLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat move_x;

- (void)ck_setPageingEnable:(BOOL)isPagingEnabled;

@end
