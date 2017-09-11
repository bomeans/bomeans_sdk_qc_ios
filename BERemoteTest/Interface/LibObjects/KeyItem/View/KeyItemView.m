//
//  KeyItemView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "KeyItemView.h"

@interface KeyItemView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation KeyItemView

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
    UITableView *itemTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    itemTableView.delegate = self;
    itemTableView.dataSource = self;
    [self setMyTableView:itemTableView];
    [self addSubview:self.myTableView];
    
    self.shouldShowSearchResults = NO;
    [self configureSearchController];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.shouldShowSearchResults) {
        return self.filteredArray.count;
    }
    else{
        return [[self.cellArray objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifer = @"cellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
    }
    
    NSArray *tempArray;
    
    if (self.shouldShowSearchResults) {
        tempArray = @[self.filteredArray];
    }else {
        tempArray = [[NSArray alloc]initWithArray:self.cellArray];
    }
    
    NSString *item = [[tempArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", item];
    cell.detailTextLabel.text = item;
    cell.detailTextLabel.hidden = YES;
    
    return cell;
}

#pragma mark - UITableViewDelegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *itemId = cell.detailTextLabel.text;
    NSString *name = cell.textLabel.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellPress:withName:)]) {
        [self.delegate cellPress:itemId withName:name];
    }
}

@end
