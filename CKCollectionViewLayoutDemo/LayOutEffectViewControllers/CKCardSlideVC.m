//
//  CKCardSlideVC.m
//  CKCollectionViewLayoutDemo
//
//  Created by Yck on 16/3/10.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKCardSlideVC.h"
#import "CKLineLayout.h"
#import "CKCircleLayout.h"
#import "CKGridLayout.h"
#import "CKCardSliderCollectionCell.h"


@interface CKCardSlideVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic  ) IBOutlet UICollectionView   *collectionView;
@property (weak, nonatomic  ) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic  ) IBOutlet UIStackView        *pageingStack;

@property (nonatomic, strong) NSArray            *dataArray;

@property (nonatomic, strong) CKLineLayout       *lineLayout;
@property (nonatomic, strong) CKCircleLayout     *circleLayout;
@property (nonatomic, strong) CKGridLayout       *gridLayout;

@end

@implementation CKCardSlideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12];
    [self.collectionView setCollectionViewLayout:self.lineLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  collectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -  collectionView Delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CardSliderCell";
    CKCardSliderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    CKCardSliderCollectionCell *collectCell = (CKCardSliderCollectionCell *)cell;
    collectCell.backgroundColor = [UIColor blueColor];
    [collectCell ck_setCellTitle:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]]];
    collectCell.layer.borderColor = [UIColor whiteColor].CGColor;
    collectCell.layer.borderWidth = 2;
}
#pragma mark -  Action
//变换Layout形式
- (IBAction)segmentAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.pageingStack.alpha = 1.0;
            }];
            [self.collectionView setCollectionViewLayout:self.lineLayout animated:YES];
            [self.collectionView setContentOffset:CGPointMake(self.lineLayout.move_x, 0)];
            break;
        }
        case 1:
        {
            if (self.pageingStack.alpha != 0.0) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.pageingStack.alpha = 0.0;
                }];
            }
            [self.collectionView setCollectionViewLayout:self.circleLayout animated:YES];
            break;
        }
        case 2:
        {
            if (self.pageingStack.alpha != 0.0) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.pageingStack.alpha = 0.0;
                }];
            }
//            self.collectionView.collectionViewLayout = nil;
            [self.collectionView setCollectionViewLayout:self.gridLayout animated:YES];
            break;
        }
        default:
            break;
    }
}
//是否支持单页翻页
- (IBAction)pagingSwitch:(UISwitch *)sender {
    if ([sender isOn]) {
        [self.lineLayout ck_setPageingEnable:YES];
    }else {
        [self.lineLayout ck_setPageingEnable:NO];
    }
}

#pragma mark -  懒加载
- (CKLineLayout *)lineLayout {
    if (!_lineLayout) {
        _lineLayout = [[CKLineLayout alloc] init];
        [_lineLayout ck_setPageingEnable:YES];
        _lineLayout.itemSize = CGSizeMake(self.collectionView.frame.size.height - 20, self.collectionView.frame.size.height - 20);
    }
    return _lineLayout;
}
- (CKCircleLayout *)circleLayout {
    if (!_circleLayout) {
        _circleLayout = [[CKCircleLayout alloc] init];
    }
    return _circleLayout;
}
- (CKGridLayout *)gridLayout {
    if (!_gridLayout) {
        _gridLayout = [[CKGridLayout alloc] init];
    }
    return _gridLayout;
}


@end
