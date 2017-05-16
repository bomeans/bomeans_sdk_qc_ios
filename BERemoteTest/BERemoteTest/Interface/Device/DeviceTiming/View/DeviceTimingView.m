//
//  DeviceTimingView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/23.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DeviceTimingView.h"

@interface DeviceTimingView () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UIScrollView*   scrollView;
@property(nonatomic, strong)UIView*         contentView;
@property(nonatomic, strong)UIButton*       hourButton;
@property(nonatomic, strong)UIButton*       minuteButton;
@property(nonatomic, strong)UIButton*       secondButton;
@property(nonatomic, strong)UITableView*    hourTableView;
@property(nonatomic, strong)UITableView*    minuteTableView;
@property(nonatomic, strong)UITableView*    secondTableView;
@property(nonatomic, strong)UIButton*       refreshButton;
@property(nonatomic, strong)UIButton*       powerTimingOnButton;
@property(nonatomic, strong)UIButton*       powerTimingOffButton;
@property(nonatomic, strong)UIButton*       powerTimingCancerButton;
@property(nonatomic, strong)UIButton*       ledTimingOnButton;
@property(nonatomic, strong)UIButton*       ledTimingOffButton;
@property(nonatomic, strong)UIButton*       ledTimingCancerButton;
@property(nonatomic, strong)UIButton*       wifiTimingOnButton;
@property(nonatomic, strong)UIButton*       wifiTimingOffButton;
@property(nonatomic, strong)UIButton*       wifiTimingCancerButton;

@property(nonatomic, assign)int             hour;
@property(nonatomic, assign)int             min;
@property(nonatomic, assign)int             sec;

@end

@implementation DeviceTimingView

- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.contentSize = self.contentView.bounds.size;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIView*)contentView
{
    if (!_contentView) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _contentView = [[UIView alloc] initWithFrame:frame];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIButton*)hourButton
{
    if (!_hourButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(40), kAutoScreenHeight(50), kAutoScreenWidth(50), kAutoScreenHeight(30));
        _hourButton = [[UIButton alloc] initWithFrame:frame];
        [_hourButton setTitle:@"00" forState:UIControlStateNormal];
        [_hourButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_hourButton addTarget:self action:@selector(hourButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_hourButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    }
    return _hourButton;
}

- (UIButton*)minuteButton
{
    if (!_minuteButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(140), kAutoScreenHeight(50), kAutoScreenWidth(50), kAutoScreenHeight(30));
        _minuteButton = [[UIButton alloc] initWithFrame:frame];
        [_minuteButton setTitle:@"00" forState:UIControlStateNormal];
        [_minuteButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_minuteButton addTarget:self action:@selector(minuteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_minuteButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    }
    return _minuteButton;
}

- (UIButton*)secondButton
{
    if (!_secondButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(240), kAutoScreenHeight(50), kAutoScreenWidth(50), kAutoScreenHeight(30));
        _secondButton = [[UIButton alloc] initWithFrame:frame];
        [_secondButton setTitle:@"00" forState:UIControlStateNormal];
        [_secondButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_secondButton addTarget:self action:@selector(secondButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_secondButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    }
    return _secondButton;
}

- (UITableView*)hourTableView
{
    if (!_hourTableView) {
        CGRect frame = CGRectMake(kAutoScreenWidth(40), kAutoScreenHeight(80), kAutoScreenWidth(70), kAutoScreenHeight(130));
        _hourTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [[_hourTableView layer] setBorderWidth:1.0];
        [[_hourTableView layer] setBorderColor:[UIColor blackColor].CGColor];
        [self bringSubviewToFront:_hourTableView];
    }
    return _hourTableView;
}

- (UITableView*)minuteTableView
{
    if (!_minuteTableView) {
        CGRect frame = CGRectMake(kAutoScreenWidth(140), kAutoScreenHeight(80), kAutoScreenWidth(70), kAutoScreenHeight(130));
        _minuteTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [[_minuteTableView layer] setBorderWidth:1.0];
        [[_minuteTableView layer] setBorderColor:[UIColor blackColor].CGColor];
        [self bringSubviewToFront:_minuteTableView];
    }
    return _minuteTableView;
}

- (UITableView*)secondTableView
{
    if (!_secondTableView) {
        CGRect frame = CGRectMake(kAutoScreenWidth(240), kAutoScreenHeight(80), kAutoScreenWidth(70), kAutoScreenHeight(130));
        _secondTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [[_secondTableView layer] setBorderWidth:1.0];
        [[_secondTableView layer] setBorderColor:[UIColor blackColor].CGColor];
        [self bringSubviewToFront:_secondTableView];
    }
    return _secondTableView;
}

- (UIButton*)refreshButton
{
    if (!_refreshButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(300), kAutoScreenHeight(50), kAutoScreenWidth(70), kAutoScreenHeight(30));
        _refreshButton = [[UIButton alloc] initWithFrame:frame];
        [_refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
        [_refreshButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(getNowTimeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_refreshButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    }
    return _refreshButton;
}

- (UIButton*)powerTimingOnButton
{
    if (!_powerTimingOnButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(150), kAutoScreenHeight(120), kAutoScreenWidth(40), kAutoScreenHeight(30));
        _powerTimingOnButton = [[UIButton alloc] initWithFrame:frame];
        [_powerTimingOnButton setTitle:@"On" forState:UIControlStateNormal];
        [_powerTimingOnButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_powerTimingOnButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_powerTimingOnButton addTarget:self action:@selector(powerTimingOnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _powerTimingOnButton;
}

- (UIButton*)powerTimingOffButton
{
    if (!_powerTimingOffButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(200), kAutoScreenHeight(120), kAutoScreenWidth(40), kAutoScreenHeight(30));
        _powerTimingOffButton = [[UIButton alloc] initWithFrame:frame];
        [_powerTimingOffButton setTitle:@"Off" forState:UIControlStateNormal];
        [_powerTimingOffButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_powerTimingOffButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_powerTimingOffButton addTarget:self action:@selector(powerTimingOffButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _powerTimingOffButton;
}

- (UIButton*)powerTimingCancerButton
{
    if (!_powerTimingCancerButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(270), kAutoScreenHeight(120), kAutoScreenWidth(60), kAutoScreenHeight(30));
        _powerTimingCancerButton = [[UIButton alloc] initWithFrame:frame];
        [_powerTimingCancerButton setTitle:@"Cancer" forState:UIControlStateNormal];
        [_powerTimingCancerButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_powerTimingCancerButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_powerTimingCancerButton addTarget:self action:@selector(powerTimingCancerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _powerTimingCancerButton;
}

- (UIButton*)ledTimingOnButton
{
    if (!_ledTimingOnButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(150), kAutoScreenHeight(160), kAutoScreenWidth(40), kAutoScreenHeight(30));
        _ledTimingOnButton = [[UIButton alloc] initWithFrame:frame];
        [_ledTimingOnButton setTitle:@"On" forState:UIControlStateNormal];
        [_ledTimingOnButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_ledTimingOnButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_ledTimingOnButton addTarget:self action:@selector(ledTimingOnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ledTimingOnButton;
}

- (UIButton*)ledTimingOffButton
{
    if (!_ledTimingOffButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(200), kAutoScreenHeight(160), kAutoScreenWidth(40), kAutoScreenHeight(30));
        _ledTimingOffButton = [[UIButton alloc] initWithFrame:frame];
        [_ledTimingOffButton setTitle:@"Off" forState:UIControlStateNormal];
        [_ledTimingOffButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_ledTimingOffButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_ledTimingOffButton addTarget:self action:@selector(ledTimingOffButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ledTimingOffButton;
}

- (UIButton*)ledTimingCancerButton
{
    if (!_ledTimingCancerButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(270), kAutoScreenHeight(160), kAutoScreenWidth(60), kAutoScreenHeight(30));
        _ledTimingCancerButton = [[UIButton alloc] initWithFrame:frame];
        [_ledTimingCancerButton setTitle:@"Cancer" forState:UIControlStateNormal];
        [_ledTimingCancerButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_ledTimingCancerButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_ledTimingCancerButton addTarget:self action:@selector(ledTimingCancerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ledTimingCancerButton;
}

- (UIButton*)wifiTimingOnButton
{
    if (!_wifiTimingOnButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(150), kAutoScreenHeight(200), kAutoScreenWidth(40), kAutoScreenHeight(30));
        _wifiTimingOnButton = [[UIButton alloc] initWithFrame:frame];
        [_wifiTimingOnButton setTitle:@"On" forState:UIControlStateNormal];
        [_wifiTimingOnButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_wifiTimingOnButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_wifiTimingOnButton addTarget:self action:@selector(wifiTimingOnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wifiTimingOnButton;
}

- (UIButton*)wifiTimingOffButton
{
    if (!_wifiTimingOffButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(200), kAutoScreenHeight(200), kAutoScreenWidth(40), kAutoScreenHeight(30));
        _wifiTimingOffButton = [[UIButton alloc] initWithFrame:frame];
        [_wifiTimingOffButton setTitle:@"Off" forState:UIControlStateNormal];
        [_wifiTimingOffButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_wifiTimingOffButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_wifiTimingOffButton addTarget:self action:@selector(wifiTimingOffButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wifiTimingOffButton;
}

- (UIButton*)wifiTimingCancerButton
{
    if (!_wifiTimingCancerButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(270), kAutoScreenHeight(200), kAutoScreenWidth(60), kAutoScreenHeight(30));
        _wifiTimingCancerButton = [[UIButton alloc] initWithFrame:frame];
        [_wifiTimingCancerButton setTitle:@"Cancer" forState:UIControlStateNormal];
        [_wifiTimingCancerButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_wifiTimingCancerButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_wifiTimingCancerButton addTarget:self action:@selector(wifiTimingCancerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wifiTimingCancerButton;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        [self loadView];
    }
    return self;
}

- (void)loadData
{
    self.hourTableView.dataSource = self;
    self.hourTableView.delegate = self;
    self.minuteTableView.dataSource = self;
    self.minuteTableView.delegate = self;
    self.secondTableView.dataSource = self;
    self.secondTableView.delegate = self;
    self.hourTableView.hidden = YES;
    self.minuteTableView.hidden = YES;
    self.secondTableView.hidden = YES;
}

- (void)loadView
{
    CGRect frame = CGRectMake(kAutoScreenWidth(20), kAutoScreenHeight(50), kAutoScreenWidth(20), kAutoScreenHeight(30));
    UILabel *hourLable = [[UILabel alloc] initWithFrame:frame];
    hourLable.text = @"H:";
    [self.contentView addSubview:hourLable];
    
    frame = CGRectMake(kAutoScreenWidth(120), kAutoScreenHeight(50), kAutoScreenWidth(20), kAutoScreenHeight(30));
    UILabel *minuteLable = [[UILabel alloc] initWithFrame:frame];
    minuteLable.text = @"M:";
    [self.contentView addSubview:minuteLable];
    
    frame = CGRectMake(kAutoScreenWidth(220), kAutoScreenHeight(50), kAutoScreenWidth(20), kAutoScreenHeight(30));
    UILabel *secondLable = [[UILabel alloc] initWithFrame:frame];
    secondLable.text = @"S:";
    [self.contentView addSubview:secondLable];
    
    frame = CGRectMake(kAutoScreenWidth(20), kAutoScreenHeight(120), kAutoScreenWidth(140), kAutoScreenHeight(30));
    UILabel *powerTimeingLable = [[UILabel alloc] initWithFrame:frame];
    powerTimeingLable.text = @"Power Timing:";
    [self.contentView addSubview:powerTimeingLable];
    
    frame = CGRectMake(kAutoScreenWidth(20), kAutoScreenHeight(160), kAutoScreenWidth(140), kAutoScreenHeight(30));
    UILabel *ledTimeingLable = [[UILabel alloc] initWithFrame:frame];
    ledTimeingLable.text = @"LED Timing:";
    [self.contentView addSubview:ledTimeingLable];
    
    frame = CGRectMake(kAutoScreenWidth(20), kAutoScreenHeight(200), kAutoScreenWidth(140), kAutoScreenHeight(30));
    UILabel *wifiTimeingLable = [[UILabel alloc] initWithFrame:frame];
    wifiTimeingLable.text = @"Wifi Timing:";
    [self.contentView addSubview:wifiTimeingLable];
    
    [self.contentView addSubview:self.hourButton];
    [self.contentView addSubview:self.minuteButton];
    [self.contentView addSubview:self.secondButton];
    [self.contentView addSubview:self.refreshButton];
    [self.contentView addSubview:self.powerTimingOnButton];
    [self.contentView addSubview:self.powerTimingOffButton];
    [self.contentView addSubview:self.powerTimingCancerButton];
    [self.contentView addSubview:self.ledTimingOnButton];
    [self.contentView addSubview:self.ledTimingOffButton];
    [self.contentView addSubview:self.ledTimingCancerButton];
    [self.contentView addSubview:self.wifiTimingOnButton];
    [self.contentView addSubview:self.wifiTimingOffButton];
    [self.contentView addSubview:self.wifiTimingCancerButton];
    
    [self.contentView addSubview:self.hourTableView];
    [self.contentView addSubview:self.minuteTableView];
    [self.contentView addSubview:self.secondTableView];
    
    [self.scrollView addSubview:self.contentView];
    [self addSubview:_scrollView];
}

- (void)hourButtonClick:(UIButton *)sender {
    if (_hourTableView.hidden == YES) {
        _hourTableView.hidden = NO;
    }
    else _hourTableView.hidden = YES;
}

- (void)minuteButtonClick:(UIButton *)sender {
    if (_minuteTableView.hidden == YES) {
        _minuteTableView.hidden = NO;
    }
    else _minuteTableView.hidden = YES;
}

- (void)secondButtonClick:(UIButton *)sender {
    if (_secondTableView.hidden == YES) {
        _secondTableView.hidden = NO;
    }
    else _secondTableView.hidden = YES;
}

- (void)getNowTimeButtonClick:(UIButton *)sender {
    NSDate* now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSString *hh = [newDateString substringToIndex:2];
    NSString *mm = [newDateString substringWithRange:NSMakeRange(3, 2)];
    NSString *ss = [newDateString substringFromIndex:6];
    [_hourButton setTitle:hh forState:UIControlStateNormal];
    [_minuteButton setTitle:mm forState:UIControlStateNormal];
    [_secondButton setTitle:ss forState:UIControlStateNormal];
    _hour = [hh intValue];
    _min = [mm intValue];
    _sec = [ss intValue];
    [self scrollToRowForHour];
    [self scrollToRowForMinute];
    [self scrollToRowForSecond];
}

- (void)scrollToRowForHour
{
    [_hourTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_hourButton.titleLabel.text intValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)scrollToRowForMinute
{
    [_minuteTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_minuteButton.titleLabel.text intValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)scrollToRowForSecond
{
    [_secondTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_secondButton.titleLabel.text intValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)powerTimingOnButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setPowerTimingOn:withMinute:withSecond:)]) {
        [self.delegate setPowerTimingOn:_hour withMinute:_min withSecond:_sec];
    }
}

- (void)powerTimingOffButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setPowerTimingOff:withMinute:withSecond:)]) {
        [self.delegate setPowerTimingOff:_hour withMinute:_min withSecond:_sec];
    }
}

- (void)powerTimingCancerButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setPowerTimingCancer:withMinute:withSecond:)]) {
        [self.delegate setPowerTimingCancer:_hour withMinute:_min withSecond:_sec];
    }
}

- (void)ledTimingOnButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setLedTimingOn:withMinute:withSecond:)]) {
        [self.delegate setLedTimingOn:_hour withMinute:_min withSecond:_sec];
    }
}

- (void)ledTimingOffButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setLedTimingOff:withMinute:withSecond:)]) {
        [self.delegate setLedTimingOff:_hour withMinute:_min withSecond:_sec];
    }
}

- (void)ledTimingCancerButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setLedTimingCancer:withMinute:withSecond:)]) {
        [self.delegate setLedTimingCancer:_hour withMinute:_min withSecond:_sec];
    }
}

- (void)wifiTimingOnButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setWifiTimingOn:withMinute:withSecond:)]) {
        [self.delegate setWifiTimingOn:_hour withMinute:_min withSecond:_sec];
    }
}

