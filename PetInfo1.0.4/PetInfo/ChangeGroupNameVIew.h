//
//  ChangeGroupNameVIew.h
//  LandTex
//
//  Created by 海普科技  on 14-7-21.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeGroupNameVIew : BaseViewController
{
  
    IBOutlet UITextField *textField;
}

@property (nonatomic,strong) NSString *groupId;
@property (nonatomic,strong) NSString *groupName;

-(IBAction)sender:(id)sender;

@end
