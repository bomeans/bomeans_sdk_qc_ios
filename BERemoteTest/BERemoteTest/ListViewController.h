//
//  ListViewController.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/13.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController

@property (nonatomic,strong) NSString* typeID;
@property (nonatomic,strong) NSString* brandID;
@property (nonatomic,strong) NSString* modelID;
@property (nonatomic,strong) NSString* className;
@property (nonatomic,copy) void(^sendBack)(NSString *,NSString *);

@end
