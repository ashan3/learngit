//
//  RegisterUserNameViewController.m
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "CSRegisterUserNameViewController.h"
#import "MainViewController.h"
@interface CSRegisterUserNameViewController ()

@property (nonatomic,retain) IBOutlet UITextField *phoneNumberField;
@property (nonatomic,retain) IBOutlet UIImageView *phoneNumberBackView;
@property (nonatomic,retain) IBOutlet UITextField *secretCodeField;
@property (nonatomic,retain) IBOutlet UIImageView *secretCodeBackView;
@property (nonatomic,retain) IBOutlet UITextField *checkSecretCodeField;
@property (nonatomic,retain) IBOutlet UIImageView *checkSecretCodeBackView;
@property (nonatomic,retain) IBOutlet UIView *backView;
@property (nonatomic,retain) IBOutlet UIView *inputBackView;
@property (nonatomic,retain) IBOutlet UIButton *registerButton;
@property (nonatomic,retain) IBOutlet UIScrollView *contentScrollView;

@end

@implementation CSRegisterUserNameViewController
@synthesize secretCodeField;
@synthesize checkSecretCodeField;
@synthesize backView;
@synthesize inputBackView;
@synthesize phoneNumberField;
@synthesize phoneNumberBackView;
@synthesize secretCodeBackView;
@synthesize checkSecretCodeBackView;
@synthesize registerButton;
@synthesize contentScrollView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  _keyBoardWithToolBar = [[KeyBoardWithToolBar alloc] init];
  _keyBoardWithToolBar.delegate = self;
  [_keyBoardWithToolBar setControlList:[NSArray arrayWithObjects:phoneNumberField, secretCodeField, checkSecretCodeField,nil]];
    self.navigationItem.title = @"注册";

    //点击页面使键盘消失
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
//    tapReconginzer.delegate = self;
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];
    
    //[self.phoneNumberField becomeFirstResponder];
    //[self keyboardWillShow:nil];

}

- (void)hideKeyBoard
{
    [self.phoneNumberField resignFirstResponder];
    [self.secretCodeField resignFirstResponder];
    [self.checkSecretCodeField resignFirstResponder];
    [self didClickDoneButton];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
  [_keyBoardWithToolBar release];
    [secretCodeField release];
    [checkSecretCodeField release];
    [backView release];
    [inputBackView release];
    [phoneNumberField release];
    [phoneNumberBackView release];
    [secretCodeBackView release];
    [checkSecretCodeBackView release];
    [registerButton release];
    [contentScrollView release];
    [super dealloc];
}

#pragma mark - button click methods
-(void)backAction{
  [self.phoneNumberField resignFirstResponder];
  [self.secretCodeField resignFirstResponder];
  [self.checkSecretCodeField resignFirstResponder];
  [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)loginButtonPressed:(id)sender
{
    [self.phoneNumberField resignFirstResponder];
    [self.secretCodeField resignFirstResponder];
    [self.checkSecretCodeField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender
{
  [self.phoneNumberField resignFirstResponder];
  [self.secretCodeField resignFirstResponder];
  [self.checkSecretCodeField resignFirstResponder];
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButtonPressed:(id)sender
{
    NSLog(@"registerbuttonpressed");
    if ([self.phoneNumberField.text length] == 0)
    {
         [SVProgressHUD showErrorWithStatus:@"账号不能为空!"];
        return;
    }
    
    if ([self.secretCodeField.text length] == 0 || [self.checkSecretCodeField.text length] == 0)
    {
         [SVProgressHUD showErrorWithStatus:@"密码不能为空!" ];
        return;
    }

    if (![self.secretCodeField.text isEqualToString:self.checkSecretCodeField.text])
    {
         [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致，请重新输入!"];
        return;
    }
  [self showHUD:INFO_RequestNetWork isDim:YES];
  NSString *Url = [NSString stringWithFormat:@"UserInfoService/register/%@/%@",self.phoneNumberField.text,self.secretCodeField.text];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    [self hideHUD];
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    if ([result1 isEqualToString:@"0"]) {
    [self showHUD:@"注册成功" isDim:YES];
         [SVProgressHUD showSuccessWithStatus:@"注册成功"];
    [self.navigationController popViewControllerAnimated:YES];
    }else if ([result isEqualToString:@"14"]){
         [SVProgressHUD showErrorWithStatus:@"用户已经注册"];
    }else {
         [SVProgressHUD showErrorWithStatus:@"注册失败"];
    }
    
  } andErrorBlock:^(NSError *error) {
    [self hideHUD];
  }];
  
}

#pragma mark - ASIHttpRequest Delegate Methods


#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[self hideKeyBoard];
}

#pragma mark -UITextField Delegate


- (void)calcContentOffset:(NSInteger)offset {
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
  self.contentScrollView.contentOffset = CGPointMake(0, offset);
  [UIView commitAnimations];
}

- (void)didClickDoneButton {
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
  self.contentScrollView.contentOffset = CGPointMake(0, 0);
  [UIView commitAnimations];
}

@end
