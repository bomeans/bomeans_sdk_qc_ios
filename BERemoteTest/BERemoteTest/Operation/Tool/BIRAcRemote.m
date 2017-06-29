//
//  BIRAcRemote.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/6/28.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BIRAcRemote.h"
#import "BomeansConst.h"
#import "BIRKeyOption.h"

@interface BIRAcRemote ()<BIRRemote>

@property(nonatomic, strong)id<BIRRemote> mBirRemote;
@property(nonatomic, assign)BOOL        mConvertTempKey;
@property(nonatomic, strong)NSString*   IR_ACKEY_TEMP;
@property(nonatomic, strong)NSString*   IR_ACKEY_TEMP_UP;
@property(nonatomic, strong)NSString*   IR_ACKEY_TEMP_DOWN;

@end

@implementation BIRAcRemote

- (instancetype)initWithRemote : (id<BIRRemote>) birRemote
{
    self = [super init];
    if (self) {
        if (nil == birRemote) {
            return nil;
        }
        
        _mBirRemote = birRemote;
        _mConvertTempKey = NO;
        _IR_ACKEY_TEMP = @"IR_ACKEY_TEMP";
        _IR_ACKEY_TEMP_UP = @"IR_ACKEY_TEMP_UP";
        _IR_ACKEY_TEMP_DOWN = @"IR_ACKEY_TEMP_DOWN";
        
        NSArray* keyArray = [_mBirRemote getAllKeys];
        for (NSString* key in keyArray) {
            if ([key isEqualToString:_IR_ACKEY_TEMP]) {
                _mConvertTempKey = YES;
                break;
            }
        }
    }
    return self;
}

// 取得所有的key .. data in array is NSString
-(NSArray*) getAllKeys
{
    if (nil == _mBirRemote) {
        return nil;
    }
    
    if (_mConvertTempKey) {
        NSMutableArray *keyArray = [[_mBirRemote getAllKeys] mutableCopy];
        [keyArray removeObject:_IR_ACKEY_TEMP];
        [keyArray addObject:_IR_ACKEY_TEMP_UP];
        [keyArray addObject:_IR_ACKEY_TEMP_DOWN];
        return [keyArray copy];
    }else{
        return [_mBirRemote getAllKeys];
    }
}

-(int) transmitIR : (NSString*) keyId withOption :(NSString*) option
{
    if (nil == _mBirRemote) {
        return BIRNoImplement;
    }
    
    if (_mConvertTempKey) {
        if ([keyId isEqualToString:_IR_ACKEY_TEMP_DOWN]) {
            BIRKeyOption *currentKeyOptions = [_mBirRemote getKeyOption:_IR_ACKEY_TEMP];
            NSString *nextOption = option;
            if (nextOption == nil) {
                if (currentKeyOptions.currentOption > 0) {
                    nextOption = [currentKeyOptions.options objectAtIndex:currentKeyOptions.currentOption - 1];
                } else {
                    nextOption = [currentKeyOptions.options objectAtIndex:0];
                }
            }
            return [_mBirRemote transmitIR:_IR_ACKEY_TEMP withOption:nextOption];
        }else if ([keyId isEqualToString:_IR_ACKEY_TEMP_UP]){
            BIRKeyOption *currentKeyOptions = [_mBirRemote getKeyOption:_IR_ACKEY_TEMP];
            NSString *nextOption = option;
            if (nextOption == nil) {
                if (currentKeyOptions.currentOption < currentKeyOptions.options.count - 1) {
                    nextOption = [currentKeyOptions.options objectAtIndex:currentKeyOptions.currentOption + 1];
                } else {
                    nextOption = [currentKeyOptions.options objectAtIndex:currentKeyOptions.options.count - 1];
                }
            }
            return [_mBirRemote transmitIR:_IR_ACKEY_TEMP withOption:nextOption];
        }else {
            return [_mBirRemote transmitIR:keyId withOption:option];
        }
    }else{
        return [_mBirRemote transmitIR:keyId withOption:option];
    }
}

// set the internal remote state, without sending out the IR data
-(int) setKeyOption : (NSString*) keyId withOption : (NSString*) option
{
    if (nil == _mBirRemote) {
        return BIRNoImplement;
    }
    
    if (_mConvertTempKey) {
        if ([keyId isEqualToString:_IR_ACKEY_TEMP_UP] || [keyId isEqualToString:_IR_ACKEY_TEMP_DOWN]) {
            return [_mBirRemote setKeyOption:_IR_ACKEY_TEMP withOption:option];
        }
    }
    return [_mBirRemote setKeyOption:keyId withOption:option];
}

// 連續送出key 直到endTransmitIR
-(int) beginTransmitIR : (NSString*) keyId
{
    return [_mBirRemote beginTransmitIR:keyId];
}

-(void) endTransmitIR
{
    [_mBirRemote endTransmitIR];
}

// 取得module name
-(NSString*) getModuleName{
    return [_mBirRemote getModuleName];
}

// 取得 brand name
-(NSString*) getBrandName{
    return [_mBirRemote getBrandName];
}

// for AC use 取得所有的key
// return NSArray with NSString
-(NSArray*) getActiveKeys
{
    if (nil == _mBirRemote) {
        return nil;
    }
    
    if (_mConvertTempKey) {
        NSMutableArray *keyArray = [[_mBirRemote getActiveKeys] mutableCopy];
        [keyArray removeObject:_IR_ACKEY_TEMP];
        [keyArray addObject:_IR_ACKEY_TEMP_UP];
        [keyArray addObject:_IR_ACKEY_TEMP_DOWN];
        return [keyArray copy];
    }else{
        return [_mBirRemote getActiveKeys];
    }
}

// 取得key 的options
-(BIRKeyOption*) getKeyOption: (NSString*) keyId
{
    if (nil == _mBirRemote) {
        return nil;
    }
    
    if (_mConvertTempKey) {
        if ([keyId isEqualToString:_IR_ACKEY_TEMP_UP] || [keyId isEqualToString:_IR_ACKEY_TEMP_DOWN]) {
            return [_mBirRemote getKeyOption:_IR_ACKEY_TEMP];
        }
    }
    return [_mBirRemote getKeyOption:keyId];
}

// 設定要repreat 次數. 只對TV 有用. 小萬能無用
-(void) setRepeatCount : (int)count
{
    [_mBirRemote setRepeatCount:count];
}

-(int) getRepeatCount
{
    return [_mBirRemote getRepeatCount];
}

// 取得AC 的GUI Feature
-(BIRGUIFeature*) getGuiFeature
{
    return [_mBirRemote getGuiFeature];
}

// 取得AC 的timer key
-(NSArray*) getTimerKeys
{
    return [_mBirRemote getTimerKeys];
}

// 設定冷氣的 off time
-(void) setOffTimeHour : (int)h minute :(int) m  second : (int) s
{
    [_mBirRemote setOffTimeHour:h minute:m second:s];
}

// 設定冷氣的 on tim
-(void) setOnTimeHour : (int)h minute :(int) m  secode : (int) s
{
    [_mBirRemote setOnTimeHour:h minute:m secode:s];
}

-(NSArray*) getACStoreDatas
{
    return [_mBirRemote getACStoreDatas];
}

-(BOOL) restoreACStoreDatas : (NSArray*)storeData
{
    return [_mBirRemote restoreACStoreDatas:storeData];
}

@end
