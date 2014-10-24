//
//  AnswerView.m
//  MBA
//
//  Created by 海普科技  on 14-5-22.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "AnswerView.h"
#import "AnswerViewCell.h"
#import "AnswerDetailView.h"
@interface AnswerView ()

@end

@implementation AnswerView
@synthesize dataArray;
@synthesize statusFlag,frontVC;
-(id)init{
  self = [super init];
  if (self) {
  }
  return self;
}
- (void)dealloc {
  [statusFlag release];
  [dataArray release];
  [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *POSID =[[userDefaults objectForKey:@"userinfo"] objectForKey:@"POSID"];
    if ([POSID integerValue] == 9996) {
     self.navigationItem.rightBarButtonItem = BARBUTTON(@"提问", @selector(tiwen));
    }
  self.dataArray=[NSMutableArray new];
  [self launchRefreshing];

}


- (BOOL) refresh
{
  if (![super refresh])
    return NO;
  curPage=1;
  [self performSelector:@selector(getQuestionsListWithqueStatus) withObject:nil afterDelay:1.0];
  // See -addItemsOnTop for more info on how to finish loading
  return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (![super loadMore])
    return NO;
  curPage++;
  [self performSelector:@selector(getQuestionsListWithqueStatus) withObject:nil afterDelay:1.0];
  return YES;
}

-(void) getQuestionsListWithqueStatus{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"QuestionsService/getTaxQuestionsList/%@/%@/0/%d/%d",userId,statusFlag,curPage,KPageSize];
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
    
//    AskQuestionView *ask =[[AskQuestionView alloc]init];
//    ask.quePaterId =@"0";
//    
//    [self.navigationController pushViewController:ask animated:YES];
  
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
  return size.height+80;
    
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
    
  
  CGFloat contentWidth = 232;
  
  CGSize size = [cell.titleLabel.text  sizeWithFont:[UIFont systemFontOfSize:13]
                                                 constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
  

    cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, cell.titleLabel.frame.size.width, size.height+5);
  
    [cell.subLabel setHidden:YES];
    [cell.bgImage setHidden:YES];

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AnswerDetailView *ans = [[AnswerDetailView alloc]init];
    ans.answerDic = [dataArray objectAtIndex:indexPath.row];
    [self.frontVC.navigationController pushViewController:ans animated:YES];
    [ans release];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations.
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
