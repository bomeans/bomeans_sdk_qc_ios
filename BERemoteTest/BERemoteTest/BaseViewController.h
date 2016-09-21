//
//  BaseViewController.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/12.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UILabel *brandLable;
@property (weak, nonatomic) IBOutlet UILabel *modelLable;
@property (weak, nonatomic) IBOutlet UILabel *createRemoteLable;
@property (weak, nonatomic) IBOutlet UILabel *createBigCombineLable;
@property (weak, nonatomic) IBOutlet UILabel *smartPickerKeyLable;
@property (weak, nonatomic) IBOutlet UILabel *keyLable;
@property (weak, nonatomic) IBOutlet UILabel *createSmartPickerLable;
@end
