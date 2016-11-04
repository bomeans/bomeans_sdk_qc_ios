//
//  IRDetailViewController.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/10.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRDetailViewController : UITableViewController
@property NSInteger segmentedIndex;
@property (nonatomic,strong) NSDictionary* wifiIrDict;
@property (nonatomic,copy) void(^sendBack)();
@end
