//
//  BrandItemView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseSearchBarView.h"

@protocol BrandItemViewDelegate <NSObject>

-(void)cellPress:(NSString*)brandId withName:(NSString*)brandName;

@end

@interface BrandItemView : BaseSearchBarView

@property(nonatomic, weak) id<BrandItemViewDelegate>    delegate;

@end
