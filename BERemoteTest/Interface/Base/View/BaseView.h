//
//  BaseView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/16.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

@property(nonatomic, retain)UITableView*    myTableView;
@property(nonatomic, copy)NSArray*          sectionArray;
@property(nonatomic, copy)NSArray*          cellArray;

- (void)getSectionSource:(NSArray*)array;
- (void)getDataSoruce:(NSArray*)array;

@end
