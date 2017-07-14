//
//  BaseView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/16.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseView.h"

@interface BaseView()

@end

@implementation BaseView

- (void)getSectionSource:(NSArray*)array
{
    self.sectionArray = array;
    [self.myTableView reloadData];
}

- (void)getDataSoruce:(NSArray*)array
{
    self.cellArray = array;
    [self.myTableView reloadData];
}

#pragma mark - UITableViewDataSource
//設定分類開頭標題
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionArray objectAtIndex:section];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
return 40.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    header.textLabel.text = header.textLabel.text;
    
    header.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
    
}

@end
