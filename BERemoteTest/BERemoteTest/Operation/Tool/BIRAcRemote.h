//
//  BIRAcRemote.h
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//
//  Just an wrapper for the AC remote (BIRRemote).
//
//  Some users prefer having the traditional TEMP UP/DOWN button instead of setting the temperature
//  directly. Just wrap the original BIRRemote in this class you will get TEMP_UP/DOWN keys instead
//  of a signal TEMP key.
//
//  Usage:
//  When creating a AC remote:
//
//  BomeansIRKit* irKit = [[BomeansIRKit alloc] initWithKey:API_KEY];
//  id<BIRRemote> remote = [irKit createRemoteType:typeID withBrand:brandID andModel:modelID getNew:_getNew];
//  if ([typeID isEqualToString:@"2"]) {
//      remote = (id<BIRRemote>)[[BIRAcRemote alloc] initWithRemote:remote];
//  }
//

#import <UIKit/UIKit.h>
#import "BIRRemote.h"

@interface BIRAcRemote : NSObject

- (instancetype)initWithRemote : (id<BIRRemote>) birRemote;

@end
