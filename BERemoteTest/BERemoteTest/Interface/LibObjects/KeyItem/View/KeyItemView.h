//
//  KeyItemView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseSearchBarView.h"

@protocol KeyItemViewDelegate <NSObject>

-(void)cellPress:(NSString*)keyId withName:(NSString*)keyName;

@end

@interface KeyItemView : BaseSearchBarView

@property (nonatomic, weak) id<KeyItemViewDelegate> delegate;

@end
