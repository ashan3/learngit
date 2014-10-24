//
//  GroupSettingsView.h
//  LandTex
//
//  Created by 海普科技  on 14-7-15.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GroupSettingsView : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    IBOutlet UITableView *_tableView;
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) NSString *groupId;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,retain) UIView *headView;
@property (nonatomic, retain) NSMutableArray *dataArray;
-(IBAction)exitGroup:(id)sender;
@end
