//
//  AnswerViewCell.h
//  MBA
//
//  Created by 海普科技  on 14-5-22.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerViewCell : UITableViewCell


@property (nonatomic,strong)IBOutlet UILabel *titleLabel;
@property (nonatomic,strong)IBOutlet UILabel *subLabel;
@property (nonatomic,strong)IBOutlet UILabel *timeLabel;

@property (nonatomic,strong)IBOutlet UILabel *nameLabel;
@property (nonatomic,strong)IBOutlet UIImageView *bgImage;


@end
