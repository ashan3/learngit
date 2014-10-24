//
//  CreatingInitControlStyle.m
//  ThankYou
//
//  Created by cuiwen on 13-10-22.
//  Copyright (c) 2013年 ming. All rights reserved.
//

#import "InitControlStyle.h"



@implementation InitControlStyle
+ (UIButton *)initButtonStyle:(CGRect)rect setTitle:title normal:image1 highlighted:image2{
    CGRect frame = rect;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image2] forState:UIControlStateHighlighted];
    [button setTitle:title forState: UIControlStateNormal];
    return button;
}

+ (UIButton *)initButtonStyle:(UIButton *)button normal:image1 highlighted:image2{
    [button setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image2] forState:UIControlStateHighlighted];
    return button;
}

+ (void)foregroundColor:(UILabel *)lable title:(NSString*)string start:(int)a end:(int)b{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    UIColor *color =  [UIColor colorWithRed:225/255.0 green:114/255.0 blue:0/255.0 alpha:1.0];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(a,b)];
    lable.attributedText = str;
}

@end
