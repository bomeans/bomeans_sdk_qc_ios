//
//  RemoteModelViewController.h
//  test_oc
//
//  Created by mingo on 2016/5/26.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IR/BomeansIRKit.h"
#import "IR/BIRModelItem.h"

@interface RemoteModelViewController : UIViewController

@property (nonatomic, weak) NSString *typeID;
@property (nonatomic, weak) NSString *brandID;
@property (nonatomic, weak) NSString *remoteID;


-(id <BIRRemote>)getMainCRemoteModel;

@end
