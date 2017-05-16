//
//  DataProvider.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/24.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "DataProvider.h"
#import "MyHW.h"

static NSString* API_KEY= @""; // Bomeans apikey
static DataProvider* _initDataProvider;

@implementation DataProvider

@synthesize defaultValue;
@synthesize irKit;
@synthesize wifi;

//Sington class
+ (DataProvider*)sharedInstance{
    if (_initDataProvider == nil) {
        _initDataProvider = [[DataProvider alloc] init];
    }
    return _initDataProvider;
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
        wifi = [[BomeansWifiToIR alloc] init];
        _getNew = YES;
        //[BomeansIRKit setUseChineseServer:NO]; //預設值:NO=tw, YES=cn
        [BomeansIRKit setServer:BIRServerTW];
        [self setLanguage:@"tw"];
    }
    return self;
}

//language
- (void)setLanguage:(NSString *)aLanguage{
    language = aLanguage;
}
-(NSString*)language{
    return language;   // server location
}

//IRHW
- (void)setIRHW:(BIRDataServer)aIRHW{
    // 設定使用中國大陸地區的web server 供web api 跟create remote 使用
    switch (aIRHW) {
        case BIRCloud:
        {
            [defaultValue setObject:@"cloud" forKey:@"wifiToIR"];
            //使用自定義的HW(遠端)
            MyHW* myHW1 = [[MyHW alloc]init];
            [irKit setIRHW:myHW1];
        }
            break;
        case BIRLocal:
        {
            [defaultValue setObject:@"local" forKey:@"wifiToIR"];
            [irKit setIRHW:wifi];
        }
            break;
            
        default:
            break;
    }
    [defaultValue synchronize];
}
- (BIRDataServer)IRHW{
    NSString* wifiToIR = [defaultValue stringForKey:@"wifiToIR"];
    BIRDataServer irhw;
    if ([wifiToIR isEqualToString:@"local"]) {
        irhw = BIRLocal;
    }else{
        irhw = BIRCloud;
    }
    return irhw;
}

//取出類型清單
- (NSArray*)getTypeList{
    return [irKit webGetTypeList:language getNew:_getNew];
}

//取出某類型下的所有廠牌清單
- (NSArray*)getBrandListWithType:(NSString*)typeID
{
    return [irKit webGetBrandList:typeID start:0 number:1800 language:language brandName:nil getNew:_getNew];
}

//取出某類型下的十大廠牌清單
- (NSArray*)getTop10BrandListWithType:(NSString*)typeID
{
    return [irKit webGetTopBrandList:typeID start:0 number:10 language:language getNew:_getNew];
}

//取出某類型&廠牌下所有遙控器清單
- (NSArray*)getModelListWithType:(NSString*)typeID andBrand:(NSString*)brandID;
{
    return [irKit webGetRemoteModelList:typeID andBrand:brandID getNew:_getNew];
}

//建立一支遙控器
- (id<BIRRemote>) createRemoterWithType:(NSString*)typeID withBrand:(NSString *)brandID andModel:(NSString *)modelID{
    return [irKit createRemoteType:typeID withBrand:brandID andModel:modelID getNew:_getNew];
}

//建立一支大萬能
- (id<BIRRemote>) createBigCombineRemoterWithType:(NSString*)typeID withBrand:(NSString*)brandID{
    return [irKit createBigCombineRemote:typeID withBrand:brandID getNew:_getNew];
}

//取得智慧選碼參考key
- (NSArray*)getSmartPickerKeyListWithType:(NSString*)typeID{
    return [irKit webGetSmartPickerKeyList:typeID getNew:_getNew];
}

//建立智慧選碼
- (id<BIRTVPicker>) createTVSmartPickerWithType:(NSString*)typeID withBrand:(NSString*)brandID{
    return [irKit createSmartPicker:typeID withBrand:brandID getNew:_getNew];
}

//建立智慧選碼
- (id<BIRACPicker>) createACSmartPickerWithBrand:(NSString*)brandID{
    return [irKit createSmartPicker:@"2" withBrand:brandID getNew:_getNew];
}

//取得此type的所有遙控器key
- (NSArray*)getKeyName:(NSString*)typeID{
    return [irKit webGetKeyName:typeID language:language getNew:_getNew];
}

//語音發碼
-(BIRVoiceSearchResultItem*) webVSearch : (NSString*)voiceCommand{
    return [irKit webVSearch:voiceCommand language:language];
}

//取得小火山連線狀態
- (int)getWifiIRState{
    return [wifi wifiIRState];
    //return [wifi isConnection];
}

@end
