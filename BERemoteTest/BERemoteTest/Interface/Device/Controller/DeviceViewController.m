//
//  DeviceViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/16.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DeviceViewController.h"
#import "DeviceView.h"
#import "DataProvider.h"
#import "BomeansWifiToIRDiscovery.h"
#import "BIRIpAndMac.h"
#import "DeviceInfoViewController.h"
#import "DeviceWifiSetViewController.h"
#import "DeviceTimingViewController.h"
#import "DeviceProcessViewController.h"

@interface DeviceViewController ()<DeviceViewDelegate, BIRWifiToIRDiscoveryDelegate, DeviceInfoViewControllerDelegate>

@property(nonatomic, strong)DeviceView*     myView;
@property(nonatomic, strong)DataProvider*   dataProvider;
@property(nonatomic, strong)BomeansWifiToIRDiscovery*   discovery;

@end

@implementation DeviceViewController

- (DeviceView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[DeviceView alloc] initWithFrame:viewFrame];
        _myView.delegate = self;
        [self.view addSubview:_myView];
    }
    return _myView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMyData];
        [self initMyView];
        self.tabBarItem = self.myView.tabBarItem;
        self.navigationItem.title = @"Device Manager";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initMyData
{
    _dataProvider = [DataProvider sharedInstance];
}

- (void)initMyView
{
    NSMutableArray* irStateArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray* wifiIrArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"轉發器", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"近端轉發器狀態", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wifi設定", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"定時設定", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Led及電源控制", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    
    NSArray *defaultSectionArray = [NSMutableArray arrayWithObjects:@"", @"選擇轉發器", nil];
    NSArray *defaultCellArray = [[NSMutableArray alloc] initWithObjects:irStateArray, wifiIrArray, nil];
    
    [self.myView getDataSoruce:defaultCellArray];
    [self.myView getSectionSource:defaultSectionArray];
}

//檢查遠端轉發器是否上線
-(BOOL)checkFarDeviceLogin:(NSString*)coreID{
    
    NSString *fiviApiUrl = @"http://api.openfivi.com:3000/login";
    
    
    //1.Use NSDictionary
    //NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                          coreID, @"coreid",
    //                          nil];
    //NSData* jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:kNilOptions error:&error];
    
    //2.use json string
    NSString *jsonStr = [NSString stringWithFormat: @"{\"coreid\":\"%@\"}", coreID];
    NSLog(@"Post jsonStr : %@", jsonStr);
    
    NSError __block *sendError = nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse __block *sendResponse;
    NSData __block *localData = nil;
    
    BOOL __block reqProcessed = false;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fiviApiUrl]];
    [request setHTTPMethod:@"POST"];
    
    if (sendError == nil)
    {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        // Send the request and get the response
        //localData = [NSURLConnection sendSynchronousRequest:request returningResponse:&sendResponse error:&sendError];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            localData = data;
            sendError = error;
            sendResponse = response;
            reqProcessed = true;
        }] resume];
        
        while (!reqProcessed) {
            [NSThread sleepForTimeInterval:0];
        }
        
        //NSString *result = [[NSString alloc] initWithData:localData encoding:NSASCIIStringEncoding];
        //NSLog(@"Post result : %@", result);
        
        
        NSError *jsonError = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:localData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jsonError];
        NSLog(@"Post result : %@", responseDict);
        
        NSString* success = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"success"]];
        //NSLog(@"success : %@", success);
        
        if ([success isEqualToString:@"1"]) {
            return YES;
        }else return NO;
    }
    else
        return NO;
    
}

#pragma mark - BIRWifiToIRDiscoveryDelegate
-(NSArray*)discoveryWifiToIR{
    _discovery = [[BomeansWifiToIRDiscovery alloc] init];
    
    NSMutableArray* deviceArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    if(( [_discovery discoryBlockTryTime:5] ) || (_discovery.allWifiToIr.allValues.count > 0))
    {
        //搜尋所有轉發器裝置
        NSArray *devices = _discovery.allWifiToIr.allValues;

        for(BIRIpAndMac *device in devices)
        {
            NSString *deviceName = [device.extraInfo substringFromIndex:(device.extraInfo.length - 4)];
            NSString *deviceIP = device.ip;
            NSString *deviceMAC = device.mac;
            NSString *deviceCoreID = device.extraInfo;
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:deviceName, @"name", deviceIP, @"ip", deviceMAC, @"mac", deviceCoreID, @"coreid", nil];
            
            [deviceArray addObject:dict];
        }
    }
    else
    {
        NSLog(@"Not find wifiTO ir");
    }
    [_discovery cancelNext];
    
    return deviceArray;
}

#pragma mark - DeviceViewDelegate
- (void)cellCheckState:(NSArray*)cellArray
{
    int irState = [_dataProvider getWifiIRState];
    NSLog(@"wifi's State: %i",irState);
    NSLog(@"current Wifi: %@",[_dataProvider.wifi getWifiToIrIP]);
    
    NSString* state;
    
    switch (irState) {
        case BIROK:
            state = @"已連線";
            break;
        case BIRNotConnectToNetWork:
            //state = @"未連線至網路";
            state = @"未連線至Wifi";
            break;
        case BIRNotFindWifiToIR:
            state = @"找不到轉發器";
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:[[cellArray objectAtIndex:0] objectAtIndex:1]];
    [dict setValue:state forKey:@"ip"];
    
    [[cellArray objectAtIndex:0] replaceObjectAtIndex:1 withObject:dict];
    [self.myView getDataSoruce:cellArray];
}

