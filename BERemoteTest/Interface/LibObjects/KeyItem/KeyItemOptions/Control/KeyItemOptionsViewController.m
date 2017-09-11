//
//  KeyItemOptionsViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/8/16.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "KeyItemOptionsViewController.h"
#import "KeyItemOptionsView.h"
#import "DataProvider.h"
#import "BIRKeyOption.h"

@interface KeyItemOptionsViewController () <KeyItemOptionsViewDelegate>

@property (strong, nonatomic) KeyItemOptionsView*   myView;
@property (strong, nonatomic) DataProvider*         dataProvider;
@property (strong, nonatomic) id<BIRRemote>         remote;

@end

@implementation KeyItemOptionsViewController

- (KeyItemOptionsView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[KeyItemOptionsView alloc] initWithFrame:viewFrame];
        _myView.delegate = self;
        self.definesPresentationContext = YES;
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
    
    _remote = [_dataProvider createRemoterWithType:_currentType withBrand:_currentBrand andModel:_currentModel];
    
    BIRKeyOption* keyOption = [_remote getKeyOption:_currentKeyID];
    NSArray *array = [keyOption options];
    if (!array) {
        array = [NSArray arrayWithObjects:@"", nil];
    }
    
    [self.myView getDataSoruce:@[array]];
}

-(void)dealloc{
    /**
     * 解决退出登录时 UISearchController 报错的相关问题
     */
    [self.myView.searchController.view removeFromSuperview];
}

#pragma mark - KeyItemOptionsViewDelegate
-(void)cellPress:(NSString*)keyId withName:(NSString*)keyName{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
