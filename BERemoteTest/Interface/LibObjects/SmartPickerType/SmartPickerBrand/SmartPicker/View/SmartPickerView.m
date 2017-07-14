//
//  SmartPickerView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "SmartPickerView.h"

@interface SmartPickerView ()

@property (nonatomic, strong) UIButton*     checkedButton;

@end

@implementation SmartPickerView

- (UIButton*)checkedButton{
    if (!_checkedButton) {
        CGRect frame = CGRectMake((kScreenWidth - kAutoScreenWidth(200))/2, kAutoScreenHeight(300), kAutoScreenWidth(200), kAutoScreenHeight(50));
        _checkedButton = [[UIButton alloc] initWithFrame:frame];
        [_checkedButton setTitle:@"checked" forState:UIControlStateNormal];
        [_checkedButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_checkedButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_checkedButton addTarget:self action:@selector(checkedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_checkedButton];
    }
    return _checkedButton;
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

@end
