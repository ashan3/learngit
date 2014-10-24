//
//  NoticeDetailView.m
//  MBA
//
//  Created by 海普科技  on 14-6-4.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "NoticeDetailView.h"

@interface NoticeDetailView ()

@end

@implementation NoticeDetailView

@synthesize noticeId;
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
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"公告详情";

  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"NoticeService/getTaxNoticeById/%@/%@/1",userId,noticeId];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    if ([result1 isEqualToString:@"0"]) {
      NSArray *data= [result objectForKey:@"data"];
      NSDictionary *dict =[data objectAtIndex:0];
      NSString *str = [dict objectForKey:@"NOTICECONTENT"];
      [_webView loadHTMLString:str baseURL:nil];;
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
