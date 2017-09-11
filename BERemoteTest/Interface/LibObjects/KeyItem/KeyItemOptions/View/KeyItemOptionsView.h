//
//  KeyItemOptionsView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/8/16.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseSearchBarView.h"

@protocol KeyItemOptionsViewDelegate <NSObject>

-(void)cellPress:(NSString*)keyId withName:(NSString*)keyName;

@end

@interface KeyItemOptionsView : BaseSearchBarView

@property (weak, nonatomic) id<KeyItemOptionsViewDelegate> delegate;

@end
