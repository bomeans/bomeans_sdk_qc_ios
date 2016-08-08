//
//  wifiToIRViewController.m
//  test_oc
//
//  Created by mingo on 2016/6/2.
//  Copyright © 2016年 bomeans. All rights reserved.
//
#import <SystemConfiguration/CaptiveNetwork.h>

#import "wifiToIRViewController.h"
#import "MainController.h"

#import "IR/BomeansIRKit.h"
#import "IR/BIRRemote.h"
#import "IR/BomeansDelegate.h"
#import "IR/BomeansWifiToIRDiscovery.h"
#import "IR/BIRIpAndMac.h"
#import "myHW.h"

@interface wifiToIRViewController () <BIRBroadcastSSID_Delegate>
{
    BomeansIRKit *irKit;
    
    MainController *mainC;
}

@end

@implementation wifiToIRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mainC = [[MainController alloc] init];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





//連接小火山裝置狀態
- (IBAction)checkWifiToIrStatus:(UIButton *)sender {
    
    //BOOL checkWifi = [mainC checkWifiIRState];
    
    NSLog(@"%d",self.checkWifiIRState);
    
    //是否有連到小火山
    /*if(self.checkWifiIRState){
        NSLog(@"wifi to IR connected");
    }
    else{
        NSLog(@"wifi to IR didn't connected");
    }*/
    
}


//設定紅外線裝置連線的 wifi AP
- (IBAction)setupWifi:(UIButton *)sender {
    
    int result = [irKit broadcastSSID:[self getWifiName] passWord:@"bome@NS$!416" authMode:AuthModeAutoSwitch waitTime:3 delegate:self];
    

    NSString *msg;
    if(result == BIROK){
        msg = [NSString stringWithFormat:@"set wifiToIr connect to wifi AP SSID:>>%@<< success", self.getWifiName ];
    }
    else{
        msg = [NSString stringWithFormat:@"set wifiToIr connect to wifi AP SSID:>>%@<< fail", self.getWifiName ];
    }
    NSLog(@"%@",msg);
    
    NSLog(@"%d",self.checkWifiIRState);
    
    [self alertMessage:msg];
}


//搜尋 wifiToIR 裝置
- (IBAction)discoveryWifiToIR:(UIButton *)sender {
    
    BomeansWifiToIRDiscovery *wifiIR = [[BomeansWifiToIRDiscovery alloc] init];

    if( [wifiIR discoryBlockTryTime:5] )
    {
        //NSDictionary *all = wifiIR.allWifiToIr;
        //NSEnumerator *enumeratorKey = [all keyEnumerator];
        /*for(NSString *mac in enumeratorKey)
        {
            //NSLog(@"mac is %@",mac);
        }*/
        
        //搜尋所有轉發器裝置
        NSArray *allDevice =wifiIR.allWifiToIr.allValues;
        //NSLog(@"all : %@",allDevice);
        for(BIRIpAndMac *device in allDevice)
        {
            NSString *deviceIP =device.ip;
            NSString *deviceCoreID =device.extraInfo;
            NSLog(@"IP is %@ , coreID is %@",deviceIP, deviceCoreID);
            
            //使用NSUserDefaults方式儲存 wifiToIR device coreID
            NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];

            [defaultValue setObject:deviceCoreID forKey:@"deviceCoreID"];
            [defaultValue setObject:deviceIP forKey:@"deviceIP"];
            
            //NSArray *array2 = @[@"123",@"456"];
            //[defaultValue setObject:array2 forKey:@"Array"];
            
            //NSUserDefaults 同步儲存
            [defaultValue synchronize];
            
            //設定此用此裝置
            [irKit setWifiToIrIP: deviceIP];
        }
    }
    else
    {
        NSLog(@"Not find wifiTO ir");
    }
    
    //NSLog(@"%d",[wifiIR isFind]);
    
}


//使用遠端轉發器發碼
- (IBAction)setRemoteWifiToIR:(UIButton *)sender {
    
    NSString *msg;
    
    //使用NSUserDefaults 取出目前設定的遠端轉發器裝置coreID
    NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
    NSString *deviceCoreID =[defaultValue stringForKey:@"deviceCoreID"];
    
    if(deviceCoreID == nil){
        //找不到遠端wifiToIr裝置
        msg = [NSString stringWithFormat:@"Unset cloud wifiToIr device"];
        
        [irKit setIRHW:nil];                 // 設定給SDK 使用
    }
    else{
        //使用遠端
        [defaultValue setObject:@"cloud" forKey:@"wifiToIR"];
        [defaultValue synchronize];
        
        msg = [NSString stringWithFormat:@"connect to cloud , coreID : %@ ", deviceCoreID];

        bool t = [self checkRemoteWifiToIRLogin:deviceCoreID];
        if(t==YES){
            NSLog(@"y");
        }
        else
            NSLog(@"N");
        
        myHW *myHW_1 = [[myHW alloc] init];     // 建立你的hw
        [irKit setIRHW:myHW_1];                 // 設定給SDK 使用
    }
    
    //[self alertMessage:msg];
    NSLog(@"%@",msg);
    
}


//使用近端轉發器發碼
- (IBAction)setDefaultRemoteWifiToIR:(UIButton *)sender {
    
    NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
    [defaultValue setObject:@"local" forKey:@"wifiToIR"];
    [defaultValue synchronize];
    
    //[irKit setIRHW:nil];                 // 設定給SDK 使用
    
    NSLog(@"connect to local ");
    
}






//小火山是否連線
- (int)checkWifiIRState
{
    return [irKit wifiIRState];
}



//取得目前連線的wifi AP SSID
- (NSString*)getWifiName
{
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


//檢查遠端轉發器是否上線
-(BOOL)checkRemoteWifiToIRLogin:(NSString*)coreID{
    
    NSString *fiviApiUrl = @"http://api.openfivi.com:3000/login";
    
    
    //1.Use NSDictionary
    //NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                          coreID, @"coreid",
    //                          nil];
    //NSData* jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:kNilOptions error:&error];
    
    //2.use json string
    NSString *jsonStr = [NSString stringWithFormat: @"{\"coreid\":\"%@\"}", coreID];
    NSLog(@"Post jsonStr : %@", jsonStr);
    
    NSError *error = nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response;
    NSData *localData = nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fiviApiUrl]];
    [request setHTTPMethod:@"POST"];
    
    if (error == nil)
    {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        // Send the request and get the response
        localData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        //NSString *result = [[NSString alloc] initWithData:localData encoding:NSASCIIStringEncoding];
        //NSLog(@"Post result : %@", result);
        
        
        NSError *jsonError = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:localData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jsonError];
        NSLog(@"Post result : %@", responseDict);
        
        bool success = [responseDict valueForKey:@"success"];
        //NSLog(@"success : %@", success);
        
         return YES;
    }
    else
        return NO;
   
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
