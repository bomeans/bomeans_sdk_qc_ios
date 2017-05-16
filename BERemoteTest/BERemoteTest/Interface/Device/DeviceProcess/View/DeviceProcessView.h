//
//  DeviceProcessView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/21.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceProcessViewDelegate <NSObject>

- (void)changedLedLightColorWithRed:(CGFloat)red withGreen:(CGFloat)green withBlue:(CGFloat)blue;
- (void)switchIrPower:(BOOL)OnOff;
- (void)switchIrLed:(BOOL)OnOff;
- (void)turnOffWifi;

@end

@interface DeviceProcessView : UIView

@property(nonatomic,weak)id<DeviceProcessViewDelegate>  delegate;


@end
