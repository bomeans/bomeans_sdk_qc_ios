//
//  TypeItemViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/14.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "TypeItemViewController.h"
#import "TypeItemView.h"
#import "DataProvider.h"

@interface TypeItemViewController () <TypeItemViewDelegate>

@property(nonatomic, strong)TypeItemView*   myView;
@property(nonatomic, strong)DataProvider*   dataProvider;

@end

@implementation TypeItemViewController

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
    
    NSArray *array = [_dataProvider getTypeList];
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

#pragma mark - TypeItemViewDelegate
-(void)cellPress:(NSString*)typeId withName:(NSString*)typeName
{
    self.sendBack(typeId, typeName);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
