//
//  DeviceWifiSetViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import "DeviceWifiSetViewController.h"
#import "DeviceWifiSetView.h"
#import "WSProgressHUD.h"
#import "DataProvider.h"

@interface DeviceWifiSetViewController () <DeviceWifiSetViewDelegate>

@property(nonatomic, strong)DeviceWifiSetView*      myView;
@property(nonatomic, assign)BOOL                    isRunning;
@property(nonatomic, strong)DataProvider*           dataProvider;

@end

@implementation DeviceWifiSetViewController

- (DeviceWifiSetView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[DeviceWifiSetView alloc] initWithFrame:viewFrame];
        _myView.delegate = self;
        _myView.ssidField.text = [self getWifiName];
        [self.view addSubview:_myView];
    }
    return _myView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self myView];
    _isRunning = NO;
    _dataProvider = [DataProvider sharedInstance];
}

//取得目前連線的wifi AP SSID
- (NSString*)getWifiName{
    
    NSString* wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces)
    {
        return nil;
    }
    
    NSArray* interfaces = (__bridge NSArray*)wifiInterfaces;
    
    for (NSString* interfaceName in interfaces)
    {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef)
        {
            NSDictionary* networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
            break;
        }
    }
    
    CFRelease(wifiInterfaces);
    
    return wifiName;
}

-(void)alertWithTitle:(NSString*)title withMessage:(NSString*)msg{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:msg
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - DeiviceWifiSetViewDelegate
//設定紅外線裝置連線的 wifi AP
- (void)broadcastWifiWithSsid:(NSString *)ssid withPassword:(NSString *)password
{
    NSString *title;
    NSString *msg;
    if ([ssid isEqualToString:@""]) {
        title = @"Error";
        msg = @"SSID 不能為空";
    }
    
    int irState = [_dataProvider getWifiIRState];
    if (irState == BIRNotConnectToNetWork) {
        title = @"Error";
        msg = @"未連線至Wifi AP";
    }
    
    if (msg.length > 0) {
        [self alertWithTitle:title withMessage:msg];
        return;
    }
    
    if (_isRunning) {
        return;
    }
    _isRunning = YES;
    
    [_dataProvider.wifi broadcastSSID:ssid passWord:password authMode:AuthModeAutoSwitch waitTime:3 delegate:self];
}

#pragma mark - BIRBroadcastSSID_Delegate
// 通知還在進行broadcast SSID
//  參數:
//    obj  : 為一個 BomeansIRKit
//  second : 已進行了幾秒了
-(void) broadcastSSID : (id) obj
        process       : (int) second
{
    float myProgress = second/3.0f;
    [WSProgressHUD showProgress:myProgress status:@"broadcasting..." maskType:WSProgressHUDMaskTypeGradient];
}

// 通知結束broadcast SSID
//    obj  : 為一個 BomeansIRKit
//   result : 設定結果
//     BIRResultTimeOut,       時間用光結束
//     BIRResultUserCancal     使用者中斷後結束
-(void) broadcastSSID : (id) obj
                end   : (int) result
{
    [WSProgressHUD dismiss];
    _isRunning = NO;
    
    NSString *title;
    NSString *msg;
    
    if (result == BIRResultTimeOut) {
        title = @"Tip";
        msg = @"set wifiToIr connect to wifi AP is complete ";
    }
    
    [self alertWithTitle:title withMessage:msg];
}

@end
