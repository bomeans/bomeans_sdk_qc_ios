//
//  DeviceInfoViewController.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceInfoViewControllerDelegate <NSObject>

- (void)refreshDevice;

@end

@interface DeviceInfoViewController : UIViewController

@property(nonatomic,weak)id<DeviceInfoViewControllerDelegate>   delegate;
@property(nonatomic,assign)NSInteger        segmentedIndex;
@property(nonatomic,strong)NSDictionary*    wifiIrDict;

@end
