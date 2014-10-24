//
//  AnswerViewCell.m
//  MBA
//
//  Created by 海普科技  on 14-5-22.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "AnswerViewCell.h"

@interface AnswerViewCell ()

@end

@implementation AnswerViewCell

@synthesize timeLabel,titleLabel,bgImage,subLabel,nameLabel;
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
    [timeLabel release];
    [titleLabel release];
  [bgImage release];
  [subLabel release];
  [nameLabel release];
  [super dealloc];
}

@end
