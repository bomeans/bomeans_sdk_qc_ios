//
//  DataProvider.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/24.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "DataProvider.h"

static NSString* API_KEY=@"apikey"; // Bomeans apikey
static DataProvider* _defaultDataProvider;

@implementation DataProvider

@synthesize defaultValue;
@synthesize irKit;

+ (DataProvider*)defaultDataProvider{
    if (_defaultDataProvider == nil) {
        _defaultDataProvider = [[DataProvider alloc] init];
    }
    return _defaultDataProvider;
}

- (id)init{
    self = [super init];
    if (self) {
        defaultValue = [NSUserDefaults standardUserDefaults];
        // 判斷使用遠端還近端 預設使用近端
        [defaultValue setObject:@"local" forKey:@"wifiToIR"];
        [defaultValue synchronize];
        
        // 設定API KEY
        irKit = [[BomeansIRKit alloc] initWithKey:API_KEY];
        [BomeansIRKit setUseChineseServer:NO]; //預設值:NO=tw, YES=cn

    }
    return self;
}


//language
- (void)setLanguage:(NSString *)aLanguage{
    
}
-(NSString*)language{
    return @"tw";   // server location
}

//取出類型清單
- (NSArray*)getTypeList{
    return [irKit webGetTypeList:language];
}

//取出某類型下的所有廠牌清單
- (NSArray*)getBrandListWithType:(NSString*)typeID
{
    return [irKit webGetBrandList:typeID start:0 number:1800 language:language brandName:nil getNew:false];
}

//取出某類型下的十大廠牌清單
- (NSArray*)getTop10BrandListWithType:(NSString*)typeID
{
    return [irKit webGetTopBrandList:typeID start:0 number:10 language:language getNew:false];
}


//取出某類型&廠牌下所有遙控器清單
- (NSArray*)getModelListWithType:(NSString*)typeID andBrand:(NSString*)brandID getNew:(bool)newData;
{
    return [irKit webGetRemoteModelList:typeID andBrand:brandID getNew:false];
}

//建立一支遙控器
- (id<BIRRemote>) createRemoterWithType:(NSString*)typeID withBrand:(NSString *)brandID andModel:(NSString *)modelID{
    return [irKit createRemoteType:typeID withBrand:brandID andModel:modelID];
}

//建立一支大萬能
- (id<BIRRemote>) createBigCombineRemoterWithType:(NSString*)typeID withBrand:(NSString*)brandID{
    return [irKit createBigCombineRemote:typeID withBrand:brandID getNew:false];
}

//取得智慧選碼參考key
- (NSArray*)getSmartPickerKeyListWithType:(NSString*)typeID{
    return [irKit webGetSmartPickerKeyList:typeID getNew:false];
}

//建立智慧選碼
- (id<BIRTVPicker>) createSmartPickerWithType:(NSString*)typeID withBrand:(NSString*)brandID{
    return [irKit createSmartPicker:typeID withBrand:brandID getNew:false];
}

//取得此key的所有遙控器
- (NSArray*)getKeyName:(NSString*)typeID{
    return [irKit webGetKeyName:typeID language:language getNew:false];
}

//取得小火山連線狀態
- (int)getWifiIRState{
    return [irKit wifiIRState];
}

@end
