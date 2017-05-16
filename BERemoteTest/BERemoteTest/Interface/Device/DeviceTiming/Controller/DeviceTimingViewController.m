//
//  DeviceTimingViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/23.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DeviceTimingViewController.h"
#import "DeviceTimingView.h"
#import "DataProvider.h"

@interface DeviceTimingViewController () <DeviceTimingViewDelegate>

@property(nonatomic,strong)DeviceTimingView*    myView;
@property(nonatomic,strong)DataProvider*        dataProvider;

@end

@implementation DeviceTimingViewController

- (DeviceTimingView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _myView = [[DeviceTimingView alloc] initWithFrame:viewFrame];
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
    NSMutableArray* hourArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray* minuteArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < 24; i++) {
        [hourArray addObject:[NSString stringWithFormat:@"%i",i]];
    }
    for (int i = 0; i < 60; i++) {
        [minuteArray addObject:[NSString stringWithFormat:@"%i",i]];
    }
    [self myView];
    _myView.hourArray = hourArray;
    _myView.minuteArray = minuteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataProvider = [DataProvider sharedInstance];
}

-(void)showAlert:(NSString*)msg{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - DeviceTimingViewDelegate
- (void)setPowerTimingOn:(int)hour withMinute:(int)min withSecond:(int)sec
{
    int returnCode;
    returnCode = [_dataProvider.wifi wifiIRSwitch_SetOnTimer:YES hour:hour min:min sec:sec];
    [self showAlert: [NSString stringWithFormat:@"Set IR Power On Timer result: %i", returnCode]];
}
- (void)setPowerTimingOff:(int)hour withMinute:(int)min withSecond:(int)sec
{
    int returnCode;
    returnCode = [_dataProvider.wifi wifiIRSwitch_SetOffTimer:YES hour:hour min:min sec:sec];
    [self showAlert: [NSString stringWithFormat:@"Set IR Power Off Timer result: %i", returnCode]];
}
- (void)setPowerTimingCancer:(int)hour withMinute:(int)min withSecond:(int)sec
{
    int returnCode;
    returnCode = [_dataProvider.wifi wifiIRSwitch_SetOnTimer:NO hour:hour min:min sec:sec];
    returnCode = [_dataProvider.wifi wifiIRSwitch_SetOffTimer:NO hour:hour min:min sec:sec];
    [self showAlert: [NSString stringWithFormat:@"Cancer IR Power Timer result: %i", returnCode]];
}
- (void)setLedTimingOn:(int)hour withMinute:(int)min withSecond:(int)sec
{
    int returnCode;
    returnCode = [_dataProvider.wifi wifiIRLed_SetOnTimer:YES hour:hour min:min sec:sec];
    [self showAlert: [NSString stringWithFormat:@"Set IR Led On Timer result: %i", returnCode]];
}
- (void)setLedTimingOff:(int)hour withMinute:(int)min withSecond:(int)sec
{
    int returnCode;
    returnCode = [_dataProvider.wifi wifiIRLed_SetOffTimer:YES hour:hour min:min sec:sec];
    [self showAlert: [NSString stringWithFormat:@"Set IR Led Off Timer result: %i", returnCode]];
}
- (void)setLedTimingCancer:(int)hour withMinute:(int)min withSecond:(int)sec
{
    int returnCode;
    returnCode = [_dataProvider.wifi wifiIRLed_SetOnTimer:NO hour:hour min:min sec:sec];
    returnCode = [_dataProvider.wifi wifiIRLed_SetOffTimer:NO hour:hour min:min sec:sec];
    [self showAlert: [NSString stringWithFormat:@"Cancer IR Led Timer result: %i", returnCode]];
}
- (void)setWifiTimingOn:(int)hour withMinute:(int)min withSecond:(int)sec
{
    int returnCode;
    returnCode = [_dataProvider.wifi wifiIR_SetOnTimer:YES hour:hour min:min sec:sec];
    [self showAlert: [NSString stringWithFormat:@"Set IR Wifi On Time result: %i", returnCode]];
}
- (void)setWifiTimingOff:(int)hour withMinute:(int)min withSecond:(int)sec
{
    int returnCode;
    returnCode = [_dataProvider.wifi wifiIR_SetOffTimer:YES hour:hour min:min sec:sec];
    [self showAlert: [NSString stringWithFormat:@"Set IR Wifi Off Time result: %i", returnCode]];
}
- (void)setWifiTimingCancer:(int)hour withMinute:(int)min withSecond:(int)sec
{
    int returnCode;
    returnCode = [_dataProvider.wifi wifiIR_SetOnTimer:NO hour:hour min:min sec:sec];
    returnCode = [_dataProvider.wifi wifiIR_SetOffTimer:NO hour:hour min:min sec:sec];
    [self showAlert: [NSString stringWithFormat:@"Cancer IR Wifi Timer result: %i", returnCode]];
}

@end
