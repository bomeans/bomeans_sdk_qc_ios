//
//  ModelItemViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "ModelItemViewController.h"
#import "ModelItemView.h"
#import "DataProvider.h"

@interface ModelItemViewController () <ModelItemViewDelegate>

@property(nonatomic, strong)ModelItemView*  myView;
@property(nonatomic, strong)DataProvider*   dataProvider;

@end

@implementation ModelItemViewController

- (ModelItemView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[ModelItemView alloc] initWithFrame:viewFrame];
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
    NSArray *array = [_dataProvider getModelListWithType:_currentType andBrand:_currentBrand];
    if (!array) {
        array = [NSArray arrayWithObjects:[[BIRModelItem alloc] init], nil];
    }
    [self.myView getDataSoruce:@[array]];
}

-(void)dealloc{
    /**
     * 解决退出登录时 UISearchController 报错的相关问题
     */
    [self.myView.searchController.view removeFromSuperview];
}

#pragma mark - ModelItemViewDelegate
-(void)cellPress:(NSString*)modelId withName:(NSString*)modelName{
    self.sendBack(modelId, modelName);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