- (void)changeSegmented:(NSInteger)index withArray:(NSArray *)cellArray
{
    NSMutableArray* deviceArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    switch (index) {
        case 0:
        {
            [_dataProvider setIRHW:BIRLocal];
            deviceArray = [NSMutableArray arrayWithArray:[self discoveryWifiToIR]];
        }
            break;
        case 1:
        {
            deviceArray = [[NSMutableArray alloc] initWithArray:[_dataProvider.defaultValue objectForKey:@"deviceArray"]];
            
            for (int i = 0; i < deviceArray.count; i++) {
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:deviceArray[i]];
                NSString* irCoreID = [dict objectForKey:@"coreid"];
                
                bool onLineBool = [self checkFarDeviceLogin:irCoreID];
                if (onLineBool) {
                    [dict setValue:@"線上" forKey:@"ip"];
                }else [dict setValue:@"離線" forKey:@"ip"];
                
                [deviceArray replaceObjectAtIndex:i withObject:dict];
            }
            
            //遠端時先改為群體廣播...清空近端時的裝置設定用 可不清
            [_dataProvider.wifi setWifiToIrIP: nil];
            
            [_dataProvider setIRHW:BIRCloud];
        }
            break;
        default:
            break;
    }
    
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:cellArray];
    [mArray replaceObjectAtIndex:1 withObject:deviceArray];
    [self.myView setCurrentSegmentedIndex:index];
    [self.myView getDataSoruce:mArray];
}

- (void)cellChoiceNearDevice:(NSInteger)index withArray:(NSArray *)cellArray
{
    NSMutableArray* deviceArray = [[NSMutableArray alloc] initWithArray:[_dataProvider.defaultValue objectForKey:@"deviceArray"]];
    
    NSDictionary* dict = [[cellArray objectAtIndex:1] objectAtIndex:index];
    NSString* deviceIP = [dict objectForKey:@"ip"];
    if (deviceIP) {
        //設定此用此裝置
        [_dataProvider.wifi setWifiToIrIP: deviceIP];
    }
    
    bool dataexist = false;
    
    for (NSDictionary* deviceDict in deviceArray) {
        NSString* deviceName = [deviceDict objectForKey:@"name"];
        NSString* cellName = [dict objectForKey:@"name"];
        if ([deviceName isEqualToString:cellName]) {
            dataexist = true;
            break;
        }
    }
    if (!dataexist) {
        [deviceArray addObject:dict];
        [_dataProvider.defaultValue setObject:deviceArray forKey:@"deviceArray"];
        [_dataProvider.defaultValue synchronize];
    }
}

- (void)cellChoiceFarDevice:(NSInteger)index withArray:(NSArray *)cellArray
{
    NSDictionary* dict = [[cellArray objectAtIndex:1] objectAtIndex:index];
    NSString* coreID = [dict valueForKey:@"coreid"];
    [_dataProvider.defaultValue setObject:coreID forKey:@"deviceCoreID"];
    [_dataProvider.defaultValue synchronize];
}

- (void)cellWillShowInfo:(NSInteger)index withArray:(NSArray *)cellArray
{
    DeviceInfoViewController* view = [[DeviceInfoViewController alloc] init];
    view.wifiIrDict = [[cellArray objectAtIndex:1] objectAtIndex:index];
    view.segmentedIndex = self.myView.currentSegmentedIndex;
    view.delegate = self;
    view.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:view animated:YES];
}

- (void)showWifiSet
{
    DeviceWifiSetViewController* view = [[DeviceWifiSetViewController alloc] init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)showTimingSet
{
    DeviceTimingViewController* view = [[DeviceTimingViewController alloc] init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)showDeviceProcess
{
    DeviceProcessViewController* view = [[DeviceProcessViewController alloc] init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - DeviceInfoViewControllerDelegate

- (void)refreshDevice
{
    NSMutableArray* deviceArray = [[NSMutableArray alloc] initWithCapacity:1];
    deviceArray = [[NSMutableArray alloc] initWithArray:[_dataProvider.defaultValue objectForKey:@"deviceArray"]];
    
    for (int i = 0; i < deviceArray.count; i++) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:deviceArray[i]];
        NSString* irCoreID = [dict objectForKey:@"coreid"];
        
        bool onLineBool = [self checkFarDeviceLogin:irCoreID];
        if (onLineBool) {
            [dict setValue:@"線上" forKey:@"ip"];
        }else [dict setValue:@"離線" forKey:@"ip"];
        
        [deviceArray replaceObjectAtIndex:i withObject:dict];
    }
    
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.myView.cellArray];
    [mArray replaceObjectAtIndex:1 withObject:deviceArray];
    [self.myView getDataSoruce:mArray];
}

@end
