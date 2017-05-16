//
//  RemoteTypeViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "RemoteTypeViewController.h"
#import "TypeItemView.h"
#import "DataProvider.h"
#import "RemoteBrandViewController.h"

@interface RemoteTypeViewController () <TypeItemViewDelegate>

@property(nonatomic, strong)TypeItemView*   myView;
@property(nonatomic, strong)DataProvider*   dataProvider;

@end

@implementation RemoteTypeViewController

- (TypeItemView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[TypeItemView alloc] initWithFrame:viewFrame];
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
    
    [self.myView getDataSoruce:@[[_dataProvider getTypeList]]];
}

-(void)dealloc{
    /**
     * 解决退出登录时 UISearchController 报错的相关问题
     */
    [self.myView.searchController.view removeFromSuperview];
}

#pragma mark - TypeItemViewDelegate
-(void)cellPress:(NSString*)typeId withName:(NSString*)typeName{
    RemoteBrandViewController* view = [[RemoteBrandViewController alloc] init];
    view.currentType = typeId;
    [self.navigationController pushViewController:view animated:YES];
}

@end
