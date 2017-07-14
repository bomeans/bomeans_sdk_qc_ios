//
//  RecountView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/7/14.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "RecountView.h"

@interface RecountView()

@property (nonatomic, strong) UILabel*      titleLable;
@property (nonatomic, strong) UILabel*      msgLable;
@property (nonatomic, strong) UIButton*     stopButton;

@end

@implementation RecountView

-(UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, kAutoScreenHeight(10), self.frame.size.width, kAutoScreenHeight(100))];
        [_titleLable setText:@"自動發碼若有反應請按OK鍵"];
        //[_titleLable setFont:[UIFont systemFontOfSize:kAutoScreenWidth(20.0f)]];
        _titleLable.numberOfLines = 0;
        _titleLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLable];
    }
    return _titleLable;
}

-(UILabel *)msgLable
{
    if (!_msgLable) {
        _msgLable = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height/2) - kAutoScreenHeight(50)/2, self.frame.size.width, kAutoScreenHeight(50))];
        [_msgLable setText:@"msgLable"];
        //[_msgLable setFont:[UIFont systemFontOfSize:kAutoScreenWidth(20.0f)]];
        _msgLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_msgLable];
    }
    return _msgLable;
}

-(UIButton *)stopButton
{
    if (!_stopButton) {
        _stopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kAutoScreenHeight(60), self.frame.size.width, kAutoScreenHeight(50))];
        [_stopButton setTitle:@"OK" forState:UIControlStateNormal];
        [_stopButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_stopButton setTitleColor:[self.tintColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [_stopButton addTarget:self action:@selector(stopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_stopButton];
    }
    return _stopButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self loadView];
    }
    return self;
}

- (void)loadView{
    [self titleLable];
    [self msgLable];
    [self stopButton];
}

-(void)setMsgLableText : (NSString*) text
{
    _msgLable.text = text;
}

#pragma mark - button click
- (void)stopButtonClick:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressStopButton)]) {
        [self.delegate pressStopButton];
    }
}
@end
