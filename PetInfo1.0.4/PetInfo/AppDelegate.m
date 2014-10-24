//
//  AppDelegate.m
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-16.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "FileUrl.h"
#import "CSLogInViewController.h"
#import "BaseNavViewController.h"
#import "AccountManager.h"
@implementation AppDelegate
@synthesize pushModel = _pushModel;
#pragma mark 内存管理
- (void)dealloc
{
    [_window release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"welcome.png"]];
  view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
  [self.window addSubview:view];
  [view release];
  [self performSelector:@selector(start:) withObject:view afterDelay:2];

  
  
  
//已经使用过的用户
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kbundleVersion]) {
        
        //设置文件初始化
        NSString *settingPath = [[FileUrl getDocumentsFile] stringByAppendingPathComponent: kSetting_file_name];
        [[NSFileManager defaultManager] createFileAtPath: settingPath contents: nil attributes: nil];
        //设置文件信息
        NSMutableDictionary *settingDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: 1], kFont_Size, [NSNumber numberWithBool: YES], KNews_Push, nil];
        [settingDic writeToFile: settingPath atomically: YES];
    }
    return YES;
}
- (void)start:(UIImageView *)view
{
  [view removeFromSuperview];
  
  if(![[AccountManager manager] isLoginSuccess])
  {
    CSLogInViewController *theVC =
    [[CSLogInViewController alloc] initWithNibName:@"CSLogInViewController" bundle:nil];
    self.window.rootViewController = theVC;
  }
  else
  {
    MainViewController *main = [[MainViewController alloc] init];
    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:main];
    self.window.rootViewController = nav;
  }
  
}
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //设置角标为0
    [application setApplicationIconBadgeNumber:0];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}



@end
