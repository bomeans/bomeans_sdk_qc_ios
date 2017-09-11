//
//  DeviceWifiSetView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DeviceWifiSetView.h"

@interface DeviceWifiSetView ()

@property(nonatomic, strong)UILabel*      ssidLabel;
@property(nonatomic, strong)UILabel*      passwordLabel;
@property(nonatomic, strong)UITextField*  passwordField;
@property(nonatomic, strong)UIButton*     broadcastButton;

@end

@implementation DeviceWifiSetView

- (UILabel*)ssidLabel
{
    if (!_ssidLabel) {
        CGRect frame = CGRectMake(kAutoScreenWidth(50), kAutoScreenHeight(200), kAutoScreenWidth(50), kAutoScreenHeight(40));
        _ssidLabel = [[UILabel alloc] initWithFrame:frame];
        _ssidLabel.text = @"SSID:";
        [self addSubview:_ssidLabel];
    }
    return _ssidLabel;
}

- (UILabel*)passwordLabel
{
    if (!_passwordLabel) {
        CGRect frame = CGRectMake(kAutoScreenWidth(50), kAutoScreenHeight(250), kAutoScreenWidth(50), kAutoScreenHeight(40));
        _passwordLabel = [[UILabel alloc] initWithFrame:frame];
        _passwordLabel.text = @"PW:";
        [self addSubview:_passwordLabel];
    }
    return _passwordLabel;
}

- (UITextField*)ssidField
{
    if (!_ssidField) {
        CGRect frame = CGRectMake(kAutoScreenWidth(120), kAutoScreenHeight(200), kAutoScreenWidth(150), kAutoScreenHeight(40));
        _ssidField = [[UITextField alloc] initWithFrame:frame];
        _ssidField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:_ssidField];
    }
    return _ssidField;
}

- (UITextField*)passwordField
{
    if (!_passwordField) {
        CGRect frame = CGRectMake(kAutoScreenWidth(120), kAutoScreenHeight(250), kAutoScreenWidth(150), kAutoScreenHeight(40));
        _passwordField = [[UITextField alloc] initWithFrame:frame];
        _passwordField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:_passwordField];
    }
    return _passwordField;
}

- (UIButton*)broadcastButton
{
    if (!_broadcastButton) {
        CGRect frame = CGRectMake(kAutoScreenWidth(150), kAutoScreenHeight(350), kAutoScreenWidth(100), kAutoScreenHeight(50));
        _broadcastButton = [[UIButton alloc] initWithFrame:frame];
        [_broadcastButton setTitle:@"broadcast" forState:UIControlStateNormal];
        [_broadcastButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_broadcastButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_broadcastButton addTarget:self action:@selector(broadcastButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_broadcastButton];
    }
    return _broadcastButton;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self loadView];
    }
    
    return self;
}

- (void)loadView
{
    [self ssidLabel];
    [self ssidField];
    [self passwordLabel];
    [self passwordField];
    [self broadcastButton];
}

- (void)broadcastButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(broadcastWifiWithSsid:withPassword:)]) {
        [self.delegate broadcastWifiWithSsid:_ssidField.text withPassword:_passwordField.text];
    }
}

#pragma mark - UIViewTouchEvent
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![_ssidField isExclusiveTouch]) {
        [_ssidField resignFirstResponder];
    }
    if (![_passwordField isExclusiveTouch]) {
        [_passwordField resignFirstResponder];
    }
}

@end
