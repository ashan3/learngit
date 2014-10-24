//
//  PersonnelmanageView.m
//  LandTex
//
//  Created by 海普科技  on 14-7-4.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "PersonnelmanageView.h"
#import "PersonnelmanageCell.h"
#import "AddPersonneView.h"
#import "AddBlackView.h"
@interface PersonnelmanageView ()

@end
@implementation PersonnelmanageView
@synthesize dataArray;
@synthesize button1Array;
@synthesize button2Array;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
  [[NSNotificationCenter defaultCenter]removeObserver:self name:addMemberNotification object:nil];
  [dataArray release];
  [button1Array release];
  [tableContent release];
  [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"成员管理";


  self.button1Array = [[ NSMutableArray alloc]init];
  self.button2Array =[[NSMutableArray alloc]init];
  self.dataArray = [[NSMutableArray alloc]init];
  
  
  UIButton *rightButton = KInitButtonStyle(CGRectMake(0, 0, 25, 25),@"查看",@"tj.png",@"tj_press.png");
  rightButton.exclusiveTouch = YES;
[rightButton addTarget:self action:@selector(navRightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
  self.navigationItem.rightBarButtonItem = rightBar;
  
  [[NSNotificationCenter defaultCenter]addObserver:self
                                          selector:@selector(addMember:)
                                              name:addMemberNotification object:nil];

    

  self.tableView.frame= CGRectMake(0, 40, 320, App_Frame_Width+40);
  [self launchRefreshing];
  
}
- (BOOL) refresh
{
  if (![super refresh])
    return NO;
  curPage=1;
  [self performSelector:@selector(getTaxUsersList) withObject:nil afterDelay:1.0];
  // See -addItemsOnTop for more info on how to finish loading
  return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (![super loadMore])
    return NO;
  curPage++;
  [self performSelector:@selector(getTaxUsersList) withObject:nil afterDelay:1.0];
  return YES;
}
- (void)addMember:(NSNotification *)note
{
  NSArray *changed = note.userInfo[@"newMember"];
  [self.dataArray addObjectsFromArray:changed];
  for (int i=0 ; i<changed.count; i++) {
    
    [button1Array addObject:@"0"];
    
    [button2Array addObject:@"0"];
    
  }
  
  [self.tableView reloadData];
}
-(IBAction)chackBlack:(id)sender
{
  AddBlackView *addb =   [[AddBlackView alloc]init];
  [self.navigationController pushViewController:addb animated:YES];
  [addb release];
}

- (void)navRightBtnPressed{
  AddPersonneView *addb =   [[AddPersonneView alloc]init];
  [self.navigationController pushViewController:addb animated:YES];
  [addb release];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identify = @"PersonnelmanageCell";
  PersonnelmanageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonnelmanageCell" owner:nil options:nil] lastObject];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
  }
    NSDictionary *dic =[dataArray objectAtIndex:indexPath.row];
    
    NSInteger POSID = [[dic objectForKey:@"POSID"] integerValue];
    
    if (POSID ==9996) {
        
        cell.jueseLabel.text = @"纳税人";
    }else if (POSID ==9997){
        
        cell.jueseLabel.text = @"分管员";
        
    }else if (POSID ==9998){
        
        cell.jueseLabel.text = @"分管领导";
    }else if (POSID ==99999){
        
        cell.jueseLabel.text = @"部门负责人";
        
    }
    
    cell.nameLabel.text = [dic objectForKey:@"USERPRC"];
    cell.phoneLabel.text = [dic objectForKey:@"MOBILECODE"];
    
    
    
    [cell.button1 addTarget:self action:@selector(selectButton1:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button2 addTarget:self action:@selector(selectButton2:) forControlEvents:UIControlEventTouchUpInside];
    cell.button1.selected = [[button1Array objectAtIndex:indexPath.row] boolValue];
    cell.button2.selected = [[button2Array objectAtIndex:indexPath.row] boolValue];
    
    
    cell.button1.tag = indexPath.row +100;
    cell.button2.tag = indexPath.row +200;
    
    
    return cell;
}
-(void)selectButton1:(UIButton*)sender{
    
    UIButton * button = (UIButton*)[self.view viewWithTag:sender.tag+100];
    
    if (button.selected==NO) {
        

    if (sender.selected==NO) {
        
        sender.selected =YES;
        [button1Array setObject:@"1" atIndexedSubscript:sender.tag-100];
        
        
    }else{
        sender.selected =NO;
        
        [button1Array setObject:@"0" atIndexedSubscript:sender.tag-100];
        
    }
    
    }
}
-(void)selectButton2:(UIButton *)sender{
    
    UIButton * button = (UIButton*)[self.view viewWithTag:sender.tag-100];
    if (button.selected==NO) {
        
        if (sender.selected==NO) {
            sender.selected =YES;
            [button2Array setObject:@"1" atIndexedSubscript:sender.tag-200];
            
        }else{
            sender.selected =NO;
            [button2Array setObject:@"0" atIndexedSubscript:sender.tag-200];
            
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
-(void)sender:(id)sender{
    
    
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i =0 ; i<button2Array.count; i++) {
        
        NSString *string = [button2Array objectAtIndex:i];
        if ([string isEqual:@"1"]) {
            
            NSDictionary *dic = [dataArray objectAtIndex:i];
            
            NSString * userID =[dic objectForKey:@"USERID"];
            
            if (str.length ==0) {
                
                [str appendFormat:@"%@",userID];
                

            }else{
              
                [str appendFormat:@",%@",userID];
            }
        }
        
    }
    
      NSString *Url = [NSString stringWithFormat:@"UserInfoService/updateTaxBlack/%@/%@",str,@"1"];
      [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
        NSString *result1 = [result objectForKey:@"result"];
        NSLog(@"result = %@",result);
        if ([result1 isEqualToString:@"0"]) {
          [SVProgressHUD showSuccessWithStatus:@"恢复成功"];
        }
      } andErrorBlock:^(NSError *error) {
      }];

    str = [[NSMutableString alloc]init];
    for (int i =0 ; i<button1Array.count; i++) {
        
        NSString *string = [button1Array objectAtIndex:i];
        if ([string isEqual:@"1"]) {
            
            NSDictionary *dic = [dataArray objectAtIndex:i];
            
            NSString * userID =[dic objectForKey:@"USERID"];
            
            if (str.length ==0) {    
                [str appendFormat:@"%@",userID];
              
            }else{
              
                [str appendFormat:@",%@",userID];
            }
        }
        
    }
  
  Url = [NSString stringWithFormat:@"UserInfoService/updateTaxUserInfo/%@/%@",@"0",str];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    if ([result1 isEqualToString:@"0"]) {
      [SVProgressHUD showSuccessWithStatus:@"恢复成功"];
    }
    
  } andErrorBlock:^(NSError *error) {
  }];
  

}
-(void)getTaxUsersList{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
     NSString *Url = [NSString stringWithFormat:@"UserInfoService/getTaxUsersList/%@/%d/%d",userId,curPage,KPageSize];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    if ([result1 isEqualToString:@"0"]) {
          [self loadDateCompleted];
      NSArray * pagearray =[result objectForKey:@"page"];
      maxPage = [[[pagearray firstObject] objectForKey:@"PAGECOUNT"] intValue];
      if(curPage == 1){
        [self.dataArray removeAllObjects];
         [self.button1Array removeAllObjects];
         [self.button1Array removeAllObjects];
      }
      if(![[result objectForKey:@"data"] isEqual:[NSNull null]])
      {
      NSMutableArray *list=[[NSMutableArray alloc]initWithArray:[result objectForKey:@"data"]];
      [self.dataArray addObjectsFromArray:list];
      [list release];
      }
      for (int i=0 ; i<dataArray.count; i++) {
        
        [button1Array addObject:@"0"];
        
        [button2Array addObject:@"0"];
        
      }
      [self.tableView reloadData];
    }
  } andErrorBlock:^(NSError *error) {
         [self loadDateCompleted];
  }];
  
}
-(void)updataTexBlackWithArray:(NSArray*)array request:(id)request{
    NSLog(@"login-aray=%@",array);
    
    NSDictionary *dic  =[array objectAtIndex:0];
    
    NSString *result = [dic objectForKey:@"result"];
    NSLog(@"result = %@",result);
    if ([result isEqualToString:@"0"]) {
     
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
