//
//  DeviceInfoViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "DeviceInfoView.h"
#import "DataProvider.h"

@interface DeviceInfoViewController () <DeviceiInfoViewDelegate>

@property(nonatomic, strong)DeviceInfoView*     myView;
@property(nonatomic, strong)DataProvider*       dataProvider;

@end

@implementation DeviceInfoViewController

- (DeviceInfoView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[DeviceInfoView alloc] initWithFrame:viewFrame];
        _myView.delegate = self;
        [self.view addSubview:_myView];
    }
    return _myView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMyView];
    }
    return self;
}

- (void)initMyView
{
    self.dataProvider = [DataProvider sharedInstance];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray* irSetArray;
    if (self.segmentedIndex == 0) {
        irSetArray = [[NSArray alloc] init];
    }
    else {
        irSetArray = [[NSArray alloc] initWithObjects:@"忘記此轉發器", nil];
    }
    
    NSArray* irDetailArray = [[NSArray alloc] initWithObjects:[self.wifiIrDict objectForKey:@"name"], [self.wifiIrDict objectForKey:@"ip"], [self.wifiIrDict objectForKey:@"mac"], [self.wifiIrDict objectForKey:@"coreid"], nil];
    
    NSArray *defaultSectionArray = @[@"",@""];
    NSArray *defaultCellArray = @[irSetArray, irDetailArray];
    
    [self.myView getSectionSource:defaultSectionArray];
    [self.myView getDataSoruce:defaultCellArray];
}

#pragma mark - DeviceiInfoViewDelegate
- (void)cellDeleteDevice
{
    NSMutableArray* deviceArray = [[NSMutableArray alloc] initWithArray:[_dataProvider.defaultValue objectForKey:@"deviceArray"]];
    NSString* coreID = [self.wifiIrDict objectForKey:@"coreid"];
    
    for (NSDictionary* dict in deviceArray.copy) {
        NSString* cellName = [dict objectForKey:@"coreid"];
        if ([coreID isEqualToString:cellName]) {
            [deviceArray removeObject:dict];
        }
    }
    
    [_dataProvider.defaultValue setObject:deviceArray forKey:@"deviceArray"];
    [_dataProvider.defaultValue synchronize];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshDevice)]) {
        [self.delegate refreshDevice];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
