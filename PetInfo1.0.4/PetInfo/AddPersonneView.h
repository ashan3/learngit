//
//  AddPersonneView.h
//  LandTex
//
//  Created by 海普科技  on 14-7-9.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
@interface AddPersonneView : STableViewController{

    
    NSMutableArray * buttonArray;
    NSMutableArray *dataArray;
}
@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain)IBOutlet UIButton *confirmBtn;
-(IBAction)sender:(id)sender;
@end
