//
//  BaseModel.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/14.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (UIViewController *)viewController:(UIView*)aView {
    for (UIView* next = [aView superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
