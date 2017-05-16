//
//  AcSampleModelViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/18.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "AcSampleModelViewController.h"
#import "ModelItemView.h"
#import "DataProvider.h"
#import "ACSampleViewController.h"

@interface AcSampleModelViewController () <ModelItemViewDelegate>

@property (nonatomic, strong) ModelItemView*    myView;
@property (nonatomic, strong) DataProvider*     dataProvider;

@end

@implementation AcSampleModelViewController

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
    
    [self.myView getDataSoruce:@[[_dataProvider getModelListWithType:@"2" andBrand:self.currentBrand]]];
    
    UIBarButtonItem *naviButton = [[UIBarButtonItem alloc] initWithTitle:@"小萬能" style:UIBarButtonItemStylePlain target:self action:@selector(createACUniversalRemote)];
    self.navigationItem.rightBarButtonItem = naviButton;
}

-(void)dealloc{
    /**
     * 解决退出登录时 UISearchController 报错的相关问题
     */
    [self.myView.searchController.view removeFromSuperview];
}

-(void) createACUniversalRemote{
    ACSampleViewController* view = [[ACSampleViewController alloc] initWithNibName:@"ACSampleViewController" bundle:nil];
    view.typeID = @"2";
    view.brandID = self.currentBrand;
    view.modelID = nil;
    view.brandName = @"小萬能";
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - ModelItemViewDelegate
-(void)cellPress:(NSString*)modelId withName:(NSString*)modelName{
    ACSampleViewController *view = [[ACSampleViewController alloc] initWithNibName:@"ACSampleViewController" bundle:nil];
    view.typeID = @"2";
    view.brandID = self.currentBrand;
    view.modelID = modelId;
    
    [self.navigationController pushViewController:view animated:YES];
}

@end
