//
//  SmartPickerView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "ACPickerView.h"

@interface ACPickerView ()

@property (nonatomic, strong) UIButton*     checkedButton;
@property (nonatomic, strong) UIButton*     startButton;
@property (nonatomic, strong) UIButton*     stopButton;

@end

@implementation ACPickerView

- (UIButton*)checkedButton{
    if (!_checkedButton) {
        CGRect frame = CGRectMake((kScreenWidth - kAutoScreenWidth(200))/2, kAutoScreenHeight(250), kAutoScreenWidth(200), kAutoScreenHeight(50));
        _checkedButton = [[UIButton alloc] initWithFrame:frame];
        [_checkedButton setTitle:@"checked" forState:UIControlStateNormal];
        [_checkedButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_checkedButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_checkedButton addTarget:self action:@selector(checkedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_checkedButton];
    }
    return _checkedButton;
}

- (UIButton*)startButton{
    if (!_startButton) {
        CGRect frame = CGRectMake((kScreenWidth - kAutoScreenWidth(200))/2, kAutoScreenHeight(350), kAutoScreenWidth(200), kAutoScreenHeight(50));
        _startButton = [[UIButton alloc] initWithFrame:frame];
        [_startButton setTitle:@"Auto Picker Start" forState:UIControlStateNormal];
        [_startButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_startButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_startButton];
    }
    return _startButton;
}

- (UIButton*)stopButton{
    if (!_stopButton) {
        CGRect frame = CGRectMake((kScreenWidth - kAutoScreenWidth(200))/2, kAutoScreenHeight(400), kAutoScreenWidth(200), kAutoScreenHeight(50));
        _stopButton = [[UIButton alloc] initWithFrame:frame];
        [_stopButton setTitle:@"Auto Picker Stop" forState:UIControlStateNormal];
        [_stopButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_stopButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_stopButton addTarget:self action:@selector(stopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_stopButton];
    }
    return _stopButton;
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
    [self checkedButton];
    [self startButton];
    //[self stopButton];
}

- (void)setCheckedButtonTitle:(NSString*)title{
    [_checkedButton setTitle:title forState:UIControlStateNormal];
}

- (void)checkedButtonClick:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkedButtonClick:)]) {
        [self.delegate checkedButtonClick:sender.titleLabel.text];
    }
}

- (void)startButtonClick:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startButtonClick)]) {
        [self.delegate startButtonClick];
    }
}

- (void)stopButtonClick:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stopButtonClick)]) {
        [self.delegate stopButtonClick];
    }
}

@end
