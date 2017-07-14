//
//  AcSampleViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/18.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "AcSampleViewController.h"
#import "AcSampleView.h"
#import "DataProvider.h"

@interface AcSampleViewController () <AcSampleViewDelegate>

@property (nonatomic, strong) AcSampleView* myView;
@property (nonatomic, strong) DataProvider* dataProvider;
@property (nonatomic, strong) id<BIRRemote> remote;

@end

@implementation AcSampleViewController

- (AcSampleView*)myView{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[AcSampleView alloc] initWithFrame:viewFrame];
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
    [self myView];
    _remote = [_dataProvider createRemoterWithType:@"2" withBrand:_currentBrand andModel:_currentModel];
    NSArray *array;
    array = [_remote getAllKeys];
    [_myView getDataSoruce:@[array]];
}

#pragma mark - AcSampleViewDelegate
- (void)cellPress:(NSString*)item{
    [_remote transmitIR:item withOption:nil];
}

@end
