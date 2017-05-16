//
//  MyHW.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/25.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "MyHW.h"
#import "BomeansConst.h"
#import "DataProvider.h"

@interface MyHW ()
{
    DataProvider* _dataProvider;
}
@end

@implementation MyHW

-(instancetype)init{
    self = [super init];
    if (self) {
        _dataProvider = [DataProvider sharedInstance];
    }
    return self;
}

#pragma mark - BIRIRBlaster
// 使用你的方法送出bomeans irBlaster format data
//   return : 正常送出. 請return BIROK(0)
//  其他為錯誤. 錯誤代碼可參考BomeansConst.h 中的BIRError
//   如為您的自訂代碼. 請大於 BIR_CustomerErrorBegin(0x40000000)
-(int) sendData:(NSData *)irBlasterData{
    
        
    return 0;
}

// 設備是否連接了
//  如有連接請回傳 BIROK(0) 其他為錯誤. 錯誤代碼可參考BomeansConst.h 中的BIRError
//   如為您的自訂代碼. 請大於 BIR_CustomerErrorBegin(0x40000000)
-(int) isConnection{
    return BIROK;
}

@end
