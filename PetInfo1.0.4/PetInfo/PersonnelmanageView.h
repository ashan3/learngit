//
//  PersonnelmanageView.h
//  LandTex
//
//  Created by 海普科技  on 14-7-4.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
@interface PersonnelmanageView : STableViewController{

    IBOutlet UITableView *tableContent;
    
    NSMutableArray *dataArray;
    
    NSMutableArray *button1Array;//移除按钮数组
    NSMutableArray *button2Array;//黑名单按钮数组

  
}
@property (nonatomic, retain) NSMutableArray *dataArray;//标题列表
@property (nonatomic, retain) NSMutableArray *button1Array;//标题列表
@property (nonatomic, retain) NSMutableArray *button2Array;//标题列表
-(IBAction)sender:(id)sender;
-(IBAction)chackBlack:(id)sender;
@end
