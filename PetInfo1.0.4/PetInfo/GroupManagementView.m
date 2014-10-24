//
//  GroupManagementView.m
//  LandTex
//
//  Created by 海普科技  on 14-7-14.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "GroupManagementView.h"
#import "GroupManagementCell.h"
#import "CreatGroupView.h"
#import "GroupChatView.h"
@interface GroupManagementView ()

@end

@implementation GroupManagementView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
  [[NSNotificationCenter defaultCenter]removeObserver:self name:@"exitGroup" object:nil];

  [dataArray release];
  [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *POSID =[[userDefaults objectForKey:@"userinfo"] objectForKey:@"POSID"];
    
    if ([POSID integerValue] != 9996) {
  
      CGFloat navRightBtn_w = 25;
      CGFloat navRightBtn_h = 25.f;
      CGFloat navRightBtn_x = App_Frame_Width - 10.f;
      CGFloat navRightBtn_y = (kTopBarHeight - navRightBtn_h) / 2.f;
      UIButton *rightButton = KInitButtonStyle(CGRectMake(navRightBtn_x,navRightBtn_y,navRightBtn_w,
                                                          navRightBtn_h),@"群管理",@"add_group.png",@"add_group_press.png");
      rightButton.exclusiveTouch = YES;
      [rightButton addTarget:self action:@selector(creatGroup:) forControlEvents:UIControlEventTouchUpInside];
      UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
      self.navigationItem.rightBarButtonItem = rightBar;
        
    }
    dataArray = [[NSMutableArray alloc]init];
  [self launchRefreshing];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup:) name:@"exitGroup" object:nil];
}
-(void)exitGroup:(id)sender{
  [self refresh];
}
- (BOOL) refresh
{
  if (![super refresh])
    return NO;
  curPage=1;
  [self performSelector:@selector(getGroupListwithArray1) withObject:nil afterDelay:1.0];
  // See -addItemsOnTop for more info on how to finish loading
  return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (![super loadMore])
    return NO;
  curPage++;
  [self performSelector:@selector(getGroupListwithArray1) withObject:nil afterDelay:1.0];
  return YES;
}
-(void)getGroupListwithArray1{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"GroupService/getGroupList/%@/1/%d/%d",userId,curPage,KPageSize];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    if ([result1 isEqualToString:@"0"]) {
      [self loadDateCompleted];
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


-(void)creatGroup:(id)sender{
  CreatGroupView *crea =[[CreatGroupView alloc]init];
  [self.navigationController pushViewController:crea animated:YES];
  [crea release];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupManagementCell *cell =[tableView dequeueReusableCellWithIdentifier:@"GroupManagementCell"];
    
    if (cell ==nil) {
        
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupManagementCell" owner:nil options:nil]objectAtIndex:0];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic =[dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [dic objectForKey:@"GROUPNAME"];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
  GroupChatView *gro = [[GroupChatView alloc]init];
  gro.groupId = [dic objectForKey:@"GROUPID"];
  gro.groupName = [dic objectForKey:@"GROUPNAME"];
  gro.OWNERUSERID = [dic objectForKey:@"OWNERUSERID"];
  [self.navigationController pushViewController:gro    animated:YES];
  [gro release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
