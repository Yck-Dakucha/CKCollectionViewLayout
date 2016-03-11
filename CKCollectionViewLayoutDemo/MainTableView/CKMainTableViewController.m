//
//  CKMainTableViewController.m
//  CKCollectionViewLayoutDemo
//
//  Created by Yck on 16/3/10.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKMainTableViewController.h"
#import "CKCardSlideVC.h"

@interface CKMainTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CKMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.dataArray = @[
                       @{
                           @"title":@"CardSlider",
                           @"class":NSStringFromClass([CKCardSlideVC class])
                           },
                       
                       ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc= [storyBoard instantiateViewControllerWithIdentifier:self.dataArray[indexPath.row][@"class"]];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
