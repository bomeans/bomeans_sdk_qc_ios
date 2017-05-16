//
//  KeyNameView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseSearchBarView.h"

@protocol KeyNameViewDelegate <NSObject>

-(void)cellPress:(NSString*)keyId withName:(NSString*)keyName;

@end

@interface KeyNameView : BaseSearchBarView

@property (nonatomic, weak) id<KeyNameViewDelegate> delegate;

@end
