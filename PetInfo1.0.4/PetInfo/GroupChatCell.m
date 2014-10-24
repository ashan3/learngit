//
//  GroupChatCell.m
//  LandTex
//
//  Created by 海普科技  on 14-7-14.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "GroupChatCell.h"

@interface GroupChatCell ()

@end

@implementation GroupChatCell

@synthesize nameLabel,timeLabel,messageLabel,timeLabel2,nameLabel2,headImage,headImage2;
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
  [timeLabel release];
  [messageLabel release];
    [timeLabel2 release];
    [nameLabel2 release];
    [headImage release];
    [headImage2 release];
  [super dealloc];
}
@end
