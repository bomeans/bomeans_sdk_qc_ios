//
//  RecountView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/7/14.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecountViewDelegate <NSObject>

-(void)pressStopButton;

@end

@interface RecountView : UIView

@property (nonatomic, weak) id<RecountViewDelegate> delegate;

-(void)setMsgLableText : (NSString*) text;

@end
