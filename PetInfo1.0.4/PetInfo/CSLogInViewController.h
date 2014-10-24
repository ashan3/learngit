//
//  LogInViewController.h
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//


#import "BaseViewController.h"
#import "KeyBoardWithToolBar.h"


@interface CSLogInViewController : BaseViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
   
}
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
@property (nonatomic,assign)BOOL isModel;
+ (void)logOut;
@end
