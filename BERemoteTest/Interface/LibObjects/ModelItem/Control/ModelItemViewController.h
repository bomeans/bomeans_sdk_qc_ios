//
//  ModelItemViewController.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelItemViewController : UIViewController

@property (nonatomic, copy) void(^sendBack)(NSString *,NSString *);
@property (nonatomic, strong) NSString*     currentType;
@property (nonatomic, strong) NSString*     currentBrand;

@end
