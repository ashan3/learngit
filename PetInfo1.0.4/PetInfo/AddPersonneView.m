//
//  AddPersonneView.m
//  LandTex
//
//  Created by 海普科技  on 14-7-9.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "AddPersonneView.h"
#import "AddPersonnelCell.h"
@interface AddPersonneView ()

@end

@implementation AddPersonneView
@synthesize buttonArray,dataArray;
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
  [buttonArray release];
  [_confirmBtn release];
  [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"成员管理";
    self.buttonArray =[[NSMutableArray alloc]init];
    self.dataArray =[[NSMutableArray alloc]init];
    self.tableView.frame= CGRectMake(0, 40, 320, self.view.height-55-49);
    [self.view bringSubviewToFront:_confirmBtn];
   [self launchRefreshing];
}
- (BOOL) refresh
{
  if (![super refresh])
    return NO;
  curPage=1;
   [self performSelector:@selector(getTaxPubUsersList) withObject:nil afterDelay:1.0];
  // See -addItemsOnTop for more info on how to finish loading
  return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (![super loadMore])
    return NO;
  curPage++;
  [self performSelector:@selector(getTaxPubUsersList) withObject:nil afterDelay:1.0];
  return YES;
}
-(void)getTaxPubUsersList{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"UserInfoService/getTaxPubUsersList/%@/%d/%d",userId,curPage,KPageSize];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    [self loadDateCompleted];
    if ([result1 isEqualToString:@"0"]) {
      NSArray * pagearray =[result objectForKey:@"page"];
      maxPage = [[[pagearray firstObject] objectForKey:@"PAGECOUNT"] intValue];
      if(curPage == 1){
        [self.dataArray removeAllObjects];
        [self.buttonArray removeAllObjects];
      }
      if(![[result objectForKey:@"data"] isEqual:[NSNull null]])
      {
      NSMutableArray *list=[[NSMutableArray alloc]initWithArray:[result objectForKey:@"data"]];
      [self.dataArray addObjectsFromArray:list];
      [list release];
      }
      for (int i=0 ; i<dataArray.count; i++) {
      [self.buttonArray addObject:@"0"];
      }     
      [self.tableView reloadData];
    }
 
  } andErrorBlock:^(NSError *error) {
    [self loadDateCompleted];
  }];
  
}
-(void)sender:(id)sender{
  
    NSMutableArray *Sellist = [NSMutableArray arrayWithCapacity:2];
  
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i =0 ; i<buttonArray.count; i++) {
        NSString *string = [buttonArray objectAtIndex:i];
        if ([string isEqual:@"1"]) {
            NSDictionary *dic = [dataArray objectAtIndex:i];
           [Sellist addObject:dic];
            NSString * userID =[dic objectForKey:@"USERID"];
            
            if (str.length ==0) {
                
                [str appendFormat:@"%@",userID];

                NSLog(@"str =%@",str);
                
            }else{
                [str appendString:@","];
                [str appendFormat:@"%@",userID];

                NSLog(@"str =%@",str);
            }
        }
        
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
 
  NSString *Url = [NSString stringWithFormat:@"UserInfoService/updateTaxUserInfo/%@/%@",userId,str];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    if ([result1 isEqualToString:@"0"]) {
      [SVProgressHUD showSuccessWithStatus:@"恢复成功"];
      NSDictionary *messageDic = @{ @"newMember" : Sellist};
      [[NSNotificationCenter defaultCenter]postNotificationName:addMemberNotification
                                                         object:nil
                                                       userInfo:messageDic];
     [self.navigationController popViewControllerAnimated:YES];
    }
    
  } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"恢复失败"];
  }];
    
    
}

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      static NSString *CellIdentifier = @"AddPersonnelCell";
    AddPersonnelCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
      cell = [[[NSBundle mainBundle]loadNibNamed:@"AddPersonnelCell" owner:nil options:nil]objectAtIndex:0];
      cell.accessoryType = UITableViewCellAccessoryNone;
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
      }
    [cell.addbutton addTarget:self action:@selector(selectAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.addbutton.selected = [[buttonArray objectAtIndex:indexPath.row] boolValue];
    
    cell.addbutton.tag =indexPath.row+100;
    
    NSDictionary *dic =[dataArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [dic objectForKey:@"USERPRC"];
    cell.phoneLabel.text = [dic objectForKey:@"MOBILECODE"];
    
    
    return cell;
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
