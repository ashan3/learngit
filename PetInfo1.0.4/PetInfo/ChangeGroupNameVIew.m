//
//  ChangeGroupNameVIew.m
//  LandTex
//
//  Created by 海普科技  on 14-7-21.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "ChangeGroupNameVIew.h"

@interface ChangeGroupNameVIew ()

@end

@implementation ChangeGroupNameVIew
@synthesize groupId,groupName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
  [textField release];
  [groupId release];
  [groupName release];
  [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    textField.text =groupName;
    

    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    [textField resignFirstResponder];
    
}

-(void)sender:(id)sender{
    
    
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [[NSString stringWithFormat:@"GroupService/updateGroupName/%@/%@/%@",userId,groupId,textField.text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    if ([result1 isEqualToString:@"0"]) {
      [SVProgressHUD showSuccessWithStatus:@"修改成功"];
      self.groupName =textField.text;
      NSDictionary *obj = @{ @"groupName" : groupName};
      [[NSNotificationCenter defaultCenter] postNotificationName:@"changegroupName" object:nil userInfo:obj];
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
