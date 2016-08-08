//
//  myHW.m
//  test_oc
//
//  Created by mingo on 2016/6/17.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import "myHW.h"
#import "IR/BomeansConst.h"

@implementation myHW

// 使用你的方法送出bomeans irBlaster format data
//   return : 正常送出. 請return BIROK(0)
//  其他為錯誤. 錯誤代碼可參考BomeansConst.h 中的BIRError
//   如為您的自訂代碼. 請大於 BIR_CustomerErrorBegin(0x40000000)
-(int) sendData : (NSData*) irBlasterData
{
    //const uint8_t *bytes=(const uint8_t*)irBlasterData.bytes;
    //NSLog(@"%lu", (unsigned long)irBlasterData.length);
    //NSInteger size = irBlasterData.length;
    /*for(NSInteger index = 0 ; index < size ; ++index)
     {
     printf("第 %ld 筆資料 : %xH\n",(long)index, bytes[index]);
     }*/
    
    //
    NSLog(@"Post jsonStr : %@", irBlasterData);
    
    //get coreID
    NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
    NSString *deviceCoreID =[defaultValue stringForKey:@"deviceCoreID"];
    
    
    NSString *irBlasterString = [NSString stringWithFormat: @"%@",irBlasterData];
    irBlasterString = [irBlasterString stringByReplacingOccurrencesOfString:@"<"  withString:@""];
    irBlasterString = [irBlasterString stringByReplacingOccurrencesOfString:@">" withString:@""];
    irBlasterString = [irBlasterString stringByReplacingOccurrencesOfString:@" "withString:@""];
    
    NSLog(@"irBlasterString : %@",irBlasterString);
    
    irBlasterString = [irBlasterString uppercaseString];
    
    //取出irBlasterString長度
    NSString *irBlasterString_length = [NSString stringWithFormat:@"%02lu",(unsigned long)[irBlasterString length]];
    //NSLog(@"total length : %@", [NSString stringWithFormat:@"%02lu",(unsigned long)[irBlasterString length]]);
    
    
    
    //計算需要call api幾次
    NSInteger postCount = ([irBlasterString_length intValue]/400) + 1;
    NSLog(@"postCount : %ld", (long)postCount);
    
    NSInteger end_flag;
    NSString *jsonStr;
    NSString *jsonStr_do;
    for(NSInteger index = 0 ; index < postCount ; ++index)
    {
        long start_pos = 0;
        long end_pos = 400;
        
        if((index+1)==postCount){
            end_flag = 1;
            //計算要取出的字串長度 起始位置
            if(index==0){
                start_pos = index*400;
                end_pos = (unsigned long)[irBlasterString length];
            }
            else{
                start_pos = index*400;
                end_pos = (unsigned long)[irBlasterString length] - start_pos;
            }
            
        }
        else{
            end_flag=0;
            //計算要取出的字串長度 起始位置
            start_pos = index*400;
            end_pos = 400;
        }
        
        NSLog(@"start_pos : %ld",start_pos);
        NSLog(@"end_pos : %ld",end_pos);
        
        
        jsonStr_do = [irBlasterString substringWithRange:NSMakeRange(start_pos, end_pos)];
        NSLog(@"jsonStr_do : %@",jsonStr_do);
        
        jsonStr = [NSString stringWithFormat: @"{\"coreid\":\"%@\",\"order\":{\"Flag\":\"%ld\",\"Data\":\"%@\"}}", deviceCoreID, (long)end_flag, jsonStr_do];
        
        // 使用您的方法把 irBlasterData 傳送出去
        // (此data 已轉換成Bomeans 的irBlaster 所需要的資料格式, 無須再次轉換)
        [self sendToCloud:jsonStr];
    }
    
    
    return BIROK;
}


// 設備是否連接了
//  如有連接請回傳 BIROK(0) 其他為錯誤. 錯誤代碼可參考BomeansConst.h 中的BIRError
//   如為您的自訂代碼. 請大於 BIR_CustomerErrorBegin(0x40000000)
-(int) isConnection{
    return BIROK;
}


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


@end
