//
//  DeviceWifiSetView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceWifiSetViewDelegate <NSObject>

- (void)broadcastWifiWithSsid:(NSString*)ssid withPassword:(NSString*)password;

@end

@interface DeviceWifiSetView : UIView

@property(nonatomic, weak)id<DeviceWifiSetViewDelegate> delegate;
@property(nonatomic, strong)UITextField*  ssidField;

@end
