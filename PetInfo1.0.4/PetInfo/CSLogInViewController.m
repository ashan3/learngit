//
//  LogInViewController.m
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "CSLogInViewController.h"
#import "ASIFormDataRequest.h"
#import "CSRegisterUserNameViewController.h"
#import "MainViewController.h"
#define AnimationChangeHeight 170

#import "BaseNavViewController.h"
#import "AccountManager.h"
@interface CSLogInViewController ()

@property (nonatomic,retain) IBOutlet UITextField *userNameField;
@property (nonatomic,retain) IBOutlet UITextField *passwordField;
@property (nonatomic,retain) NSDictionary *userInfo;
//chao add

@end

@implementation CSLogInViewController

@synthesize userNameField;
@synthesize passwordField;
@synthesize userInfo;
@synthesize isModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
+ (void)logOut
{
  [[AccountManager manager] setIsLoginSuccess:NO];
  CSLogInViewController *theVC = [[CSLogInViewController alloc] initWithNibName:@"CSLogInViewController" bundle:nil];
  theVC.isModel=YES;
  UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:theVC];
  [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:navVC animated:YES completion:^{
    
  }];
  [theVC release];
  [navVC release];
}

-(void)viewWillAppear:(BOOL)animated{
  
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  

  UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
  [self.view addGestureRecognizer:tap];
  [tap release];
  
   self.userNameField.text = [AccountManager manager].uname;
  
 }
- (void)hideKeyBoard:(UIGestureRecognizer *)ges
{
  [self.userNameField resignFirstResponder];
  [self.passwordField resignFirstResponder];
}

- (IBAction)loginButtonPressed:(id)sender
{
    
    if ([self.userNameField.text length] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空!" ];
        return;
    }
    
    if ([self.passwordField.text length] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空!"];
        return;
    }
  
   [self showHUD:INFO_RequestNetWork isDim:YES];
  
    NSString *Url = [NSString stringWithFormat:@"UserInfoService/login/%@/%@",self.userNameField.text,self.passwordField.text];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
     [self hideHUD];
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    if ([result1 isEqualToString:@"11"]) {
   [SVProgressHUD showErrorWithStatus:@"密码或者用户名错误"];
      
    }else if ([result1 isEqualToString:@"0"]){
      
      NSArray *dataarray = [result objectForKey:@"data"];
      
      NSDictionary *data =[ dataarray objectAtIndex:0];
      
      NSUserDefaults *UserDefault = [NSUserDefaults standardUserDefaults];   //保存用户信息
      [UserDefault setObject:data forKey:kUserinfo];
      
      [UserDefault synchronize]; //同步
      
      [AccountManager manager].uname  =  self.userNameField.text;
      [AccountManager manager].passwd =  self.userNameField.text;
      [[AccountManager manager] setIsLoginSuccess:YES];

      [self getColumnList];

    }
 
  } andErrorBlock:^(NSError *error) {
     [self hideHUD];
  }];
}
-(void)getColumnList {
  //隐藏状态栏
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:kUserinfo] objectForKey:@"USERID"];
  NSString *companyId = [[userDefaults objectForKey:kUserinfo] objectForKey:@"COMPANYID"];
  NSString *Url = [NSString stringWithFormat:@"NavigationService/getTaxSubscriptionColumnInfoList/%@/%@",companyId,userId];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    
    NSArray *array = [result objectForKey:@"data"];
 
    NSMutableArray *columnArray =[[[NSMutableArray alloc] init] autorelease];
    
    //                    更新栏目
    for (int index = 0 ;index <array.count ;index++ )
    {
      
      NSDictionary *dic = array[index] ;
      NSString *partId = [dic objectForKey:@"COLUMNID"];
      NSString *appPartName = [dic objectForKey:@"COLUMNNAME"];
      NSString *isPic = @"1";
      NSString *COLUMNSTATUS = [dic objectForKey:@"COLUMNSTATUS"];
      if ([COLUMNSTATUS intValue]==1)
      {
      NSDictionary *dic1 = @{@"columnId": partId,@"name":appPartName,@"showimage":isPic};
      [columnArray addObject:dic1];
      }
    }
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:show_column];
    [[NSUserDefaults standardUserDefaults] setValue:columnArray forKey:show_column];
    
    if(isModel)
    {
      [self.navigationController dismissViewControllerAnimated:YES completion:^{ }];
    }
    else
    {
      MainViewController *main = [[MainViewController alloc] init];
      BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:main];
      self.appDelegate.window.rootViewController = nav;
    }
  } andErrorBlock:^(NSError *error) {
    
  }];
}
- (IBAction)registerButtonPressed:(id)sender
{

  [self.userNameField resignFirstResponder];
  [self.passwordField resignFirstResponder];
  CSRegisterUserNameViewController *controller = [[CSRegisterUserNameViewController alloc] initWithNibName:@"CSRegisterUserNameViewController" bundle:nil];
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.userNameField) {
    [self.passwordField becomeFirstResponder];
  }
  else
  {
    [self.passwordField resignFirstResponder];
    [self loginButtonPressed:nil];
  }
  
  return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [userNameField release];
    [passwordField release];
    [userInfo release];
    [super dealloc];
}

@end
