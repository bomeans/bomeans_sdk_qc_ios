//
//  AutoDimension.m
//  WaveControl
//
//  Created by 谭云杰 on 16/4/6.
//  Copyright © 2016年 谭云杰. All rights reserved.
//

#import "AutoDimension.h"

@implementation AutoDimension

/**
 * 根据屏幕宽度伸缩比例获取同比例伸缩后的值
 */
+(CGFloat)autoDimensionWidth:(CGFloat)value
{
    //我们按照切图的原始宽度为320计算
    //--->320/320 * 150 = 150  iphone4/5
    return kScreenWidth / 320.0f * value;
}

/**
 * 根据屏幕高度伸缩比例获取同比例伸缩后的值
 */
+(CGFloat)autoDimensionHeight:(CGFloat)value
{
    return kScreenHeight / 568.0f * value;
}

+(CGFloat)autoDimensioniPhone6Width:(CGFloat)value
{
    return kScreenWidth / 375.0f * value;
}

+(CGFloat)autoDimensioniPhone6Height:(CGFloat)value
{
    return kScreenHeight / 667.0f * value;
}

@end