- (void)wifiTimingOffButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setWifiTimingOff:withMinute:withSecond:)]) {
        [self.delegate setWifiTimingOff:_hour withMinute:_min withSecond:_sec];
    }
}

- (void)wifiTimingCancerButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setWifiTimingCancer:withMinute:withSecond:)]) {
        [self.delegate setWifiTimingCancer:_hour withMinute:_min withSecond:_sec];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_hourTableView]) {
        return _hourArray.count;
    }
    return _minuteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([tableView isEqual:_hourTableView]) {
        cell.textLabel.text = [_hourArray objectAtIndex:indexPath.row];
    }else
    {
        cell.textLabel.text = [_minuteArray objectAtIndex:indexPath.row];
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([tableView isEqual:_hourTableView]) {
        [_hourButton setTitle:[NSString stringWithFormat:@"%.2d", [cell.textLabel.text intValue]] forState:UIControlStateNormal];
        _hourTableView.hidden = YES;
        _hour = [cell.textLabel.text intValue];
    }
    else if ([tableView isEqual:_minuteTableView]) {
        [_minuteButton setTitle:[NSString stringWithFormat:@"%.2d", [cell.textLabel.text intValue]] forState:UIControlStateNormal];
        _minuteTableView.hidden = YES;
        _min = [cell.textLabel.text intValue];
    }
    else if ([tableView isEqual:_secondTableView]) {
        [_secondButton setTitle:[NSString stringWithFormat:@"%.2d", [cell.textLabel.text intValue]] forState:UIControlStateNormal];
        _secondTableView.hidden = YES;
        _sec = [cell.textLabel.text intValue];
    }
}

@end
