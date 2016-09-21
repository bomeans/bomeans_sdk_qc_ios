//
//  BIRIRBlaster.h
//  IRLib
//
//  Created by ldj on 2015/12/17.
//  Copyright (c) 2015年 lin. All rights reserved.
//
//  自訂送出Bomeans irBlaster 的介面(
//
#ifndef IRLib_BIRIRBlaster_h
#define IRLib_BIRIRBlaster_h


#import <Foundation/Foundation.h>


@protocol BIRIRBlaster

@required

// 使用你的方法送出bomeans irBlaster format data
//   return :
//    正常送出. 請return BIROK(0)
//  其他為錯誤. 錯誤代碼可參考BomeansConst.h 中的BIRError
//   如為您的自訂代碼. 請大於 BIR_CustomerErrorBegin(0x40000000)
-(int) sendData : (NSData*) irBlasterData;


// 設備是否連接了
//  如有連接請回傳 BIROK(0)
//  其他為錯誤. 錯誤代碼可參考BomeansConst.h 中的BIRError
//   如為您的自訂代碼. 請大於 BIR_CustomerErrorBegin(0x40000000)
-(int) isConnection;




@end




#endif
