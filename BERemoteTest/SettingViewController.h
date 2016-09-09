//
//  SettingViewController.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/15.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *languageLable;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end
