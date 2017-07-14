//
//  LibObjectsView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/15.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "LibObjectsView.h"
//#import "BaseModel.h"

@interface LibObjectsView () <UITableViewDataSource,UITableViewDelegate>



@end

@implementation LibObjectsView

- (UITabBarItem*)tabBarItem
{
    if (nil == _tabBarItem) {
        _tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Single Test" image:[UIImage imageNamed:@"second"] tag:1];
    }
    return _tabBarItem;
}

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
    UITableView *libTableView = [[UITableView alloc] initWithFrame:frame];
    libTableView.delegate = self;
    libTableView.dataSource = self;
    [self setMyTableView:libTableView];
    [self addSubview:self.myTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.cellArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //製作可重複利用的表格欄位Cell
    static NSString *cellIdentifier = @"classCell";
    static NSString *cellIdentifierForConst = @"classCellConst";
    
    UITableViewCell *cell;
    if (indexPath.section == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForConst];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    if (!cell) {
        if (indexPath.section == 4) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForConst];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    
    NSString* className = [[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@", indexPath.row+1,className];
    //cell.detailTextLabel.text = @"";
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.currentType;
        }else if (indexPath.row == 1) {
            cell.detailTextLabel.text = self.currentBrand;
        }else if (indexPath.row == 2) {
            cell.detailTextLabel.text = self.currentModel;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellPressWithIndexPath:)]) {
        [self.delegate cellPressWithIndexPath:indexPath];
    }
    
}

@end
