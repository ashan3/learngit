//
//  MyCommentView.h
//  MBA
//
//  Created by 海普科技  on 14-5-21.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
@interface MyCommentView : STableViewController{
    NSMutableArray *dataArray;
}
@property (strong, nonatomic) NSString *commentOrCollect;
@end
