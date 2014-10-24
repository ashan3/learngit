//
//  SubscribeViewCell.m
//  MBA
//
//  Created by 海普科技  on 14-5-20.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "SubscribeViewCell.h"
@interface SubscribeViewCell ()

@end

@implementation SubscribeViewCell
@synthesize titleLabel,subLabel,headimage,sleButton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)dealloc{
  [headimage release];
  [titleLabel release];
  [subLabel release];
  [sleButton release];
  [super dealloc];
}

@end
