//
//  BaseSearchBarView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/14.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseView.h"

@interface BaseSearchBarView : BaseView

@property(nonatomic, assign)BOOL                shouldShowSearchResults;
@property(nonatomic, strong)NSArray*            filteredArray;
@property(nonatomic, strong)UISearchController* searchController;

-(void) configureSearchController;
@end
