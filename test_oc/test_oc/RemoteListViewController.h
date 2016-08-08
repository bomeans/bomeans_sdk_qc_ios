//
//  RemoteListViewController.h
//  test_oc
//
//  Created by mingo on 2016/5/25.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteListViewController : UITableViewController

@property (nonatomic, weak) NSString *typeID;
@property (nonatomic, weak) NSString *brandID;
@property (nonatomic, weak) NSString *remoteID;
@property (nonatomic,strong)NSArray *remoteList;
-(NSArray*)getMainCRemoteList;

@end
