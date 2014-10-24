//
//  AnswerView.h
//  MBA
//
//  Created by 海普科技  on 14-5-22.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
#import "FrontViewController.h"
@interface AnswerView : STableViewController{

    NSMutableArray *dataArray ;
    
}
@property (nonatomic, assign) FrontViewController *frontVC;
@property (nonatomic, retain) NSString *statusFlag;
@property(nonatomic, retain)	NSMutableArray	*dataArray;
@end
