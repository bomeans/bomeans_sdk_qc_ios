//
//  FGLanguageTool.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/16.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//
#define FGGetStringWithKeyFromTable(key, tbl) [[FGLanguageTool sharedInstance] getStringForKey:key withTable:tbl]

#define LANGUAGE_SET @"languageset"
#define CNT @"zh-Hant"
#define CNS @"zh-Hans"
#define EN @"en"

#import <Foundation/Foundation.h>

NSString* Loc(NSString* key);

@interface FGLanguageTool : NSObject

+(id)sharedInstance;

/**
 *  返回table中指定的key的值
 *
 *  @param key   key
 *  @param table table
 *
 *  @return 返回table中指定的key的值
 */
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

/**
 *  改變當前語言
 */
-(void)changeNowLanguage:(int) newLanguageNum;

/**
 *  設置新的語言
 *
 *  @param language 新語言
 */
-(void)setNewLanguage:(NSString*)language;

@property (nonatomic,strong) NSArray* languageArray;

@end
