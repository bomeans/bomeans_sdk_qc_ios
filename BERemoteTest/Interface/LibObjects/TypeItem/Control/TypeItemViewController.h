//
//  TypeItemViewController.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/14.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeItemViewController : UIViewController

@property (nonatomic, copy) void(^sendBack)(NSString *,NSString *);

@end
