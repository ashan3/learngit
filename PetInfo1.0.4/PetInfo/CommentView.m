//
//  CommentView.m
//  MBA
//
//  Created by 海普科技  on 14-5-28.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "CommentView.h"

@interface CommentView ()

@end

@implementation CommentView
@synthesize articleId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"评论";
    }
    return self;
}
- (void)dealloc {
  [_textView release];
    [_label release];
    [articleId release];
  [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        _label.text = @"请输入您的评论。。";
    }else{
        _label.text = @"";
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_textView resignFirstResponder];
    
}

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)sender:(id)sender{
    
    
    NSString *msg=@"";
    
    if([_textView.text length] == 0){
        msg=@"请输入您的评论。";
    }
    if(![msg isEqualToString:@""])
    {
      [SVProgressHUD showErrorWithStatus:msg];
        return;
    }

  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [[NSString stringWithFormat:@"CommentService/addCommentInfo/%@/%@/%@",userId,articleId,_textView.text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    
    NSString *result1 = [result objectForKey:@"result"];
    if ([result1 isEqualToString:@"0"]) {
      [SVProgressHUD showSuccessWithStatus:@"评论成功"];
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
