//
//  BaseViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/12.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "BaseViewController.h"
#import "FGLanguageTool.h"
#import "DataProvider.h"
#import "MyHW.h"
#import "IR/BIRTypeItem.h"
#import "IR/BIRBrandItem.h"
#import "IR/BIRModelItem.h"

@interface BaseViewController ()
{
    DataProvider* _dataProvider;
    id<BIRRemote> _remoter;
    id<BIRRemote> _remoterBig;
    id<BIRTVPicker> _picker;

}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化model
    _dataProvider = [DataProvider defaultDataProvider];
    
    // 設定使用中國大陸地區的web server 供web api 跟create remote 使用
    NSString* wifiToIr = [_dataProvider.defaultValue stringForKey:@"wifiToIR"];
    if ([wifiToIr isEqualToString:@"cloud"]) {
        //使用自定義的HW(遠端)
        MyHW* myHW1 = [[MyHW alloc]init];
        [_dataProvider.irKit setIRHW:myHW1];
    }
    else{
        [_dataProvider.irKit setIRHW:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //self.tableView
    [self.tableView reloadData];
}

- (IBAction)checkAll:(UIBarButtonItem *)sender {
    NSArray* typeList = [_dataProvider getTypeList];
    NSArray* brandList = [_dataProvider getBrandListWithType:@"1"];
    NSArray* modelList = [_dataProvider getModelListWithType:@"1" andBrand:@"12" getNew:false];
    //類型清單
    self.typeLable.text = [NSString stringWithFormat:@"typeCount : %lu", typeList.count];
    //廠牌清單
    self.brandLable.text = [NSString stringWithFormat:@"brandCount : %lu", brandList.count];
    //型號清單
    self.modelLable.text = [NSString stringWithFormat:@"remoteCount : %lu", modelList.count];
    
    
    BIRTypeItem* type = typeList[0];
    BIRBrandItem* brand = brandList[592];
    BIRModelItem* model = modelList[0];
    _remoter = [_dataProvider createRemoterWithType:type.typeId withBrand:brand.brandId andModel:model.model];
    //_remoter = [_dataProvider createRemoterWithType:@"2" withBrand:@"1509" andModel:@"ELECTROLUX_KKCQ_1K"];
    //NSLog(@"elc key: %@", [_remoter getActiveKeys]);
    NSLog(@"type:%@, brand:%@, model:%@",type.typeId,brand.brandId,model.model);
    //創建遙控器
    self.createRemoteLable.text = [NSString stringWithFormat:@"%@", [_remoter getModuleName]];
    //按鍵清單
    self.keyLable.text = [NSString stringWithFormat:@"keyCount : %lu",[_remoter getAllKeys].count];
    
    NSArray* fanBrandArray = [_dataProvider getBrandListWithType:@"8"];
    BIRBrandItem* fanBrand = fanBrandArray[1];
    id<BIRRemote> remoteFan = [_dataProvider createBigCombineRemoterWithType:@"8" withBrand:fanBrand.brandId];
    NSLog(@"%@, %@, %lu",fanBrand.name,fanBrand.brandId,[remoteFan getAllKeys].count);
    //NSLog(@"%@",[remoteFan getAllKeys]);
    
    NSArray* ampBrandArray = [_dataProvider getBrandListWithType:@"9"];
    BIRBrandItem* ampBrand = ampBrandArray[1];
    id<BIRRemote> remoteAmp = [_dataProvider createBigCombineRemoterWithType:@"9" withBrand:ampBrand.brandId];
    NSLog(@"%@, %@, %lu",ampBrand.name,ampBrand.brandId,[remoteAmp getAllKeys].count);
    
    NSArray* dvdBrandArray = [_dataProvider getBrandListWithType:@"5"];
    BIRBrandItem* dvdBrand = dvdBrandArray[1];
    id<BIRRemote> remoteDVD = [_dataProvider createBigCombineRemoterWithType:@"5" withBrand:dvdBrand.brandId];
    NSLog(@"%@, %@, %lu",dvdBrand.name,dvdBrand.brandId,[remoteDVD getAllKeys].count);
    
    //創建大萬能
    _remoterBig = [_dataProvider createBigCombineRemoterWithType:type.typeId withBrand:brand.brandId];
    self.createBigCombineLable.text = [NSString stringWithFormat:@"remoter's key : %lu",[_remoterBig getAllKeys].count];
    
    //智慧選碼按鍵
    NSArray* keyList = [_dataProvider getSmartPickerKeyListWithType:@"1"];
    self.smartPickerKeyLable.text = [NSString stringWithFormat:@"smartKeys : %lu", keyList.count];
    
    //智慧選碼
    _picker = [_dataProvider createSmartPickerWithType:type.typeId withBrand:brand.brandId];
    self.createSmartPickerLable.text = [NSString stringWithFormat:@"%@", [_picker begin]];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    header.textLabel.text = Loc(header.textLabel.text);
    
}


@end
