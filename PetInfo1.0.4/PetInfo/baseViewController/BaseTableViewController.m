//
//  BaseTableViewController.m
//  东北新闻网
//
//  Created by tenyea on 14-1-9.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MBProgressHUD.h"
#import "BaseNavViewController.h"
@interface BaseTableViewController ()

@end

@implementation BaseTableViewController


#pragma mark 适配ios7
-(void)setStateBarHidden :(BOOL) statusBarHidden{
    if (WXHLOSVersion()>=7.0) {
        [self setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setStatusBarHidden:statusBarHidden];
        
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:statusBarHidden];
    }
}
-(AppDelegate *)appDelegate{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    return  appDelegate;
}

#pragma mark - loading tips 加载提示



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
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.frame = CGRectMake(0, 0,ScreenWidth ,ScreenHeight);
    //设置当前网络环境
    self.network = [DataCenter getConnectionAvailable];
    //设置navegation背景颜色
    self.navigationController.navigationBar.tintColor = NenNewsgroundColor;
//	[self.view setBackgroundColor:CLEARCOLOR];
    
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    
    
    if (self.isCancelButton) {
        //        UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cencel)];
        //        self.navigationItem.leftBarButtonItem=[cancelItem autorelease];
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
      else
      {
          self.navigationItem.rightBarButtonItem = BARBUTTON(@"提问", @selector(tiwen));
      }
    }
}
#pragma mark ----按钮事件
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
    RELEASE_SAFELY(_request);
    RELEASE_SAFELY(_hud);
    MARK;
    [super dealloc];
}
-(void)viewDidUnload{
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUD];
    [self.request clearDelegatesAndCancel];
    [super viewWillDisappear:animated];
}
//提示登录对话框
-(void)alertLoginView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你尚未登录，是否登陆？" delegate:self cancelButtonTitle:@"否"  otherButtonTitles:@"是", nil];
    alert.tag = INT16_MAX;
    [alert show];
    [alert release];
}

#pragma mark 重写longitude\latitude

//定位

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
@end
