//
//  AcSampleView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/18.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "AcSampleView.h"

@interface AcSampleView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView*  modeImageView;
@property (nonatomic, strong) UIImageView*  turboImageView;
@property (nonatomic, strong) UIImageView*  airSwapImageView;
@property (nonatomic, strong) UIImageView*  lightImageView;
@property (nonatomic, strong) UIImageView*  warmUpImageView;
@property (nonatomic, strong) UIImageView*  sleepImageView;
@property (nonatomic, strong) UIImageView*  airCleanImageView;
@property (nonatomic, strong) UIImageView*  swingLRImageView;
@property (nonatomic, strong) UIImageView*  swingUDImageView;
@property (nonatomic, strong) UILabel*      fanSpeedLable;
@property (nonatomic, strong) UILabel*      timerLable;
@property (nonatomic, strong) UILabel*      temperatureLable;

@end

@implementation AcSampleView

- (UIImageView*)modeImageView{
    if (!_modeImageView) {
        CGRect frame = CGRectMake(kAutoScreenWidth(11), kAutoScreenHeight(4), kAutoScreenWidth(16), kAutoScreenHeight(16));
        _modeImageView = [[UIImageView alloc] initWithFrame:frame];
        [_modeImageView setImage:[UIImage imageNamed:@"remoter-AC-modehot"]];
    }
    return _modeImageView;
}

- (UIImageView*)turboImageView{
    if (!_turboImageView) {
        CGRect frame = CGRectMake(kAutoScreenWidth(11), kAutoScreenHeight(23), kAutoScreenWidth(16), kAutoScreenHeight(16));
        _turboImageView = [[UIImageView alloc] initWithFrame:frame];
        [_turboImageView setImage:[UIImage imageNamed:@"remoter-AC-turbo"]];
    }
    return _turboImageView;
}

- (UIImageView*)airSwapImageView{
    if (!_airSwapImageView) {
        CGRect frame = CGRectMake(kAutoScreenWidth(11), kAutoScreenHeight(42), kAutoScreenWidth(16), kAutoScreenHeight(16));
        _airSwapImageView = [[UIImageView alloc] initWithFrame:frame];
        [_airSwapImageView setImage:[UIImage imageNamed:@"rremoter-AC-airswap"]];
    }
    return _airSwapImageView;
}

- (UIImageView*)lightImageView{
    if (!_lightImageView) {
        CGRect frame = CGRectMake(kAutoScreenWidth(11), kAutoScreenHeight(61), kAutoScreenWidth(16), kAutoScreenHeight(16));
        _lightImageView = [[UIImageView alloc] initWithFrame:frame];
        [_lightImageView setImage:[UIImage imageNamed:@"remoter-AC-light"]];
    }
    return _lightImageView;
}

- (UIImageView*)warmUpImageView{
    if (!_warmUpImageView) {
        CGRect frame = CGRectMake(kAutoScreenWidth(11), kAutoScreenHeight(80), kAutoScreenWidth(16), kAutoScreenHeight(16));
        _warmUpImageView = [[UIImageView alloc] initWithFrame:frame];
        [_warmUpImageView setImage:[UIImage imageNamed:@"remoter-AC-warmup"]];
    }
    return _warmUpImageView;
}

- (UIImageView*)sleepImageView{
    if (!_sleepImageView) {
        CGRect frame = CGRectMake(kAutoScreenWidth(11), kAutoScreenHeight(98), kAutoScreenWidth(16), kAutoScreenHeight(16));
        _sleepImageView = [[UIImageView alloc] initWithFrame:frame];
        [_sleepImageView setImage:[UIImage imageNamed:@"remoter-AC-sleep"]];
    }
    return _sleepImageView;
}

- (UIImageView*)airCleanImageView{
    if (!_airCleanImageView) {
        CGRect frame = CGRectMake(kAutoScreenWidth(11), kAutoScreenHeight(98), kAutoScreenWidth(16), kAutoScreenHeight(16));
        _airCleanImageView = [[UIImageView alloc] initWithFrame:frame];
        [_airCleanImageView setImage:[UIImage imageNamed:@"remoter-AC-airclean"]];
    }
    return _airCleanImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)loadView{
    CGRect bgFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIView *bgView = [[UIView alloc] initWithFrame:bgFrame];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    CGRect lcdViewFrame = CGRectMake(kAutoScreenWidth(46), kAutoScreenHeight(110), kAutoScreenWidth(282), kAutoScreenHeight(150));
    UIView *lcdView = [[UIView alloc] initWithFrame:lcdViewFrame];
    lcdView.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:lcdView];
    
    CGRect tableViewFrame = CGRectMake(0, kScreenHeight/2, kScreenWidth, kScreenHeight/2);
    UITableView *itemTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    itemTableView.delegate = self;
    itemTableView.dataSource = self;
    [self setMyTableView:itemTableView];
    [self addSubview:self.myTableView];
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
