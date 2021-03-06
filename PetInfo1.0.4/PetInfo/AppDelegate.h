//
//  AppDelegate.h
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-16.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;
@class ColumnModel;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) MainViewController *mainCtrl;
@property (nonatomic,copy) ColumnModel *pushModel;
@property (strong, nonatomic) UINavigationController *navVC;
@end
