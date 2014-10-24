//
//  AnswerDetailView.h
//  LandTex
//
//  Created by 海普科技  on 14-7-23.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
@interface AnswerDetailView : STableViewController<UIActionSheetDelegate>{
  
    NSInteger selrow;  //点击哪一行
    NSMutableArray *dataArray ;
    
    NSMutableArray *answersArray ;
    NSString* answers;
}
@property (nonatomic,strong)NSDictionary *answerDic;
@property(nonatomic, retain)	NSMutableArray	*dataArray;
@property(nonatomic, retain)	NSString	*answers;
@end
