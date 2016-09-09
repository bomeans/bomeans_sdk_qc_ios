//
//  DataProvider.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/24.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IR/BomeansIRKit.h"
#import "IR/BIRTVPicker.h"

@interface DataProvider : NSObject {
    NSString* language;
}

@property NSUserDefaults* defaultValue;
@property BomeansIRKit* irKit;

+ (DataProvider*)defaultDataProvider;

- (void)setLanguage:(NSString*)aLanguage;//language setter
- (NSString*)language; //language getter

- (NSArray*)getTypeList;
- (NSArray*)getBrandListWithType:(NSString*)typeID;
- (NSArray*)getTop10BrandListWithType:(NSString*)typeID;
- (NSArray*)getModelListWithType:(NSString*)typeID andBrand:(NSString*)brandID getNew:(bool)newData;
- (id<BIRRemote>) createRemoterWithType:(NSString*)typeID withBrand:(NSString *)brandID andModel:(NSString *)modelID;
- (id<BIRRemote>) createBigCombineRemoterWithType:(NSString*)typeID withBrand:(NSString*)brandID;
- (NSArray*)getSmartPickerKeyListWithType:(NSString*)typeID;
- (id<BIRTVPicker>) createSmartPickerWithType:(NSString*)typeID withBrand:(NSString*)brandID;
- (NSArray*)getKeyName:(NSString*)typeID;

- (int)getWifiIRState;

@end
