//
//  BIRACPicker.h
//  IRLib
//
//  Created by Hung Ricky on 2017/3/28.
//  Copyright © 2017年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIRRemoteUID.h"
#import "BIRModelItem.h"

@protocol BIRACPicker <NSObject>

/**
 strat smart picker.
 @return will be send key and model
  key     data type
  keyid   NSString
  model   BIRModelItem
 */
-(NSDictionary*) begin;

/**
 get next key.
 @return next key id.
 */
-(NSString*) getNextKey;

/**
 get next model.
 @return next modelItem.
 */
-(BIRModelItem*) getNextModel;

/**
 transmit ir wave now.
 @return if 'BIROK' mean success, other is fail.
 */
-(int) transmitIR;

/**
 Set whether the key of the current test has an action on the target machine.
 @param haveWork 'YES' mean it's work, 'NO' is no work.
 @return 'BIR_PNext' for try next key, 'BIR_PFind' for find remote, 'BIR_PFail' mean can't find remote.
 */
-(int) keyResult : (BOOL) haveWork;

/**
 get picker's result.
 @return object element is 'BIRRemoteUID'
 @discussion only one object now
 */
-(NSArray*) getPickerResult;

/**
 Set a few keys to test
 @param num : 1~3， default is 3
 @return 'YES' mean success, 'NO' is fail.
 */
-(BOOL)setTryKeyNum:(NSInteger)num;

/**
 get Model Count
 @return count of this picker
 */
-(int)getModelCount;

/**
 get now Model number
 @return number of now Model
 */
-(int)getNowModelNum;

/**
 sequence transmit IR, until call endAutoPicker or transmit last model key
 @return if 'BIROK' mean success, other is fail.
 */
-(int)beginAutoPicker;
-(void)endAutoPicker;

@end


/**
 it's callback for -(int)beginTransmitIR
 interface
 @property (nonatomic, strong) BIRAcAutoPicker*  smartPicker;
 end
 
 @impletematation
 - (void)viewDidLoad {
    _smartPicker = [[BIRAcAutoPicker alloc] init];
    _smartPicker.delegate = self;
 }
 
 -(void)acAutoPickerIndex:(int)index withModel:(BIRModelItem*)model;
 {
    //TODO
 }
 @end
 */
@protocol BIRAcAutoPickerDelegate <NSObject>

-(void)acAutoPickerIndex:(int)index withModel:(BIRModelItem*)model;
-(void)autoPickerNoMatches;

@end


@interface BIRAcAutoPicker : NSObject

@property(nonatomic, weak)id<BIRAcAutoPickerDelegate> delegate;

@end
