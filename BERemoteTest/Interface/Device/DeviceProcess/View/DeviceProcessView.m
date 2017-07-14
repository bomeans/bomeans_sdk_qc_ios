//
//  DeviceProcessView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/21.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DeviceProcessView.h"

@interface DeviceProcessView () 

@property(nonatomic, strong)UIScrollView*   scrollView;
@property(nonatomic, strong)UIView*         contentView;
@property(nonatomic, strong)UIImageView*    colorImageView;
@property(nonatomic, strong)UISlider*       redSlider;
@property(nonatomic, strong)UISlider*       greenSlider;
@property(nonatomic, strong)UISlider*       blueSlider;
@property(nonatomic, strong)UISwitch*       powerSwitch;
@property(nonatomic, strong)UISwitch*       ledSwitch;
@property(nonatomic, strong)UIButton*       turnOffWifiButton;

@end

@implementation DeviceProcessView

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

- (UIImageView*)colorImageView
{
    if (!_colorImageView) {
        CGRect frame = CGRectMake(kScreenWidthCenter - kAutoScreenWidth(150)/2, kAutoScreenHeight(30), kAutoScreenWidth(150), kAutoScreenHeight(80));
        _colorImageView = [[UIImageView alloc] initWithFrame:frame];
        _colorImageView.backgroundColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0];
        _colorImageView.userInteractionEnabled = YES;
        [[_colorImageView layer] setBorderWidth:1.0];
        [[_colorImageView layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_colorImageView layer] setCornerRadius:10.0];
    }
    return _colorImageView;
}

