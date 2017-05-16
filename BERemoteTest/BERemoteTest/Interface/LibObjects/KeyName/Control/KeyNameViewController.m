//
//  KeyNameViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "KeyNameViewController.h"
#import "KeyNameView.h"
#import "DataProvider.h"

@interface KeyNameViewController () <KeyNameViewDelegate>

@property(nonatomic, strong)KeyNameView*    myView;
@property(nonatomic, strong)DataProvider*   dataProvider;

@end

@implementation KeyNameViewController

- (KeyNameView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[KeyNameView alloc] initWithFrame:viewFrame];
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
    
    NSArray *array = [_dataProvider getKeyName:_currentType];
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
