//
//  AcSampleBrandViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/18.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "AcSampleBrandViewController.h"
#import "BrandItemView.h"
#import "DataProvider.h"
#import "AcSampleModelViewController.h"

@interface AcSampleBrandViewController () <BrandItemViewDelegate>

@property (nonatomic, strong)BrandItemView* myView;
@property (nonatomic, strong)DataProvider*  dataProvider;

@end

@implementation AcSampleBrandViewController

- (BrandItemView*)myView{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[BrandItemView alloc] initWithFrame:viewFrame];
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
    
    [self.myView getDataSoruce:@[[_dataProvider getBrandListWithType:@"2"]]];
}

-(void)dealloc{
    /**
     * 解决退出登录时 UISearchController 报错的相关问题
     */
    [self.myView.searchController.view removeFromSuperview];
}

#pragma mark - BrandItemViewDelegate
-(void)cellPress:(NSString*)brandId withName:(NSString*)brandName{
    AcSampleModelViewController* view = [[AcSampleModelViewController alloc] init];
    view.currentBrand = brandId;
    [self.navigationController pushViewController:view animated:YES];
}

@end
