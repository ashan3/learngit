//
//  MainViewController.h
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "RootViewController.h"
#import "ATDock.h"
#import "SubscribeView.h"
@interface MainViewController : BaseViewController <ColumnChangedDelegate1,ATDockDelegate>{
    //  加载时大图
    //配置文件信息
    NSUserDefaults *_userDefaults;
    RootViewController *_root;
    ATDock *_dock;
}

@end
