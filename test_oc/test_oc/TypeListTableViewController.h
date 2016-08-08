//
//  TypeListTableViewController.h
//  test_oc
//
//  Created by mingo on 2016/5/24.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeListTableViewController : UITableViewController

@property (nonatomic,strong)NSArray *typeList;

-(NSArray*)getMainCTypeList;

@end
