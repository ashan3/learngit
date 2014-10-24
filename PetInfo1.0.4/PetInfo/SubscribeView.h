//
//  SubscribeView.h
//  MBA
//
//  Created by 海普科技  on 14-5-20.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ColumnChangedDelegate1  <NSObject>
-(void)columnChanged:(NSArray *)array;
@end
@interface SubscribeView : UITableViewController<ASIRequest>{
    
    NSMutableArray *dataArray;
    NSMutableArray *selArray;
    NSInteger num;
    NSMutableArray *_showNameArray;
}
@property (nonatomic ,assign) id<ColumnChangedDelegate1> eventDelegate;

@end
