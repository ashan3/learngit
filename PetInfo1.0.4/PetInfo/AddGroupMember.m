//
//  AddGroupMember.m
//  LandTex
//
//  Created by 海普科技  on 14-7-21.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "AddGroupMember.h"
#import "CeatGroupCell.h"
@interface AddGroupMember ()

@end

@implementation AddGroupMember
@synthesize groupId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}
-(void)dealloc{
  [groupId release];
  [buttonArray release];
   [dataArray release];
  [_confirmBtn release];
  [super dealloc];
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  buttonArray =[[NSMutableArray alloc]init];
  dataArray = [[NSMutableArray alloc]init];
    self.tableView.frame= CGRectMake(0, 0, 320,self.view.height-49);
  [self.view bringSubviewToFront:_confirmBtn];
  [self launchRefreshing];
}
- (BOOL) refresh
{
  if (![super refresh])
    return NO;
  curPage=1;
  [self performSelector:@selector(getMemberNotInGroupWithgroupId) withObject:nil afterDelay:1.0];
  // See -addItemsOnTop for more info on how to finish loading
  return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (![super loadMore])
    return NO;
  curPage++;
  [self performSelector:@selector(getMemberNotInGroupWithgroupId) withObject:nil afterDelay:1.0];
  return YES;
}
-(void)getMemberNotInGroupWithgroupId{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"GroupService/getMemberNotInGroup/%@/%@/%d/%d",userId,groupId,curPage,KPageSize];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    [self loadDateCompleted];
    if ([result1 isEqualToString:@"0"]) {
      NSArray * pagearray =[result objectForKey:@"page"];
      maxPage = [[[pagearray firstObject] objectForKey:@"PAGECOUNT"] intValue];
      if(curPage == 1){
        [dataArray removeAllObjects];
        [buttonArray removeAllObjects];
      }
      if(![[result objectForKey:@"data"] isEqual:[NSNull null]])
      {
      NSMutableArray *list=[[NSMutableArray alloc]initWithArray:[result objectForKey:@"data"]];
      [dataArray addObjectsFromArray:list];
      [list release];
      }
      for (int i=0 ; i<dataArray.count; i++) {
        [buttonArray addObject:@"0"];
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
  
  return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  CeatGroupCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CeatGroupCell"];
  
  if (cell ==nil) {
    
    
    cell = [[[NSBundle mainBundle]loadNibNamed:@"CeatGroupCell" owner:nil options:nil]objectAtIndex:0];
    
  }
  
  
  NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
  cell.nameLabel.text = [dic objectForKey:@"USERPRC"];
  
  [cell.button addTarget:self action:@selector(selectAdd:) forControlEvents:UIControlEventTouchUpInside];
  
  cell.button.selected = [[buttonArray objectAtIndex:indexPath.row] boolValue];
  
  cell.button.tag =indexPath.row+100;
  
  return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  
}

-(void)selectAdd:(UIButton*)sender{
  
  
  if (sender.selected ==YES) {
    
    sender.selected =NO;
    
    [buttonArray setObject:@"0" atIndexedSubscript:sender.tag-100];
    
  }else{
    
    sender.selected =YES;
    
    [buttonArray setObject:@"1" atIndexedSubscript:sender.tag-100];
    
  }
  
}

-(void)sender:(id)sender{
  NSMutableString *str = [NSMutableString stringWithString:@""];
  for (int i =0 ; i<buttonArray.count; i++) {
    NSString *string = [buttonArray objectAtIndex:i];
    if ([string isEqual:@"1"]) {
      NSDictionary *dic = [dataArray objectAtIndex:i];
      NSString * userID =[dic objectForKey:@"USERID"];
      if (str.length ==0) {
        NSLog(@"userID = %@",userID);
        [str appendFormat:@"%@",userID];
        NSLog(@"str ===== %@",str);
        
      }else{
        NSLog(@"str = %@",str);
        [str appendString:@","];
        [str appendFormat:@"%@",userID];
        
      }
    }
    
  }
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"http://www.seekhi.com/edibleOil.ui/services/GroupService/changeGroupMember/%@/%@/0/%@",userId,groupId,str];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    if([result1 isEqualToString:@"0"]) {
      [self refresh];
      [SVProgressHUD showSuccessWithStatus:@"添加成功"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"exitGroup" object:nil];
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
