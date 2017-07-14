//
//  RemoteViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/18.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "RemoteViewController.h"
#import "RemoteView.h"
#import "DataProvider.h"

@interface RemoteViewController () <RemoteViewDelegate>

@property (nonatomic, strong) RemoteView*   myView;
@property (nonatomic, strong) DataProvider* dataProvider;
@property (nonatomic, strong) id<BIRRemote> remote;

@end

@implementation RemoteViewController

- (RemoteView*)myView{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[RemoteView alloc] initWithFrame:viewFrame];
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
    if ([_currentType isEqualToString:@"2"]) {
        _remote = [_dataProvider createAcRemoterWithType:_currentType withBrand:_currentBrand andModel:_currentModel];
    }else{
        _remote = [_dataProvider createRemoterWithType:_currentType withBrand:_currentBrand andModel:_currentModel];
    }
    
    NSArray *array;
    if ([_currentType isEqualToString:@"2"]) {
        array = [_remote getActiveKeys];
    }else{
        array = [_remote getAllKeys];
    }
    [_myView getDataSoruce:@[array]];
}

#pragma mark - RemoteViewDelegate
- (void)cellPress:(NSString*)item
{
    [_remote transmitIR:item withOption:nil];
}

- (void)buttonTouchDown:(NSString*)item
{
    [_remote beginTransmitIR:item];
}

- (void)buttonTouchCancel:(NSString*)item
{
    [_remote endTransmitIR];
}
@end
