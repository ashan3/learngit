//
//  ChangePasswordView.m
//  MBA
//
//  Created by 海普科技  on 14-5-21.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "ChangePasswordView.h"
#import "UIAlertView+ShowNotice.h"
@interface ChangePasswordView ()

@end

@implementation ChangePasswordView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
  [textField1 release];
  [textField2 release];
  [textField3 release];
  [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"修改密码";
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
    [textField3 resignFirstResponder];
}
-(void)sender:(id)sender{
    NSString *password1 = [textField1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password2 = [textField2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *password3 = [textField3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *msg=@"";
    
    if([password1 length] == 0){
        msg=@"请输入旧密码";
    }else if([password2 length] == 0){
        msg=@"请输入旧密码";
    }else if (![password3 isEqualToString:password2]){
        msg=@"两次密码输入不正确";
    }
    if(![msg isEqualToString:@""])
    {
        [UIAlertView showWithNotice:msg];
        return;
    }
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"UserInfoService/updateUserPassword/%@/%@/%@",userId,password1,password2];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    if ([result1 isEqualToString:@"0"]) {
      [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    }else if ([result1 isEqualToString:@"13"]){
         [UIAlertView showWithNotice:@"旧密码错误"];
    }else{
         [UIAlertView showWithNotice:@"修改失败"];
    }
  } andErrorBlock:^(NSError *error) {
    
  }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
