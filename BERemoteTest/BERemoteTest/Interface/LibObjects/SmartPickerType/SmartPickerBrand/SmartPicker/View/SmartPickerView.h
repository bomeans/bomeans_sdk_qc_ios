//
//  SmartPickerView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SmartPickerViewDelegate <NSObject>

- (void)checkedButtonClick:(NSString*)title;

@end

@interface SmartPickerView : UIView

@property (nonatomic, weak) id<SmartPickerViewDelegate>    delegate;
- (void)setCheckedButtonTitle:(NSString*)title;

@end
