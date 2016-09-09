//
//  RemoteViewCell.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/6.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "RemoteViewCell.h"

@interface RemoteViewCell (){

}

@end

@implementation RemoteViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) defaultCell:(NSString*)name{
    self.textLabel.text = name;
}

@end
