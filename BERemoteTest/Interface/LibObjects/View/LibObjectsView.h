//
//  LibObjectsView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/15.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseView.h"

@protocol LibObjectsViewDelegate <NSObject>
- (void)cellPressWithIndexPath:(NSIndexPath*)indexPath;
@end

@interface LibObjectsView : BaseView

@property(nonatomic, weak)id<LibObjectsViewDelegate>      delegate;
@property(nonatomic, strong)UITabBarItem*               tabBarItem;
@property(nonatomic, strong)NSString*       currentType;
@property(nonatomic, strong)NSString*       currentBrand;
@property(nonatomic, strong)NSString*       currentModel;

@end
