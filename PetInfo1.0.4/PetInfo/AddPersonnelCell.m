//
//  AddPersonnelCell.m
//  LandTex
//
//  Created by 海普科技  on 14-7-9.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "AddPersonnelCell.h"

@interface AddPersonnelCell ()

@end

@implementation AddPersonnelCell
@synthesize addbutton,nameLabel,jueseLabel,phoneLabel;

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
  [addbutton release];
  [nameLabel release];
  [jueseLabel release];
  [phoneLabel release];
  [super dealloc];
}

@end
