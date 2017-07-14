//
//  AutoDimension.h
//  WaveControl
//
//  Created by 谭云杰 on 16/4/6.
//  Copyright © 2016年 谭云杰. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AutoDimension : NSObject

/**
 * 根据屏幕宽度伸缩比例获取同比例伸缩后的值
 */
+(CGFloat)autoDimensionWidth:(CGFloat)value;

/**
 * 根据屏幕高度伸缩比例获取同比例伸缩后的值
 */
+(CGFloat)autoDimensionHeight:(CGFloat)value;

+(CGFloat)autoDimensioniPhone6Width:(CGFloat)value;
+(CGFloat)autoDimensioniPhone6Height:(CGFloat)value;

@end
