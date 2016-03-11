//
//  CKCardSliderCollectionCell.m
//  CKCollectionViewLayoutDemo
//
//  Created by Yck on 16/3/10.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKCardSliderCollectionCell.h"
@interface CKCardSliderCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation CKCardSliderCollectionCell

- (void)ck_setCellTitle:(NSString *)string {
    if (string) {
        [self.title setText:string];
    }
}

@end
