//
//  NoticeViewCell.m
//  MBA
//
//  Created by 海普科技  on 14-5-21.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "NoticeViewCell.h"

@interface NoticeViewCell ()

@end

@implementation NoticeViewCell

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
  [_titleLabel release];
  [_timeLabel release];
  [super dealloc];
}
@end
