//
//  RemoteModelViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/18.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "RemoteModelViewController.h"
#import "ModelItemView.h"
#import "DataProvider.h"
#import "RemoteViewController.h"

@interface RemoteModelViewController () <ModelItemViewDelegate>

@property(nonatomic, strong)ModelItemView*  myView;
@property(nonatomic, strong)DataProvider*   dataProvider;

@end

@implementation RemoteModelViewController

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
    
    [self.myView getDataSoruce:@[[_dataProvider getModelListWithType:self.currentType andBrand:self.currentBrand]]];
    
    UIBarButtonItem *naviButton = [[UIBarButtonItem alloc] initWithTitle:@"小萬能" style:UIBarButtonItemStylePlain target:self action:@selector(createUniversalRemote)];
    self.navigationItem.rightBarButtonItem = naviButton;
}

-(void)dealloc{
    /**
     * 解决退出登录时 UISearchController 报错的相关问题
     */
    [self.myView.searchController.view removeFromSuperview];
}

-(void) createUniversalRemote{
    RemoteViewController* view = [[RemoteViewController alloc] init];
    view.currentType = self.currentType;
    view.currentBrand = self.currentBrand;
    view.currentModel = nil;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - ModelItemViewDelegate
-(void)cellPress:(NSString*)modelId withName:(NSString*)modelName{
    RemoteViewController *view = [[RemoteViewController alloc] init];
    view.currentType = self.currentType;
    view.currentBrand = self.currentBrand;
    view.currentModel = modelId;
    
    [self.navigationController pushViewController:view animated:YES];
}

@end
