//
//  AcSampleView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/18.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseView.h"

@protocol AcSampleViewDelegate <NSObject>

- (void)cellPress:(NSString*)item;

@end

@interface AcSampleView : BaseView

@property (nonatomic, weak) id<AcSampleViewDelegate>    delegate;

@end
