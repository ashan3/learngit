//
//  NoticeView.m
//  MBA
//
//  Created by 海普科技  on 14-5-20.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "NoticeView1.h"
#import "NoticeViewCell.h"
#import "NoticeDetailView.h"
@interface NoticeView1 ()

@end

@implementation NoticeView1
@synthesize dataArray;
-(id)init{
  self = [super init];
  if (self) {
  }
  return self;
}
- (void)dealloc {
  [dataArray release];
  [super dealloc];
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title =@"公告";
  self.dataArray =[[NSMutableArray alloc]init];
  [self launchRefreshing];
}
- (BOOL) refresh
{
  if (![super refresh])
    return NO;
  curPage=1;
  [self performSelector:@selector(getNoticeInfoListt) withObject:nil afterDelay:1.0];
  // See -addItemsOnTop for more info on how to finish loading
  return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (![super loadMore])
    return NO;
  curPage++;
  [self performSelector:@selector(getNoticeInfoListt) withObject:nil afterDelay:1.0];
  return YES;
}
-(void)getNoticeInfoListt{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *companyId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"COMPANYID"];
  NSString *Url = [NSString stringWithFormat:@"NoticeService/getNoticeInfoList/%@/%@/%d/%d",companyId,userId,curPage,KPageSize];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    [self loadDateCompleted];
    if ([result1 isEqualToString:@"0"]) {
      NSArray * pagearray =[result objectForKey:@"page"];
      maxPage = [[[pagearray firstObject] objectForKey:@"PAGECOUNT"] intValue];
      if(curPage == 1){
        [self.dataArray removeAllObjects];
      }
      {
      NSMutableArray *list=[[NSMutableArray alloc]initWithArray:[result objectForKey:@"data"]];
      [self.dataArray addObjectsFromArray:list];
      [list release];
      }
      [self.tableView reloadData];
    }
    
  } andErrorBlock:^(NSError *error) {
    [self loadDateCompleted];
  }];
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  NoticeViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"NoticeViewCell"];
  if (cell== nil) {
    cell = [[[NSBundle mainBundle]loadNibNamed:@"NoticeViewCell" owner:nil options:nil]objectAtIndex:0];
  }
  NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
  cell.titleLabel.text =[dic objectForKey:@"NOTICETITLE"];
  cell.timeLabel.text =[dic objectForKey:@"CREATETIME"];
  return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
  NoticeDetailView *clo =[[NoticeDetailView alloc]init];
  clo.noticeId =[dic objectForKey:@"NOTICEID"];
  [self.navigationController pushViewController:clo animated:YES];
  [clo release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
