//
//  WifiToIRDisCoveryViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "WifiToIRDisCoveryViewController.h"
#import "WifiToIRDiscoveryView.h"
#import "BomeansWifiToIRDiscovery.h"

#import "BIRIpAndMac.h"

@interface WifiToIRDisCoveryViewController ()

@property (nonatomic, strong) WifiToIRDiscoveryView*    myView;
@property (nonatomic, strong) BomeansWifiToIRDiscovery* discovery;

@end

@implementation WifiToIRDisCoveryViewController

- (WifiToIRDiscoveryView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[WifiToIRDiscoveryView alloc] initWithFrame:viewFrame];
        [self.view addSubview:_myView];
    }
    return _myView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"IRDiscovery";
    [self initMyData];
    [self initMyView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_myView.myTableView reloadData];
    });
}

- (void)initMyData{
    _discovery = [[BomeansWifiToIRDiscovery alloc] init];
    [_discovery discoryTryTime:3 andDelegate:self];
}

- (void)initMyView{
    BIRIpAndMac *item = [[BIRIpAndMac alloc] init];
    item.ip = @"discovering";
    item.mac = @"please wait...";
    [self.myView getDataSoruce:@[@[item]]];
}

#pragma mark - BIRWifiToIRDiscoveryDelegate
-(void)       wifiToIR : (id)obj
            endDiscory : (BOOL)result{
    NSLog(@"result: %@", result?@"YES":@"NO");
    NSLog(@"obj: %@", obj);
    
    BomeansWifiToIRDiscovery *discoveryResult = (BomeansWifiToIRDiscovery*)obj;
    
    [self.myView getDataSoruce:@[discoveryResult.allWifiToIr.allValues]];
}

@end
