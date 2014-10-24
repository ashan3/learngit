//
//  AddBlackView.h
//  LandTex
//
//  Created by 海普科技  on 14-7-10.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
@interface AddBlackView : STableViewController
{
    NSMutableArray * buttonArray;
    NSMutableArray *dataArray;

}
@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) NSMutableArray *dataArray;
-(IBAction)sender:(id)sender;
@end
