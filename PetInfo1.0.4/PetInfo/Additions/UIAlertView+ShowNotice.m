//
//  UIAlertView+ShowNotice.m
//  hylink
//
//  Created by 李迪 on 14-9-17.
//  Copyright (c) 2014年 lidi. All rights reserved.
//

#import "UIAlertView+ShowNotice.h"

@implementation UIAlertView (ShowNotice)
+ (void)showWithNotice:(NSString *)notice
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:notice delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
