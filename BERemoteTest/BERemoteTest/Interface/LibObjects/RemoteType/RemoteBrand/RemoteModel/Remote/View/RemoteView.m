//
//  RemoteView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/18.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "RemoteView.h"

@interface RemoteView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation RemoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)loadView{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UITableView *itemTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    itemTableView.delegate = self;
    itemTableView.dataSource = self;
    [self setMyTableView:itemTableView];
    [self addSubview:self.myTableView];
}

#pragma mark - ButtonEvent
- (void)cellButtonTouchDown:(UIButton*)sender{
    UITableViewCell *cell = (UITableViewCell*)sender.superview;
    NSString* itemName = cell.textLabel.text;
    [self.delegate buttonTouchDown:itemName];
}

- (void)cellButtonTouchCancel:(UIButton*)sender{
    UITableViewCell *cell = (UITableViewCell*)sender.superview;
    NSString* itemName = cell.textLabel.text;
    [self.delegate buttonTouchCancel:itemName];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.cellArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifer = @"cellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        button.tag = indexPath.row;
//        [button addTarget:self action:@selector(cellButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
//        [button addTarget:self action:@selector(cellButtonTouchCancel:) forControlEvents:UIControlEventTouchUpInside];
//        [button setTitle:@"cellButton" forState:UIControlStateNormal];
//        button.frame = cell.frame;
//        [cell addSubview:button];
    }
        
    cell.textLabel.text = [[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (self.delegate && [self.delegate respondsToSelector:@selector(cellPress:)]) {
        [self.delegate cellPress:cell.textLabel.text];
    }
}
@end
