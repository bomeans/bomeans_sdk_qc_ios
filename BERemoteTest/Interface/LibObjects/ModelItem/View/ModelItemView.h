//
//  ModelItemView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseSearchBarView.h"

@protocol ModelItemViewDelegate <NSObject>

-(void)cellPress:(NSString*)modelId withName:(NSString*)modelName;

@end

@interface ModelItemView : BaseSearchBarView

@property (nonatomic, weak) id<ModelItemViewDelegate>   delegate;

@end
