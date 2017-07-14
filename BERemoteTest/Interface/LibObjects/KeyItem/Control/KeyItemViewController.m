//
//  KeyItemViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "KeyItemViewController.h"
#import "KeyItemView.h"
#import "DataProvider.h"

@interface KeyItemViewController () <KeyItemViewDelegate>

@property(nonatomic, strong)KeyItemView*    myView;
@property(nonatomic, strong)DataProvider*   dataProvider;
@property(nonatomic, strong)id<BIRRemote>   remote;

@end

@implementation KeyItemViewController

- (KeyItemView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[KeyItemView alloc] initWithFrame:viewFrame];
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
    if (!_currentType) {
        self.currentType = @"1";
    }
    if (!_currentBrand) {
        self.currentBrand = @"12";
    }
    if (!_currentModel) {
        self.currentModel = @"LCD100";
    }
    
    _remote = [_dataProvider createRemoterWithType:_currentType withBrand:_currentBrand andModel:_currentModel];
    
    NSArray *array = [_remote getAllKeys];
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

#pragma mark - KeyItemViewDelegate
-(void)cellPress:(NSString*)keyId withName:(NSString*)keyName{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
