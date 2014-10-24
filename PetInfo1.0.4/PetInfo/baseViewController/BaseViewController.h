//
//  BaseViewController.h
//  tabbartest
//
//  Created by 佐筱猪 on 13-10-15.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
@class FMDatabase;
@class MBProgressHUD;
@interface BaseViewController : UIViewController <UIActionSheetDelegate,UINavigationControllerDelegate>{
    UIWindow *_tipWindow;
    MBProgressHUD           *baseHud;
}

//@property(nonatomic,assign)BOOL isBackButton; //navigation 返回

//返回appdelegate
-(AppDelegate *)appDelegate;
//显示加载提示
- (BOOL)showHUD:(NSString *)title isDim:(BOOL)isDim;
//显示加载完成提示
- (void)showHUDComplete:(NSString *)title;
//隐藏加载提示
- (void)hideHUD;
//设置状态栏提示
-(void)showStaticTip:(BOOL)show title:(NSString *)title;
//提示登录对话框
-(void)alertLoginView;

//判断当前网络是否存在。存在则正常访问，不存在则提示当前网络不存在
-(BOOL)getConnectionAlert;

- (void)showWaiting:(UIView *)parent;
- (void)hideWaiting:(UIView *)parent;

//取消按钮
@property (nonatomic,assign)BOOL isCancelButton;

//加载框
@property(nonatomic,retain)MBProgressHUD *hud;
//当前网络状态
//数据库
@property (nonatomic,retain) FMDatabase *db;


-(void)setStateBarHidden :(BOOL) statusBarHidden;
-(void)setTitle:(NSString *)title;
-(void)promptWithString:(NSString *)str;
@end
