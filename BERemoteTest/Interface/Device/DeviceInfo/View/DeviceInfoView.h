//
//  DeviceInfoView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseView.h"

@protocol DeviceiInfoViewDelegate <NSObject>

- (void)cellDeleteDevice;

@end

@interface DeviceInfoView : BaseView

@property(nonatomic, weak)id<DeviceiInfoViewDelegate>   delegate;

@end
