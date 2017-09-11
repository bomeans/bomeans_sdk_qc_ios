//
//  DataProvider+AcRemote.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/8/30.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DataProvider+AcRemote.h"
#import "BIRAcRemote.h"

@implementation DataProvider(AcRemote)

#pragma mark - extension AcRemote Key, temp up/down
//建立一支遙控器
- (id<BIRRemote>) createAcRemoterWithType:(NSString*)typeID withBrand:(NSString *)brandID andModel:(NSString *)modelID{
    id<BIRRemote> remote = [self.irKit createRemoteType:typeID withBrand:brandID andModel:modelID getNew:self.getNew];
    if ([typeID isEqualToString:@"2"]) {
        return (id<BIRRemote>)[[BIRAcRemote alloc] initWithRemote:remote];
    } else {
        return remote;
    }
}

@end
