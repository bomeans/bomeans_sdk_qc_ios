//
//  TypeItemView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/14.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseSearchBarView.h"

@protocol TypeItemViewDelegate <NSObject>

-(void)cellPress:(NSString*)typeId withName:(NSString*)typeName;

@end

@interface TypeItemView : BaseSearchBarView

@property(nonatomic, weak) id<TypeItemViewDelegate> delegate;

@end
