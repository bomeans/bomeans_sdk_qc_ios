//
//  MainView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/13.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseView.h"

@protocol MainViewDelegate <NSObject>
- (void)didChangeServer;
- (void)didCheckAll;
@end

@interface MainView : BaseView

@property(nonatomic, weak)id<MainViewDelegate>  delegate;
@property(nonatomic, strong)UIBarButtonItem*    changeServerButton;
@property(nonatomic, strong)UIBarButtonItem*    checkAllButton;
@property(nonatomic, strong)UITabBarItem*       tabBarItem;

@end
