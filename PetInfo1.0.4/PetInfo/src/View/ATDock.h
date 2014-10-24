//
//  QQDock.h
//  01-QQ
//
//  Created by apple on 13-12-13.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATDockItem.h"
@class ATDock;

@protocol ATDockDelegate <NSObject>

@optional
- (void)dock:(ATDock *)dock didSelectedFromIndex:(int)from toIndex:(int)to;

@end

@interface ATDock : UIView

#pragma mark 添加一个Dock上的小按钮
- (void)addDockItem:(NSString *)title icon:(NSString *)icon selectedIcon:(NSString *)selectedIcon;
- (void)itemClick:(ATDockItem *)item;
- (void)itemSelect:(int)index;
@property (nonatomic, assign) id<ATDockDelegate> delegate;
@end
