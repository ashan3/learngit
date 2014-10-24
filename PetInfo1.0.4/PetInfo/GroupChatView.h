//
//  GroupChatView.h
//  LandTex
//
//  Created by 海普科技  on 14-7-14.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
@interface GroupChatView : STableViewController <UIAlertViewDelegate>
{

    NSMutableArray *dataArray;
    IBOutlet UIView *footView;
    IBOutlet UITextField *messageField;
    NSString *messageId;
  
}
@property (nonatomic,strong) NSString *messageId;
@property (nonatomic,strong) NSString *groupId;
@property (nonatomic,strong) NSString *OWNERUSERID;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) NSString *groupName;
-(id)initWithGroupId:(NSString *)_groupId;
-(IBAction)senderMessage:(id)sender;
@end
