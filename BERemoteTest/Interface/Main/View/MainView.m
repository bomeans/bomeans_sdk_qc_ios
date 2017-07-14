//
//  MainView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/13.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "MainView.h"
#import "BaseModel.h"

@interface MainView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MainView

- (UIBarButtonItem*)changeServerButton
{
    if (nil == _changeServerButton) {
        _changeServerButton = [[UIBarButtonItem alloc] initWithTitle:@"TW" style:UIBarButtonItemStylePlain target:self action:@selector(changeServerButtonClick)];
    }
    return _changeServerButton;
}

- (UIBarButtonItem*)checkAllButton
{
    if (nil == _checkAllButton) {
        _checkAllButton = [[UIBarButtonItem alloc] initWithTitle:@"CheckAll" style:UIBarButtonItemStylePlain target:self action:@selector(checkAllButtonClick)];
    }
    return _checkAllButton;
}

- (UITabBarItem*)tabBarItem
{
    if (nil == _tabBarItem) {
        _tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Simple Test" image:[UIImage imageNamed:@"first"] tag:1];
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
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:frame];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self setMyTableView:mainTableView];
    [self addSubview:self.myTableView];
}

- (void)changeServerButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeServer)]) {
        [self.delegate didChangeServer];
    }
}

- (void)checkAllButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCheckAll)]) {
        [self.delegate didCheckAll];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.cellArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    }
    
    cell.textLabel.text = [[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
