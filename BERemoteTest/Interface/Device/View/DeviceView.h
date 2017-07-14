//
//  DeviceView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/16.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseView.h"

@protocol DeviceViewDelegate <NSObject>

- (void)cellCheckState:(NSArray*)cellArray;
- (void)changeSegmented:(NSInteger)index withArray:(NSArray*)cellArray;
- (void)cellChoiceNearDevice:(NSInteger)index withArray:(NSArray*)cellArray;
- (void)cellChoiceFarDevice:(NSInteger)index withArray:(NSArray*)cellArray;
- (void)cellWillShowInfo:(NSInteger)index withArray:(NSArray*)cellArray;
- (void)showWifiSet;
- (void)showTimingSet;
- (void)showDeviceProcess;

@end

@interface DeviceView : BaseView

@property(nonatomic, weak)id<DeviceViewDelegate>    delegate;
@property(nonatomic, strong)UITabBarItem*           tabBarItem;
@property(nonatomic, assign)NSInteger               currentSegmentedIndex;
@property(nonatomic, strong)UISegmentedControl*     segmented;

@end
