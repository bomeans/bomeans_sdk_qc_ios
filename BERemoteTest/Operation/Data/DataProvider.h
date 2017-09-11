//
//  DataProvider.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/24.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BomeansIRKit.h"
#import "BIRTVPicker.h"
#import "BIRACPicker.h"
#import "BomeansWifiToIR.h"

typedef NS_ENUM(NSUInteger, BIRDataServer){
    BIRLocal,
    BIRCloud
};

@interface DataProvider : NSObject {
    NSString* language;
}

@property (nonatomic, strong) NSUserDefaults*   defaultValue;
@property (nonatomic, strong) BomeansIRKit*     irKit;
@property (nonatomic, strong) BomeansWifiToIR*  wifi;
@property (nonatomic, assign) BOOL              getNew;

+ (DataProvider*)sharedInstance;

- (void)setLanguage:(NSString*)aLanguage;//language setter
- (NSString*)language; //language getter
- (BIRDataServer)IRHW;
- (void)setIRHW:(BIRDataServer)aIRHW;

- (NSArray*)getTypeList;
- (NSArray*)getBrandListWithType:(NSString*)typeID;
- (NSArray*)getTop10BrandListWithType:(NSString*)typeID;
- (NSArray*)getModelListWithType:(NSString*)typeID andBrand:(NSString*)brandID;

- (id<BIRRemote>) createRemoterWithType:(NSString*)typeID withBrand:(NSString *)brandID andModel:(NSString *)modelID;
- (id<BIRRemote>) createBigCombineRemoterWithType:(NSString*)typeID withBrand:(NSString*)brandID;
- (NSArray*)getSmartPickerKeyListWithType:(NSString*)typeID;
- (id<BIRTVPicker>) createTVSmartPickerWithType:(NSString*)typeID withBrand:(NSString*)brandID;
- (id<BIRACPicker>) createACSmartPickerWithBrand:(NSString*)brandID;
- (NSArray*)getKeyName:(NSString*)typeID;
- (BIRVoiceSearchResultItem*) webVSearch : (NSString*)voiceCommand;
- (int)getWifiIRState;

@end
