//
//  SmartPickerTypeViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/18.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "SmartPickerTypeViewController.h"
#import "TypeItemView.h"
#import "DataProvider.h"
#import "SmartPickerBrandViewController.h"

@interface SmartPickerTypeViewController () <TypeItemViewDelegate>

@property(nonatomic, strong)TypeItemView*   myView;
@property(nonatomic, strong)DataProvider*   dataProvider;

@end

@implementation SmartPickerTypeViewController

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
    if ([typeId isEqualToString:@"2"]) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"AC type please choice ACPicker" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    SmartPickerBrandViewController *view = [[SmartPickerBrandViewController alloc] init];
    view.typeID = typeId;
    view.typeName = typeName;
    [self.navigationController pushViewController:view animated:YES];
}

@end
