//
//  LibObjectsViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/15.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "LibObjectsViewController.h"
#import "LibObjectsView.h"
#import "TypeItemViewController.h"
#import "BrandItemViewController.h"
#import "ModelItemViewController.h"
#import "KeyItemViewController.h"
#import "KeyNameViewController.h"
#import "WifiToIRDisCoveryViewController.h"
#import "RemoteTypeViewController.h"
#import "TVPickerBrandViewController.h"
#import "ACPickerBrandViewController.h"
#import "AcSampleBrandViewController.h"

@interface LibObjectsViewController ()<LibObjectsViewDelegate>

@property(nonatomic, strong)LibObjectsView*     myView;

@end

@implementation LibObjectsViewController

- (LibObjectsView*)myView
{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[LibObjectsView alloc] initWithFrame:viewFrame];
        _myView.delegate = self;
        [self.view addSubview:_myView];
    }
    return _myView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarItem = self.myView.tabBarItem;
        self.navigationItem.title = @"Bomeans Objects";
        [self initMyView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)initMyView
{
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    [listArray addObject:@"BIRTypeItem"];
    [listArray addObject:@"BIRBrandItem"];
    [listArray addObject:@"BIRModelItem"];
    [listArray addObject:@"BIRKeyItem"];
    [listArray addObject:@"BIRKeyName"];
    [listArray addObject:@"BomeansWifiToIRDiscovery"];
    
    NSMutableArray *remoteArray = [[NSMutableArray alloc] init];
    [remoteArray addObject:@"BIRRemote"];
    [remoteArray addObject:@"BIRTVPicker"];
    [remoteArray addObject:@"BIRACPicker"];
    
    NSMutableArray *expansionArray = [[NSMutableArray alloc] init];
    [expansionArray addObject:@"BIRVoiceSearchResultItem"];
    
    NSMutableArray *customArray = [[NSMutableArray alloc] init];
    [customArray addObject:@"ACSample"];
    
    NSMutableArray *otherArray = [[NSMutableArray alloc] init];
    [otherArray addObject:@"BomeansIRKit"];
    [otherArray addObject:@"BIRIRBlaster"];
    [otherArray addObject:@"BomeansConst"];
    [otherArray addObject:@"BomeansDelegate"];
    [otherArray addObject:@"BIRRemoteUID"];
    [otherArray addObject:@"BIRIpAndMac"];
    [otherArray addObject:@"BIRGUIFeature"];
    [otherArray addObject:@"BIRKeyOption"];
    
    NSArray *defaultSectionArray = [NSMutableArray arrayWithObjects:@"List", @"Create Remote", @"Expansion", @"Sample", @"Other", nil];
    NSArray *defaultCellArray = [[NSMutableArray alloc] initWithObjects:listArray, remoteArray, expansionArray, customArray, otherArray, nil];
    
    [self.myView getSectionSource:defaultSectionArray];
    [self.myView getDataSoruce:defaultCellArray];
}

#pragma mark - LibObjectsViewDelegate
- (void)cellPressWithIndexPath:(NSIndexPath*)indexPath;
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                TypeItemViewController *view = [[TypeItemViewController alloc] init];
                [self.navigationController pushViewController:view animated:YES];
                view.sendBack = ^(NSString *selectdId,NSString *selectdName){
                    _currentType = selectdId;
                    self.myView.currentType = selectdName;
                    [self.myView.myTableView reloadData];
                };
            }
                break;
            case 1:
            {
                BrandItemViewController *view = [[BrandItemViewController alloc] init];
                view.currentType = self.currentType;
                [self.navigationController pushViewController:view animated:YES];
                view.sendBack = ^(NSString *selectdId,NSString *selectdName){
                    _currentBrand = selectdId;
                    self.myView.currentBrand = selectdName;
                    [self.myView.myTableView reloadData];
                };
            }
                break;
            case 2:
            {
                ModelItemViewController *view = [[ModelItemViewController alloc] init];
                view.currentType = self.currentType;
                view.currentBrand = self.currentBrand;
                [self.navigationController pushViewController:view animated:YES];
                view.sendBack = ^(NSString *selectdId,NSString *selectdName){
                    _currentModel = selectdId;
                    self.myView.currentModel = selectdName;
                    [self.myView.myTableView reloadData];
                };
            }
                break;
            case 3:
            {
                KeyItemViewController *view = [[KeyItemViewController alloc] init];
                view.currentType = self.currentType;
                view.currentBrand = self.currentBrand;
                view.currentModel = self.currentModel;
                [self.navigationController pushViewController:view animated:YES];
            }
                break;
            case 4:
            {
                KeyNameViewController *view = [[KeyNameViewController alloc] init];
                view.currentType = self.currentType;
                [self.navigationController pushViewController:view animated:YES];
            }
                break;
            case 5:
            {
                WifiToIRDisCoveryViewController *view = [[WifiToIRDisCoveryViewController alloc] init];
                [self.navigationController pushViewController:view animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                RemoteTypeViewController *view = [[RemoteTypeViewController alloc] init];
                [self.navigationController pushViewController:view animated:YES];
            }
                break;
            case 1:
            {
                TVPickerBrandViewController *view = [[TVPickerBrandViewController alloc] init];
                [self.navigationController pushViewController:view animated:YES];
            }
                break;
            case 2:
            {
                ACPickerBrandViewController *view = [[ACPickerBrandViewController alloc] init];
                [self.navigationController pushViewController:view animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
            {
                AcSampleBrandViewController *view = [[AcSampleBrandViewController alloc] init];
                [self.navigationController pushViewController:view animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

@end
