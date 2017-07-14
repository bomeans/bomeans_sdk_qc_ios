//
//  WifiToIRDiscoveryView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "WifiToIRDiscoveryView.h"
#import "BIRIpAndMac.h"

@interface WifiToIRDiscoveryView () <UITableViewDataSource>

@end

@implementation WifiToIRDiscoveryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadView];
    }
    
    return self;
}

- (void)loadView
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UITableView *itemTableView = [[UITableView alloc] initWithFrame:frame];
    itemTableView.dataSource = self;
    [self setMyTableView:itemTableView];
    [self addSubview:self.myTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.cellArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //製作可重複利用的表格欄位Cell
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    BIRIpAndMac* item = [[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"IP: %@", item.ip];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"MAC: %@", item.mac];
    
    return cell;
}
@end
