//
//  RegisterUserNameViewController.h
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseViewController.h"
#import "KeyBoardWithToolBar.h"
@interface CSRegisterUserNameViewController : BaseViewController <KeyBoardWithToolBarDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    KeyBoardWithToolBar *_keyBoardWithToolBar;
}
- (IBAction)registerButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
@end
