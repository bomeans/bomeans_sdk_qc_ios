//
//  BrandListViewController.h
//  test_oc
//
//  Created by mingo on 2016/5/24.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandListViewController : UITableViewController

//@property (nonatomic, assign) NSInteger typeRow;
@property (nonatomic, strong) NSString *typeID;
@property (nonatomic,strong) NSArray *brandList;

-(NSArray*)getMainCBrandList;

@end
