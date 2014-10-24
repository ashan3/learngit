//
//  BaseViewController.m
//  tabbartest
//
//  Created by 佐筱猪 on 13-10-15.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "FileUrl.h"
#import "BaseViewController+StatusBarStyle.h"
#import "ThemeManager.h"
#import "MainViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark 适配ios7
-(void)setStateBarHidden :(BOOL) statusBarHidden{
    if (WXHLOSVersion()>=7.0) {
        [self setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setStatusBarHidden:statusBarHidden];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:statusBarHidden];
    }
}
-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(AppDelegate *)appDelegate{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    return  appDelegate;
}
//判断当前网络是否存在。存在则正常访问，不存在则提示当前网络不存在
-(BOOL)getConnectionAlert{
    if ([DataCenter isConnectionAvailable]) {
        return YES;
    }else{
        [self showHUD:INFO_NetNoReachable isDim:YES];
        [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
        return NO;
    }
}
-(void)promptWithString:(NSString *)str{
	MBProgressHUD *toastHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES delegateTarget:self];
	toastHUD.mode = MBProgressHUDModeText;
	toastHUD.labelText = str;
	toastHUD.margin = 10.f;
	toastHUD.yOffset = -20.f;
	toastHUD.removeFromSuperViewOnHide = YES;
	[toastHUD hide:YES afterDelay:1.3];
}
//显示加载提示
- (BOOL )showHUD:(NSString *)title isDim:(BOOL)isDim {
  
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([DataCenter isConnectionAvailable]) {
        self.hud.labelText = title;
        self.hud.dimBackground = isDim;
        return YES;
    }else{
        self.hud.removeFromSuperViewOnHide =YES;
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = NSLocalizedString(INFO_NetNoReachable, nil);
        self.hud.minSize = CGSizeMake(132.f, 108.0f);
        [self.hud hide:YES afterDelay:3];
        return NO;
        
    }

}
//显示加载完成提示
- (void)showHUDComplete:(NSString *)title {
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
}

//隐藏加载提示
- (void)hideHUD {
    [self.hud hide:YES];
}
//状态栏提示
-(void)showStaticTip:(BOOL)show title:(NSString *)title{
    if(_tipWindow==nil){
        _tipWindow =[[UIWindow alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        _tipWindow.windowLevel=UIWindowLevelStatusBar;
        _tipWindow.backgroundColor=[UIColor blackColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        label.textAlignment=UITextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label.backgroundColor=[UIColor clearColor];
        label.tag=13;
        [_tipWindow addSubview:label];
        
        UIImageView *progress=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]];
        progress.tag=14;
        progress.frame=CGRectMake(0, 20-6, 100, 6);
        
        [_tipWindow addSubview:progress];
        
    }
    UIImageView *progress=(UIImageView *)[_tipWindow viewWithTag:14];
    
    UILabel *tipLabel=(UILabel *)[_tipWindow viewWithTag:13];
    if (show) {
        tipLabel.text=title;
        _tipWindow.hidden=NO;
        //增加来回移动
        progress.left=0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:3];
        [UIView setAnimationRepeatCount:1000];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];//匀速移动
        progress.left=ScreenWidth-100;
        [UIView commitAnimations];
        
    }else{
        tipLabel.text=title;
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:2];
    }
    
}
-(void)removeTipWindow{
    _tipWindow.hidden=YES;
    [_tipWindow release];
    _tipWindow=nil;
}

- (void)viewDidLoad
{
    self.db = [FileUrl getDB];
    [self.db open];
    [super viewDidLoad];


    //设置navegation背景颜色
    self.navigationController.navigationBar.tintColor = NenNewsgroundColor;
	 [self.view setBackgroundColor:[[ThemeManager shareInstance]getBackgroundColor]];

    NSArray *viewControllers = self.navigationController.viewControllers;
    if (self.isCancelButton) {
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = NenNewsgroundColor;
        [button setImage:[UIImage imageNamed:@"navagiton_back.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 40);
        //        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(cencel) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = [backItem autorelease];
    }else{
        if (viewControllers.count > 1 ) {
            UIButton *button = [[UIButton alloc]init];
            button.backgroundColor = NenNewsgroundColor;
            //        [button setTitle:@"返回" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"navagiton_back.png"] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 40, 40);
            //        button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = [backItem autorelease];
        }
        else if([self isKindOfClass:[MainViewController class]] )
        {
            self.navigationItem.rightBarButtonItem = BARBUTTON(@"订阅", @selector(dingyue));
        }
    }

}


-(void)cencel{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
//    RONGO_ARC_RELEASE(baseHud);
    RELEASE_SAFELY(_db)
    RELEASE_SAFELY(_hud);
    DLOG(@"release :%@",[self class]);
    [super dealloc];
}
-(void)viewDidUnload{
    [_db close];
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUD];
    [super viewWillDisappear:animated];
}
-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectZero];
    titlelabel.font=[UIFont boldSystemFontOfSize:18.0f];
    titlelabel.backgroundColor= NenNewsgroundColor;
    titlelabel.text=title;
    titlelabel.textColor=NenNewsTextColor;
    [titlelabel sizeToFit];
    self.navigationItem.titleView = [titlelabel autorelease];
}
//提示登录对话框
-(void)alertLoginView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你尚未登录，是否登陆？" delegate:self cancelButtonTitle:@"否"  otherButtonTitles:@"是", nil];
    alert.tag = INT16_MAX;
    [alert show];
    [alert release];
}
- (void)showWaiting:(UIView *)parent {
  UIActivityIndicatorView* t  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [t setCenter:parent.center];
  [t setBackgroundColor:[UIColor blackColor]];
  [t setAlpha:0.8];
  t.tag=99;
  t.layer.cornerRadius = 8;
  t.layer.masksToBounds = YES;
  CGRect orientationFrame = [UIScreen mainScreen].bounds;
  CGFloat activeHeight = orientationFrame.size.height;
  CGFloat posY = floor(activeHeight*0.39);
  CGFloat posX = orientationFrame.size.width/2;
  CGPoint newCenter;
  newCenter = CGPointMake(posX, posY);
  [t setCenter:newCenter];
  
  [t setBounds:CGRectMake(0, 0, 100, 100)];
  [t startAnimating];
  [t becomeFirstResponder];
  [parent addSubview:t];
  [t release];
}

- (void)hideWaiting:(UIView *)parent {
  [[parent viewWithTag:99] removeFromSuperview];
}

#pragma mark 重写longitude\latitude


@end
