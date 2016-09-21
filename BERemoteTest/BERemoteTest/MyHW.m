//
//  MyHW.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/25.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "MyHW.h"
#import "IR/BomeansConst.h"
#import "DataProvider.h"

@interface MyHW ()
{
    DataProvider* _dataProvider;
}
@end

@implementation MyHW

//遠端發碼
-(BOOL)sendToCloud:(NSString*)jsonStr{
    
    NSLog(@"Post jsonStr : %@", jsonStr);
    
    NSString *fiviApiUrl = @"http://api.openfivi.com:3000/ctrl";
    NSError *error = nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response;
    NSData *localData = nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fiviApiUrl]];
    [request setHTTPMethod:@"POST"];
    
    if (error == nil)
    {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        // Send the request and get the response
        localData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSString *result = [[NSString alloc] initWithData:localData encoding:NSASCIIStringEncoding];
        NSLog(@"Post result : %@", result);
    }
    
    return YES;
}

#pragma mark - BIRIRBlaster
// 使用你的方法送出bomeans irBlaster format data
//   return : 正常送出. 請return BIROK(0)
//  其他為錯誤. 錯誤代碼可參考BomeansConst.h 中的BIRError
//   如為您的自訂代碼. 請大於 BIR_CustomerErrorBegin(0x40000000)
-(int) sendData:(NSData *)irBlasterData{
    
    NSLog(@"Post jsonStr : %@", irBlasterData);
    
    //get coreID
    NSString* deviceCoreID = [_dataProvider.defaultValue stringForKey:@"deviceCoreID"];
    
    NSString* irBlasterString = [NSString stringWithFormat:@"%@",irBlasterData];
    irBlasterString = [irBlasterString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    irBlasterString = [irBlasterString stringByReplacingOccurrencesOfString:@">" withString:@""];
    irBlasterString = [irBlasterString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"irBlasterString : %@", irBlasterString);
    
    irBlasterString = [irBlasterString uppercaseString];
    
    //取出irBlasterString長度
    NSString* irBlasterStringLength = [NSString stringWithFormat:@"%02lu", [irBlasterString length]];
    
    //計算需要call api幾次
    NSInteger postCount = ([irBlasterStringLength intValue]/400) + 1;
    NSLog(@"postCount : %ld", (long)postCount);
    
    NSInteger end_flag;
    NSString* jsonStr;
    NSString* jsonStr_do;
    for (NSInteger index = 0; index < postCount; ++index) {
        long start_pos = 0;
        long end_pos = 400;
        
        if ((index+1) == postCount) {
            end_flag = 1;
            //計算要取出的字串長度 起始位置
            if (index == 0) {
                start_pos = index * 400;
                end_pos = [irBlasterString length];
            }else {
                start_pos = index * 400;
                end_pos = [irBlasterString length] - start_pos;
            }
        }else {
            end_flag = 0;
            //計算要取出的字串長度 起始位置
            start_pos = index * 400;
            end_pos = 400;
        }
        
        NSLog(@"start_pos : %ld", start_pos);
        NSLog(@"end_pos : %ld", end_pos);
        
        jsonStr_do = [irBlasterString substringWithRange:NSMakeRange(start_pos, end_pos)];
        NSLog(@"jsonStr_do : %@", jsonStr_do);
        
        jsonStr = [NSString stringWithFormat:@"{\"coreid\":\"%@\",\"order\":{\"Flag\":\":\"%ld\",\"Data\":\"%@\"}}", deviceCoreID, end_flag, jsonStr_do];
        
        // 使用您的方法把 irBlasterData 傳送出去
        // (此data 已轉換成Bomeans 的irBlaster 所需要的資料格式, 無須再次轉換)
        [self sendToCloud:jsonStr];
    }
    
    return 0;
}

// 設備是否連接了
//  如有連接請回傳 BIROK(0) 其他為錯誤. 錯誤代碼可參考BomeansConst.h 中的BIRError
//   如為您的自訂代碼. 請大於 BIR_CustomerErrorBegin(0x40000000)
-(int) isConnection{
    return BIROK;
}

@end
