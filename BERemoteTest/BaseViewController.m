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
    _dataProvider = [DataProvider initDataProvider];
    
    [_dataProvider setIRHW:[_dataProvider IRHW]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //self.tableView
    [self.tableView reloadData];
}

- (IBAction)checkAll:(UIBarButtonItem *)sender {
    NSArray* typeList = [_dataProvider getTypeList];
    NSArray* brandList = [_dataProvider getBrandListWithType:@"1"];
    NSArray* modelList = [_dataProvider getModelListWithType:@"1" andBrand:@"12" getNew:YES];
    //類型清單
    self.typeLable.text = [NSString stringWithFormat:@"typeCount : %lu", typeList.count];
    //廠牌清單
    self.brandLable.text = [NSString stringWithFormat:@"brandCount : %lu", brandList.count];
    //型號清單
    self.modelLable.text = [NSString stringWithFormat:@"remoteCount : %lu", modelList.count];
    
    brandList = [_dataProvider getTop10BrandListWithType:@"1"];
    
    BIRTypeItem* type = typeList[0];
    BIRBrandItem* brand = brandList[0]; //BIRBrandItem* brand = brandList[592];
    modelList = [_dataProvider getModelListWithType:type.typeId andBrand:brand.brandId getNew:YES];
    BIRModelItem* model = modelList[0];
    //_remoter = [_dataProvider createRemoterWithType:@"test" withBrand:@"test" andModel:@"test"];
    _remoter = [_dataProvider createRemoterWithType:type.typeId withBrand:brand.brandId andModel:model.model];
    //_remoter = [_dataProvider createRemoterWithType:@"2" withBrand:@"1509" andModel:@"ELECTROLUX_KKCQ_1K"];
    //NSLog(@"elc key: %@", [_remoter getActiveKeys]);
    NSLog(@"type:%@, brand:%@, model:%@",type.typeId,brand.brandId,model.model);
    //創建遙控器
    self.createRemoteLable.text = [NSString stringWithFormat:@"%@ %@", [_remoter getBrandName], [_remoter getModuleName]];
    //按鍵清單
    self.keyLable.text = [NSString stringWithFormat:@"keyCount : %lu",[_remoter getAllKeys].count];
    
    //NSLog(@"%@",[_remoter getAllKeys]);
    //[_remoter transmitIR:@"IR_KEY_CHANNEL_DOWN" withOption:nil];
    
    /**大萬能測試區
    for (int i = 1; i < 9; i++) {
        NSArray* BrandArray = [_dataProvider getBrandListWithType:[NSString stringWithFormat:@"%i",i]];
        BIRBrandItem* Brand = BrandArray[i];
        id<BIRRemote> remote = [_dataProvider createBigCombineRemoterWithType:[NSString stringWithFormat:@"%i",i] withBrand:Brand.brandId];
        NSLog(@"big %i %@, %@, %lu", i, Brand.name,Brand.brandId,[remote getAllKeys].count);
    }
    大萬能測試區**///
    
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

-(void)clearData{
    self.typeLable.text = @"";
    self.brandLable.text = @"";
    self.modelLable.text = @"";
    self.createRemoteLable.text = @"";
    self.keyLable.text = @"";
    self.createBigCombineLable.text = @"";
    self.smartPickerKeyLable.text = @"";
    self.createSmartPickerLable.text = @"";
    
}

- (IBAction)apiServerChangeButtonClick:(UIBarButtonItem *)sender {
    if ([self.navigationItem.title isEqualToString:@"TW"]) {
        [self clearData];
        self.navigationItem.title = @"CN";
        [BomeansIRKit setUseChineseServer:YES]; //預設值:NO=tw, YES=cn
        [_dataProvider setLanguage:@"cn"];
    }
    else {
        [self clearData];
        self.navigationItem.title = @"TW";
        [BomeansIRKit setUseChineseServer:NO]; //預設值:NO=tw, YES=cn
        [_dataProvider setLanguage:@"tw"];
    }
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
