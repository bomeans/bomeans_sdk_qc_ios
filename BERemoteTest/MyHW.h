//
//  MyHW.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/25.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IR/BIRIRBlaster.h"


@interface MyHW : NSObject <BIRIRBlaster>

-(int) sendData:(NSData *)irBlasterData;
-(int) isConnection;

@end
