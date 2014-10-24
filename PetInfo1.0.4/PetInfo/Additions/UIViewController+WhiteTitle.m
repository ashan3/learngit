//
//  UIViewController+WhiteTitle.m
//  hylink
//
//  Created by 李迪 on 14-9-7.
//  Copyright (c) 2014年 lidi. All rights reserved.
//

#import "UIViewController+WhiteTitle.h"

@implementation UIViewController (WhiteTitle)

- (void)setTitleWhite
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

@end
