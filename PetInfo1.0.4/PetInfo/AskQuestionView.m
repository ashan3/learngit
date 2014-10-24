//
//  AskQuestionView.m
//  MBA
//
//  Created by 海普科技  on 14-6-4.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "AskQuestionView.h"

@interface AskQuestionView ()

@end

@implementation AskQuestionView
@synthesize textView,label,mesg,articleId,quePaterId,queID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)dealloc {
  [textView release];
  [label release];
  [mesg release];
  [articleId release];
   [quePaterId release];
  [queID release];
  [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (queID != nil) {
        mesg = @"请输入您的回答。。";
        self.label.text =mesg;
        self.title =@"回答";
    }else{
        mesg = @"请输入您的提问。。";
        self.label.text =mesg;
        self.title =@"提问";
    }
  
}
-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)textViewDidChange:(UITextView *)textView{
    
    if (self.textView.text.length == 0) {
        self.label.text = mesg;
    }else{
        self.label.text = @"";
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.textView resignFirstResponder];
    
}
- (NSString*)urlEncodedString:(NSString *)string{
  if (string) {
    NSString *newString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL,CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8);
    return newString;
  }
  return @"";
}
-(void)sender:(id)sender{
    NSString *msg=@"";
    
    if([self.textView.text length] == 0){
        msg=mesg;
    }
    if(![msg isEqualToString:@""])
    {
       [SVProgressHUD showSuccessWithStatus:msg];
        return;
    }
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  
    if (queID !=nil) {
        
      NSString *Url = [NSString stringWithFormat:@"QuestionsService/addAnswers/%@/%@/0/%@",userId,queID,[self urlEncodedString:self.textView.text]];
      [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
      
        NSString *result1 = [result objectForKey:@"result"];
        if ([result1 isEqualToString:@"0"]) {
           NSDictionary *answer = @{ @"answers" : self.textView.text};
          [[NSNotificationCenter defaultCenter] postNotificationName:@"refishQue" object:nil userInfo:answer];
     
          NSString *msg=@"提问成功！";
          if (queID !=nil) {
            msg =@"回答成功";
          }
        [SVProgressHUD showSuccessWithStatus:msg];
        [self.navigationController popViewControllerAnimated:YES];
        }
        
      } andErrorBlock:^(NSError *error) {
        
      }];
      
    }
    else{
      NSString *Url = [NSString stringWithFormat:@"QuestionsService/addQuestions/%@/%@/0/%@",userId,[self urlEncodedString:self.textView.text],quePaterId];
      [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
        
        NSString *result1 = [result objectForKey:@"result"];
        if ([result1 isEqualToString:@"0"]) {
          
          NSDictionary *answer = @{ @"answers" : self.textView.text};
          [[NSNotificationCenter defaultCenter] postNotificationName:@"refishQue" object:nil userInfo:answer];
          
          NSString *msg=@"提问成功！";
          if (queID !=nil) {
            msg =@"回答成功";
          }
          [SVProgressHUD showSuccessWithStatus:msg];
          [self.navigationController popViewControllerAnimated:YES];
        }
        
      } andErrorBlock:^(NSError *error) {
        
      }];

    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
