//
//  ContentView.m
//  MBA
//
//  Created by 海普科技  on 14-5-22.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "ContentView.h"
#import "ASIHTTPRequest.h"
#import "RegexKitLite.h"
#import "InstallView1.h"
#import "CommentView.h"
//#import "InstallView.h"
@interface ContentView ()
@end

@implementation ContentView
@synthesize articleId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}
-(void)dealloc{
  [articleId release];
  [_webView release];
    [titleLael release];
    [timeLabel release];
  [super dealloc];
}
- (void)viewDidLoad
{
     [super viewDidLoad];
      NSString *Url = [NSString stringWithFormat:@"ResourceService/getResourceContent/%@",articleId];
      [self showWaiting:self.view];
      [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
      [self hideWaiting:self.view];
      NSString *result1 = [result objectForKey:@"result"];
      if ([result1 isEqualToString:@"0"]) {
      NSArray *data= [result objectForKey:@"data"];
      NSDictionary *dict =[data objectAtIndex:0];
      NSString *str = [dict objectForKey:@"CONTENT"];
      timeLabel.text = [dict objectForKey:@"CREATETIME"];
      titleLael.text =[dict objectForKey:@"RESOURCETITLE"];
      speechStr =str;
      NSLog(@"str = %@",str);
      NSString *regEx = @"<([^>]*)>";
      NSString * stringWithoutHTML = [str stringByReplacingOccurrencesOfRegex:regEx withString:@""];
      NSLog(@"stringWithoutHTML=%@",stringWithoutHTML);
      speechStr =stringWithoutHTML;
      NSMutableString *str1 =[NSMutableString stringWithString:str];
      NSRange range =[str1 rangeOfString:@"src='"];
      if (range.location != NSNotFound) {
        [str1 insertString:@"http://www.seekhi.com" atIndex:range.location+range.length];
        [str1 insertString:@" width=\"300\" " atIndex:4];
      }
      NSLog(@"str1  == %@" ,str1);
      [_webView loadHTMLString:str1 baseURL:nil];
    }
  } andErrorBlock:^(NSError *error) {
  [self hideHUD];
  }];
  
  [self isCollectWithArra];
}
-(void)requestFinished:(id)result{
  NSString *result1 = [result objectForKey:@"result"];
  if ([result1 isEqualToString:@"101"]) {
    UIButton *button = (UIButton *)[self.view viewWithTag:102];
    button.selected =YES;
    [button setImage:[UIImage imageNamed:@"sh_icon3_over.png"] forState:UIControlStateNormal];
  }
}
-(void) isCollectWithArra
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"CollectService/isCollect/%@/%@",userId,articleId];

  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    if ([result1 isEqualToString:@"101"]) {
      UIButton *button = (UIButton *)[self.view viewWithTag:102];
      button.selected =YES;
      [button setImage:[UIImage imageNamed:@"sh_icon3_over.png"] forState:UIControlStateNormal];
    }
  } andErrorBlock:^(NSError *error) {
  }];
  
  
//  DataService *service = [[DataService alloc]init];
//  service.eventDelegate = self;
//  [service requestWithURL:Url andparams:nil isJoint:YES andhttpMethod:@"GET"];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"web  end");
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
 
    NSLog(@"web  start");
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
    NSLog(@"web  error");
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)back:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goInstall:(id)sender{
    InstallView1 *per = [[InstallView1 alloc]init];
    [self.navigationController pushViewController:per animated:YES];
    [per release];   
}

-(void)comment:(id)sender{
  CommentView *com = [[CommentView alloc]init];
  com.articleId = articleId;
  [self.navigationController pushViewController:com animated:YES];
  [com release];
}
-(void)collection:(id)sender{
    
  UIButton *button =(UIButton *) sender;
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
    if (button.selected) {
    [button setImage:[UIImage imageNamed:@"sh_icon3.png"] forState:UIControlStateNormal];
     NSString *Url = [NSString stringWithFormat:@"CollectService/delUserCollect/%@/%@",userId,articleId];
      [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
        NSString *result1 = [result objectForKey:@"result"];
        if ([result1 isEqualToString:@"0"]) {
          [self promptWithString:@"取消收藏成功！"];
        //  [SVProgressHUD showSuccessWithStatus:@"取消收藏成功！"];
        }
      } andErrorBlock:^(NSError *error) {
      }];
  
        button.selected=NO;
    }else{
      
      [button setImage:[UIImage imageNamed:@"sh_icon3_over.png"] forState:UIControlStateNormal];
      NSString *Url = [NSString stringWithFormat:@"CollectService/addUserCollect/%@/%@",userId,articleId];
      [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
        NSString *result1 = [result objectForKey:@"result"];
        if ([result1 isEqualToString:@"0"]) {
         // [SVProgressHUD showSuccessWithStatus:@"收藏成功！"];
           [self promptWithString:@"收藏成功！"];
        }
      } andErrorBlock:^(NSError *error) {
      }];
        button.selected =YES;
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
