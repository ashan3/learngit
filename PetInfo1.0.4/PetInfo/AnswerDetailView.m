//
//  AnswerDetailView.m
//  LandTex
//
//  Created by 海普科技  on 14-7-23.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "AnswerDetailView.h"
#import "AnswerViewCell.h"
#import "AskQuestionView.h"
@interface AnswerDetailView ()

@end

@implementation AnswerDetailView
@synthesize answerDic;
@synthesize answers,dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refishQue" object:nil];
   [answerDic release];
   [answers release];
  [dataArray release];
  [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"问答详情";

  
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *POSID =[[userDefaults objectForKey:@"userinfo"] objectForKey:@"POSID"];

    if ([POSID integerValue] == 9996) {
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"提问", @selector(tiwen));
    
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refishQue:) name:@"refishQue" object:nil];
    answers = [answerDic objectForKey:@"answers"];
    self.dataArray=[NSMutableArray new];
    [dataArray addObject:answerDic];
   [self launchRefreshing];
  }
- (BOOL) refresh
{
  if (![super refresh])
    return NO;
  curPage=1;
  [self performSelector:@selector(getQuestionsListWithque) withObject:nil afterDelay:1.0];
  // See -addItemsOnTop for more info on how to finish loading
  return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (![super loadMore])
    return NO;
  curPage++;
  [self performSelector:@selector(getQuestionsListWithque) withObject:nil afterDelay:1.0];
  return YES;
}
-(void) getQuestionsListWithque{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"QuestionsService/getTaxQuestionsList/%@/-1/%@/%d/%d",userId,[self.answerDic objectForKey:@"id"],curPage,KPageSize];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    [self loadDateCompleted];
    NSString *result1 = [result objectForKey:@"result"];
    if ([result1 isEqualToString:@"0"]) {
      NSArray * pagearray =[result objectForKey:@"page"];
      maxPage = [[[pagearray firstObject] objectForKey:@"PAGECOUNT"] intValue];
      if(curPage == 1){
        [self.dataArray removeAllObjects];
      }
      [dataArray addObjectsFromArray: [result objectForKey:@"data"]];
      [self.tableView reloadData];
    }
    
  } andErrorBlock:^(NSError *error) {
    [self loadDateCompleted];
  }];
  
}

-(void)tiwen{
  AskQuestionView *ask =[[AskQuestionView alloc]init];
  ask.quePaterId = [answerDic objectForKey:@"id"];
  [self.navigationController pushViewController:ask animated:YES];
  [ask release];
  
}

-(void)refishQue:(NSNotification*)sender{
    
    NSDictionary *dic = [sender userInfo];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *POSID =[[userDefaults objectForKey:@"userinfo"] objectForKey:@"POSID"];
    
    if ([POSID integerValue] != 9996) {

    if (selrow>=1) {
      [self refresh];
    }else{
        
        answers =[dic objectForKey:@"answers"];
        [self.tableView reloadData];
        
    }
    
    }
    else{
       [self refresh];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic =[dataArray objectAtIndex:indexPath.row];
    
    NSString *str =[dic objectForKey:@"queTitle"];
    
  CGFloat contentWidth = 232;
  
  CGSize size = [str  sizeWithFont:[UIFont systemFontOfSize:13]
                                  constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
  
    NSLog(@"size =%f",size.height);
    
    if ([dic objectForKey:@"answers"] ==nil) {
    
        return 80+size.height;
    }
    
    return 220;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AnswerViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"AnswerViewCell"];
    
    if (cell== nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AnswerViewCell" owner:nil options:nil]objectAtIndex:0];
        
        
    }
    
    NSDictionary *dic =[dataArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [dic objectForKey:@"queTitle"];
    cell.timeLabel.text =[dic objectForKey:@"queTime"];
    
    cell.nameLabel.text = [dic objectForKey:@"queUserName"];
    cell.subLabel.text = [dic objectForKey:@"answers"];
    
    
    if ([dic objectForKey:@"answers"] ==nil) {
        
        [cell.subLabel setHidden:YES];
        [cell.bgImage setHidden:YES];
        
    }else{
        
        [cell.subLabel setHidden:NO];
        [cell.bgImage setHidden:NO];
    }
    
    if (indexPath.row ==0) {
        
        cell.subLabel.text = answers;
        
        if ( answers ==nil) {
            
            [cell.subLabel setHidden:YES];
            [cell.bgImage setHidden:YES];
            
        }else{
            
            [cell.subLabel setHidden:NO];
            [cell.bgImage setHidden:NO];
        }

        
    }
    
   
    
  CGFloat contentWidth = 232;
  
  CGSize size = [cell.titleLabel.text  sizeWithFont:[UIFont systemFontOfSize:13]
                                  constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, cell.titleLabel.frame.size.width, size.height+5);
  
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    selrow = indexPath.row;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *POSID =[[userDefaults objectForKey:@"userinfo"] objectForKey:@"POSID"];
    
    if ([POSID integerValue] != 9996) {
        
        UIActionSheet *actS = [[UIActionSheet alloc]initWithTitle:@"回答或删除提问" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回答提问",@"删除", nil];
        [actS showInView:self.view];
        [actS release];
    
    }else{
        
//        UIActionSheet *actS = [[UIActionSheet alloc]initWithTitle:@"追问" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"追问", nil];
//        [actS showInView:self.view];
//
        
    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *POSID =[[userDefaults objectForKey:@"userinfo"] objectForKey:@"POSID"];
    if (buttonIndex == 0) {
        if ([POSID integerValue] != 9996) {
        AskQuestionView *ask =[[AskQuestionView alloc]init];
        ask.queID = [[dataArray objectAtIndex:selrow] objectForKey:@"id"];
        ask.quePaterId = @"0";
        [self.navigationController pushViewController:ask animated:YES];
        [ask release];
        }
        else{
             AskQuestionView *ask =[[AskQuestionView alloc]init];
             ask.quePaterId = [answerDic objectForKey:@"id"];
            [self.navigationController pushViewController:ask animated:YES];
            [ask release];
        }
     
    }else if (buttonIndex == 1) {
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
        if ([POSID integerValue] != 9996) {
            if (answers ==nil) {
              NSString *Url = [NSString stringWithFormat:@"QuestionsService/addAnswers/%@/%@/1/",userId,[dataArray objectAtIndex:selrow]];
              [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
                
                NSString *result1 = [result objectForKey:@"result"];
                if ([result1 isEqualToString:@"0"]) {
                  [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                  [self.navigationController popViewControllerAnimated:YES];
                }
                
              } andErrorBlock:^(NSError *error) {
                 [SVProgressHUD showSuccessWithStatus:@"删除失败"];
              }];
                
                
            }else{
              NSString *Url = [NSString stringWithFormat:@"QuestionsService/addAnswers/%@/%@/0/",userId,[dataArray objectAtIndex:selrow]];
              [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
                
                NSString *result1 = [result objectForKey:@"result"];
                if ([result1 isEqualToString:@"0"]) {
                  [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                  [self.navigationController popViewControllerAnimated:YES];
                }
                
              } andErrorBlock:^(NSError *error) {
                [SVProgressHUD showSuccessWithStatus:@"删除失败"];
              }];
          
            }

            
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
