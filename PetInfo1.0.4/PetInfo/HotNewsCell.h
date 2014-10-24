//
//  HotNewsCell.h
//  LandTex
//
//  Created by 海普科技  on 14-7-14.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotNewsCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UIImageView *headImage;
@property (nonatomic,strong)IBOutlet UILabel    *nameLabel;

@property (nonatomic,strong)IBOutlet UILabel    *timeLabel;
@end
