//
//  MyCommentView.m
//  MBA
//
//  Created by 海普科技  on 14-5-21.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "MyCommentView.h"
#import "NoticeViewCell.h"
#import "ContentView.h"
@interface MyCommentView ()

@end

@implementation MyCommentView
@synthesize commentOrCollect;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    // Do any additional setup after loading the view from its nib.
    self.title =@"评论";

  dataArray = [[NSMutableArray alloc]init];
  [self launchRefreshing];

}

- (BOOL) refresh
{
  if (![super refresh])
    return NO;
  curPage=1;
  [self performSelector:@selector(getCommentInfoListArray) withObject:nil afterDelay:1.0];
  // See -addItemsOnTop for more info on how to finish loading
  return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (![super loadMore])
    return NO;
  curPage++;
  [self performSelector:@selector(getCommentInfoListArray) withObject:nil afterDelay:1.0];
  return YES;
}
-(void)getCommentInfoListArray{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"%@/%@/%d/%d",commentOrCollect,userId,curPage,KPageSize];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    [self loadDateCompleted];
    if ([result1 isEqualToString:@"0"]) {
      NSArray * pagearray =[result objectForKey:@"page"];
      maxPage = [[[pagearray firstObject] objectForKey:@"PAGECOUNT"] intValue];
      if(curPage == 1){
        [dataArray removeAllObjects];
      }
      if(![[result objectForKey:@"data"] isEqual:[NSNull null]])
      {
      NSMutableArray *list=[[NSMutableArray alloc]initWithArray:[result objectForKey:@"data"]];
      [dataArray addObjectsFromArray:list];
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
    NoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeViewCell"];
    if (cell ==nil) {

        cell = [[[NSBundle mainBundle]loadNibNamed:@"NoticeViewCell" owner:nil options:nil]objectAtIndex:0 ];
    }
    
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text =[dic objectForKey:@"RESOURCETITLE"];
    cell.timeLabel.text =[dic objectForKey:@"CREATETIME"];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    NSString *RESOURCEID = [dic objectForKey:@"RESOURCEID"];
    ContentView *CONT = [[ContentView alloc]init];
    CONT.articleId =RESOURCEID;
    [self.navigationController pushViewController:CONT animated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