- (UISlider*)redSlider
{
    if (!_redSlider) {
        CGRect frame = CGRectMake(kAutoScreenWidth(90), kAutoScreenHeight(130), kAutoScreenWidth(200), kAutoScreenHeight(30));
        _redSlider = [[UISlider alloc] initWithFrame:frame];
        _redSlider.tintColor = [UIColor redColor];
        _redSlider.value = 0.4;
        _redSlider.maximumValue = 1;
        [_redSlider addTarget:self action:@selector(rgbSliderValueChange) forControlEvents:UIControlEventValueChanged];
        [_redSlider addTarget:self action:@selector(rgbLedValueChange) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redSlider;
}

- (UISlider*)greenSlider
{
    if (!_greenSlider) {
        CGRect frame = CGRectMake(kAutoScreenWidth(90), kAutoScreenHeight(170), kAutoScreenWidth(200), kAutoScreenHeight(30));
        _greenSlider = [[UISlider alloc] initWithFrame:frame];
        _greenSlider.tintColor = [UIColor greenColor];
        _greenSlider.value = 0.4;
        _greenSlider.maximumValue = 1;
        [_greenSlider addTarget:self action:@selector(rgbSliderValueChange) forControlEvents:UIControlEventValueChanged];
        [_greenSlider addTarget:self action:@selector(rgbLedValueChange) forControlEvents:UIControlEventTouchUpInside];
    }
    return _greenSlider;
}

- (UISlider*)blueSlider
{
    if (!_blueSlider) {
        CGRect frame = CGRectMake(kAutoScreenWidth(90), kAutoScreenHeight(210), kAutoScreenWidth(200), kAutoScreenHeight(30));
        _blueSlider = [[UISlider alloc] initWithFrame:frame];
        _blueSlider.tintColor = [UIColor blueColor];
        _blueSlider.value = 0.4;
        _blueSlider.maximumValue = 1;
        [_blueSlider addTarget:self action:@selector(rgbSliderValueChange) forControlEvents:UIControlEventValueChanged];
        [_blueSlider addTarget:self action:@selector(rgbLedValueChange) forControlEvents:UIControlEventTouchUpInside];
    }
    return _blueSlider;
}

- (UISwitch*)powerSwitch
{
    if (!_powerSwitch) {
        CGRect frame = CGRectMake(kAutoScreenWidth(170), kAutoScreenHeight(250), kAutoScreenWidth(50), kAutoScreenHeight(30));
        _powerSwitch = [[UISwitch alloc] initWithFrame:frame];
        [_powerSwitch setOn:YES];
        [_powerSwitch addTarget:self action:@selector(irPowerSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _powerSwitch;
}

- (UISwitch*)ledSwitch
{
    if (!_ledSwitch) {
        CGRect frame = CGRectMake(kAutoScreenWidth(170), kAutoScreenHeight(290), kAutoScreenWidth(50), kAutoScreenHeight(30));
        _ledSwitch = [[UISwitch alloc] initWithFrame:frame];
        [_ledSwitch setOn:YES];
        [_ledSwitch addTarget:self action:@selector(irLedSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _ledSwitch;
}

- (UIButton*)turnOffWifiButton
{
    if (!_turnOffWifiButton) {
        CGRect frame = CGRectMake(kScreenWidth/2 - kAutoScreenWidth(130)/2, kAutoScreenHeight(350), kAutoScreenWidth(130), kAutoScreenHeight(30));
        _turnOffWifiButton = [[UIButton alloc] initWithFrame:frame];
        [_turnOffWifiButton setTitle:@"Turn Off Wifi" forState:UIControlStateNormal];
        [_turnOffWifiButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_turnOffWifiButton setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.3f] forState:UIControlStateHighlighted];
        [_turnOffWifiButton addTarget:self action:@selector(turnOffWifiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _turnOffWifiButton;
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
    
}

- (void)loadView
{
    CGRect frame = CGRectMake(kAutoScreenWidth(20), kAutoScreenHeight(130), kAutoScreenWidth(50), kAutoScreenHeight(30));
    UILabel *redLable = [[UILabel alloc] initWithFrame:frame];
    redLable.text = @"Red";
    [self.contentView addSubview:redLable];
    
    frame = CGRectMake(kAutoScreenWidth(20), kAutoScreenHeight(170), kAutoScreenWidth(50), kAutoScreenHeight(30));
    UILabel *greenLable = [[UILabel alloc] initWithFrame:frame];
    greenLable.text = @"Green";
    [self.contentView addSubview:greenLable];
    
    frame = CGRectMake(kAutoScreenWidth(20), kAutoScreenHeight(210), kAutoScreenWidth(50), kAutoScreenHeight(30));
    UILabel *blueLable = [[UILabel alloc] initWithFrame:frame];
    blueLable.text = @"Blue";
    [self.contentView addSubview:blueLable];
    
    frame = CGRectMake(kAutoScreenWidth(20), kAutoScreenHeight(250), kAutoScreenWidth(140), kAutoScreenHeight(30));
    UILabel *powerSwitchLable = [[UILabel alloc] initWithFrame:frame];
    powerSwitchLable.text = @"Power Switch";
    [self.contentView addSubview:powerSwitchLable];
    
    frame = CGRectMake(kAutoScreenWidth(20), kAutoScreenHeight(290), kAutoScreenWidth(140), kAutoScreenHeight(30));
    UILabel *ledSwitchLable = [[UILabel alloc] initWithFrame:frame];
    ledSwitchLable.text = @"led Switch";
    [self.contentView addSubview:ledSwitchLable];
    
    [self.contentView addSubview:self.colorImageView];
    [self.contentView addSubview:self.redSlider];
    [self.contentView addSubview:self.greenSlider];
    [self.contentView addSubview:self.blueSlider];
    [self.contentView addSubview:self.powerSwitch];
    [self.contentView addSubview:self.ledSwitch];
    [self.contentView addSubview:self.turnOffWifiButton];
    
    [self.scrollView addSubview:self.contentView];
    [self addSubview:_scrollView];
}

-(void)rgbLedValueChange{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changedLedLightColorWithRed:withGreen:withBlue:)]) {
        [self.delegate changedLedLightColorWithRed:_redSlider.value withGreen:_greenSlider.value withBlue:_blueSlider.value];
    }
}

-(void)rgbSliderValueChange{
    UIColor* ledColor = [UIColor colorWithRed:_redSlider.value green:_greenSlider.value blue:_blueSlider.value alpha:1.0];
    _colorImageView.backgroundColor = ledColor;
}

- (void)irPowerSwitchValueChange:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchIrPower:)]) {
        [self.delegate switchIrPower:[sender isOn]];
    }
}

- (void)irLedSwitchValueChange:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchIrLed:)]) {
        [self.delegate switchIrLed:[sender isOn]];
    }
}

- (void)turnOffWifiButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(turnOffWifi)]) {
        [self.delegate turnOffWifi];
    }
}

@end
