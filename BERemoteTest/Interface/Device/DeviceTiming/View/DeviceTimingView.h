//
//  DeviceTimingView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/23.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceTimingViewDelegate <NSObject>

- (void)setPowerTimingOn:(int)hour withMinute:(int)min withSecond:(int)sec;
- (void)setPowerTimingOff:(int)hour withMinute:(int)min withSecond:(int)sec;
- (void)setPowerTimingCancer:(int)hour withMinute:(int)min withSecond:(int)sec;
- (void)setLedTimingOn:(int)hour withMinute:(int)min withSecond:(int)sec;
- (void)setLedTimingOff:(int)hour withMinute:(int)min withSecond:(int)sec;
- (void)setLedTimingCancer:(int)hour withMinute:(int)min withSecond:(int)sec;
- (void)setWifiTimingOn:(int)hour withMinute:(int)min withSecond:(int)sec;
- (void)setWifiTimingOff:(int)hour withMinute:(int)min withSecond:(int)sec;
- (void)setWifiTimingCancer:(int)hour withMinute:(int)min withSecond:(int)sec;

@end

@interface DeviceTimingView : UIView

@property(nonatomic,weak)id<DeviceTimingViewDelegate>  delegate;
@property(nonatomic, strong)NSMutableArray* hourArray;
@property(nonatomic, strong)NSMutableArray* minuteArray;

@end
