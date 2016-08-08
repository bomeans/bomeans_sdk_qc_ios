//
//  ViewController.h
//  test_oc
//
//  Created by mingo on 2016/5/18.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IR/BIRRemote.h"
#import "IR/BIRTVPicker.h"

@interface MainController : UIViewController

@property NSString *API_KEY ;
//@property NSString *irKit ;

- (NSArray*)getTypeList;
- (NSArray*)getBrandList:(NSString*)typeID;
- (NSArray*)getTop10BrandList:(NSString*)typeID;
- (NSArray*)getRemoteList:(NSString*)typeID andBrand:(NSString*)brandID getNew:(bool)newData;
- (id <BIRRemote>)createRemoter :(NSString*)typeID withBrand:(NSString*)brandID andModel:(NSString*)model getNew:(BOOL)newData;

- (id)createSmartPicker:(NSString*)type withBrand:(NSString*)brand;
//-(void)setAPIKEY;


@end

