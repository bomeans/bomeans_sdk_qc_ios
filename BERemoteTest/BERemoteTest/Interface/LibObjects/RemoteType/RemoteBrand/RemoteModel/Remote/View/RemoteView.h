//
//  RemoteView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/18.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseView.h"

@protocol RemoteViewDelegate <NSObject>

- (void)cellPress:(NSString*)item;

@optional
- (void)buttonTouchDown:(NSString*)item;
- (void)buttonTouchCancel:(NSString*)item;

@end

@interface RemoteView : BaseView

@property (nonatomic, weak) id<RemoteViewDelegate>  delegate;

@end
