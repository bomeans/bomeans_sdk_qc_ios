//
//  SmartPickerView.h
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACPickerViewDelegate <NSObject>

- (void)checkedButtonClick:(NSString*)title;
- (void)startButtonClick;
- (void)stopButtonClick;

@end

@interface ACPickerView : UIView

@property (nonatomic, weak) id<ACPickerViewDelegate>    delegate;
- (void)setCheckedButtonTitle:(NSString*)title;

@end
