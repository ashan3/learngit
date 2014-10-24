//
//  PersonnelmanageCell.m
//  LandTex
//
//  Created by 海普科技  on 14-7-4.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "PersonnelmanageCell.h"

@interface PersonnelmanageCell ()

@end

@implementation PersonnelmanageCell

@synthesize button1,button2,nameLabel,jueseLabel,phoneLabel;

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
  [button1 release];
  [button2 release];
   [nameLabel release];
   [jueseLabel release];
   [phoneLabel release];
  [super dealloc];
}

@end
