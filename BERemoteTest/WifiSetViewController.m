//
//  WifiSetViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/9.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//
#import <SystemConfiguration/CaptiveNetwork.h>

#import "WifiSetViewController.h"
#import "DataProvider.h"

@interface WifiSetViewController (){
    DataProvider* _dataProvider;
    __weak IBOutlet UITextField *_ssidField;
    __weak IBOutlet UITextField *_passwordField;
}
@end

@implementation WifiSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataProvider = [DataProvider defaultDataProvider];
    
    NSString* wifiName = [self getWifiName];
    _ssidField.text = wifiName;

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_ssidField isExclusiveTouch]) {
        [_ssidField resignFirstResponder];
    }
    if (![_passwordField isExclusiveTouch]) {
        [_passwordField resignFirstResponder];
    }
}

//設定紅外線裝置連線的 wifi AP
- (IBAction)setupWifi:(UIButton *)sender {
    
    NSString *msg;
    
    if (_ssidField.text == nil) {
        msg = @"Error!! SSID 不能為空";
        [self alertMessage:msg];
        return;
    }
    
    NSString* ssid = _ssidField.text;
    NSString* password = _passwordField.text;

    int result = [_dataProvider.irKit broadcastSSID:ssid passWord:password authMode:AuthModeAutoSwitch waitTime:3 delegate:self];
    
    //NSString *msg;
    if(result == BIROK){
        msg = [NSString stringWithFormat:@"set wifiToIr connect to wifi AP SSID:>>%@<< success", ssid];
    }
    else{
        msg = [NSString stringWithFormat:@"set wifiToIr connect to wifi AP SSID:>>%@<< fail", ssid];
    }
    NSLog(@"%@",msg);
    
    
    //NSLog(@"%d",self.checkWifiIRState);
    
    [self alertMessage:msg];
}

//取得目前連線的wifi AP SSID
- (NSString*)getWifiName{
    
    NSString* wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    //NSLog(@"wifiInterfaces: %@",wifiInterfaces);
    
    if (!wifiInterfaces)
    {
        return nil;
    }
    
    NSArray* interfaces = (__bridge NSArray*)wifiInterfaces;
    
    //NSLog(@"interfaces: %@",interfaces);
    
    for (NSString* interfaceName in interfaces)
    {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        //NSLog(@"dictRef: %@", dictRef);
        
        if (dictRef)
        {
            NSDictionary* networkInfo = (__bridge NSDictionary *)dictRef;
            //NSLog(@"networkInfo: %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
            break;
        }
    }
    
    CFRelease(wifiInterfaces);
    
    return wifiName;
}

-(void)alertMessage:(NSString*)msg{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"message"
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

@end
