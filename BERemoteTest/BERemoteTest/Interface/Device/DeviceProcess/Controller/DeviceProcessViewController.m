//
//  DeviceProcessViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/21.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DeviceProcessViewController.h"
#import "DeviceProcessView.h"
#import "DataProvider.h"

@interface DeviceProcessViewController () <DeviceProcessViewDelegate>

@property(nonatomic,strong)DeviceProcessView*   myView;
@property(nonatomic,strong)DataProvider*        dataProvider;

@end

@implementation DeviceProcessViewController

- (DeviceProcessView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _myView = [[DeviceProcessView alloc] initWithFrame:viewFrame];
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
    [self myView];
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

#pragma mark - DeviceProcessViewDelegate
- (void)changedLedLightColorWithRed:(CGFloat)red withGreen:(CGFloat)green withBlue:(CGFloat)blue
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_dataProvider.wifi wifiIRLed_Color:red greenColor:green blueColor:blue];
    });
}

- (void)switchIrPower:(BOOL)OnOff
{
    //NSLog(@"IrPower : %@", OnOff);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_dataProvider.wifi wifiIRSwitch_OnOff:OnOff];
    });
}

- (void)switchIrLed:(BOOL)OnOff
{
    //NSLog(@"IrLed : %@", OnOff);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_dataProvider.wifi wifiIRLed_OnOff:OnOff];
    });
}

- (void)turnOffWifi
{
    [self showAlert:@"注意！關閉後需手動重啟！"];
    [_dataProvider.wifi wifiIR_TuneOffWifi];
}

@end
