//
//  SubscribeView.m
//  MBA
//
//  Created by 海普科技  on 14-5-20.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "SubscribeView.h"
#import "SubscribeViewCell.h"
#import "UtilDefine.h"
#import "UIImageView+WebCache.h"
@interface SubscribeView ()

@end

@implementation SubscribeView
- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    // Custom initialization
  }
  return self;
}
- (void)dealloc {
  [dataArray release];
  [selArray release];
  [_showNameArray release];
  [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  self.title =@"订阅";
  dataArray = [[NSMutableArray alloc]init];
  selArray =[[NSMutableArray alloc]init];
  _showNameArray =[[NSMutableArray alloc]init];
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *companyId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"COMPANYID"];
  NSString *Url = [NSString stringWithFormat:@"NavigationService/getTaxSubscriptionColumnInfoList/%@/%@",companyId,userId];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    if ([result1 isEqualToString:@"0"]) {
       [dataArray addObjectsFromArray: [result objectForKey:@"data"]];
      for(int i =0 ;i<dataArray.count;i++){
        NSDictionary *dict =[dataArray objectAtIndex:i];
        NSString *str = [dict objectForKey:@"COLUMNSTATUS"];
        [selArray addObject:str];
      }
      [self.tableView reloadData];
    }

  } andErrorBlock:^(NSError *error) {
    
  }];
}


-(void)viewWillDisappear:(BOOL)animated{
  NSMutableString *ColumnId =[NSMutableString stringWithString:@""];
  for (int i= 0; i<selArray.count; i++) {
    NSString *str = [selArray objectAtIndex:i];
    if ([str intValue]==1) {
      NSDictionary *dic = dataArray[i] ;
      NSString *columnId = [dic objectForKey:@"COLUMNID"];
      NSString *ColumnName = [dic objectForKey:@"COLUMNNAME"];
      NSString *isPic = @"1";
      NSDictionary *dic1 = @{@"columnId": columnId,@"name":ColumnName,@"showimage":isPic};
      [_showNameArray addObject:dic1];
      if (ColumnId.length==0) {
        [ColumnId appendString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"COLUMNID"]]] ;
        
      }else{
        
        [ColumnId appendString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"COLUMNID"]]] ;
      }
      
    }
    
  }
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray*  CompareshowNameArray = [[NSMutableArray alloc]initWithArray:[userDefaults objectForKey:show_column]];
  if(![_showNameArray isEqualToArray:CompareshowNameArray])
  {
    NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
    NSString *Url = [NSString stringWithFormat:@"NavigationService/updateColumnInfoList/%@/%@",userId,ColumnId];
    [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
      NSString *result1 = [result objectForKey:@"result"];
      NSLog(@"result = %@",result);
      if ([result1 isEqualToString:@"0"]) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSMutableArray*  CompareshowNameArray = [[NSMutableArray alloc]initWithArray:[user objectForKey:show_column]];
        [user setValue:_showNameArray forKey:show_column];
        [self.eventDelegate columnChanged:_showNameArray];
        [user synchronize];
        [CompareshowNameArray release];
        [super viewWillDisappear:animated];
      }
    } andErrorBlock:^(NSError *error) {
      
    }];
  }
  [CompareshowNameArray release];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  static NSString *CellIdentifier = @"SubscribeViewCell";
  SubscribeViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell ==nil) {
    cell = [[[NSBundle mainBundle]loadNibNamed:@"SubscribeViewCell" owner:nil options:nil]objectAtIndex:0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
  }
   NSDictionary *dic =[dataArray objectAtIndex:indexPath.row];
  NSLog(@"%@",dic);
  cell.titleLabel.text =[dic objectForKey:@"COLUMNNAME"];
  cell.subLabel.text= [dic objectForKey:@"DESCRIPTION"];
  [cell.headimage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"LOGOIMAGESHOWNAME"]] placeholderImage:LogoImage];
  
  if ([[selArray objectAtIndex:indexPath.row] intValue]==1) {
    
    cell.sleButton.selected=YES;
    
  }
  
  [cell.sleButton addTarget:self action:@selector(selectSub:) forControlEvents:UIControlEventTouchUpInside];
  cell.sleButton.tag= indexPath.row +100;
  return cell;

}

-(void)selectSub:(UIButton*)sender{
  
    int i =sender.tag -100;
    
    if (sender.selected==YES) {
        
        [selArray setObject:@"0" atIndexedSubscript:i];
        
        
        sender.selected=NO;
    }else{
        
        [selArray setObject:@"1" atIndexedSubscript:i];
        
        sender.selected =YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
