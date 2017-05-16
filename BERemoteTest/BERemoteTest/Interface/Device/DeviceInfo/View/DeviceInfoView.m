//
//  DeviceInfoView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DeviceInfoView.h"

@interface DeviceInfoView() <UITableViewDataSource,UITableViewDelegate>

@end

@implementation DeviceInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)loadView
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UITableView *deviceInfoTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    deviceInfoTableView.delegate = self;
    deviceInfoTableView.dataSource = self;
    [self setMyTableView:deviceInfoTableView];
    [self addSubview:self.myTableView];
}

- (void)deleteDevice
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDeleteDevice)]) {
        [self.delegate cellDeleteDevice];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.cellArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"忘記此轉發器";
        cell.detailTextLabel.text = @"";
        cell.textLabel.textColor = self.tintColor;//[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1];
    }else{
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Name";
                break;
            case 1:
                cell.textLabel.text = @"IP";
                break;
            case 2:
                cell.textLabel.text = @"MAC";
                break;
            case 3:
                cell.textLabel.text = @"CoreID";
                break;
            default:
                break;
        }
        cell.detailTextLabel.text = [[self.cellArray objectAtIndex:1] objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [self deleteDevice];
    }
}

@end
