//
//  DataProvider+AcRemote.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/8/30.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DataProvider.h"

@interface DataProvider(AcRemote)

- (id<BIRRemote>) createAcRemoterWithType:(NSString*)typeID withBrand:(NSString *)brandID andModel:(NSString *)modelID;

@end
