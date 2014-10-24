//
//  AddGroupMember.h
//  LandTex
//
//  Created by 海普科技  on 14-7-21.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"

@interface AddGroupMember : STableViewController{
  NSMutableArray * buttonArray;
  NSMutableArray *dataArray;
 
}
@property (nonatomic,strong) NSString *groupId;
@property (nonatomic, retain)IBOutlet UIButton *confirmBtn;
-(IBAction)sender:(id)sender;

@end
