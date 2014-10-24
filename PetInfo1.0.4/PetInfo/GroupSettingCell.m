//
//  GroupSettingCell.m
//  LandTex
//
//  Created by 海普科技  on 14-7-21.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "GroupSettingCell.h"

@interface GroupSettingCell ()

@end

@implementation GroupSettingCell
@synthesize nameLabel;
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
- (void)dealloc {
  [nameLabel release];
  [super dealloc];
}

@end
