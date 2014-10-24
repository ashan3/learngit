//
//  GroupSettingsView.m
//  LandTex
//
//  Created by 海普科技  on 14-7-15.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "GroupSettingsView.h"
#import "GroupSettingCell.h"
#import "AddGroupMember.h"
#import "ChangeGroupNameVIew.h"
#import "AppButton.h"

#define WIDTH  65
#define HIGHT  105

#define TAGH  10

#define BTNWIDTH  WIDTH - TAGH
#define BTNHIGHT  HIGHT - TAGH



@interface GroupSettingsView ()

@end

@implementation GroupSettingsView
@synthesize groupId,groupName;
@synthesize headView;
@synthesize dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changegroupName" object:nil];
  [_tableView release];
  [dataArray release];
  [groupId release];
  [groupName release];
  [headView release];
  [super dealloc];
}
- (void)viewDidLoad
{
   [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changegroupName:) name:@"changegroupName" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{//http://www.seekhi.com/edibleOil.ui/services/GroupService/getGroupMember/18002/1/100/
  NSString *Url = [NSString stringWithFormat:@"GroupService/getGroupMember/%@/1/100/",groupId];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    if ([result1 isEqualToString:@"0"]) {
      if(![[result objectForKey:@"data"] isEqual:[NSNull null]])
      {
      NSMutableArray *list=[[NSMutableArray alloc]initWithArray:[result objectForKey:@"data"]];
      self.dataArray =list;
      [list release];
      }
      [self setmenuScorllView];
    }
  } andErrorBlock:^(NSError *error) {
  }];
}
-(void)setmenuScorllView{
  [headView removeFromSuperview];
  [headView release];
   headView=nil;
  int width = self.view.frame.size.width/4;
  int height = ([dataArray count]+1)/4+1;
  self.headView = [[[UIView alloc] initWithFrame:CGRectMake( 5,10, 320, HIGHT*height)] autorelease];
  for (int i = 0; i < [dataArray count]+2; i++)
  {
    int t = i/4;
    int d = fmod(i, 4);
    if (i==dataArray.count) {
      UIView *nView = [[[UIView alloc] initWithFrame:CGRectMake(width * d + 5, HIGHT * t +10, WIDTH, HIGHT)] autorelease];
      CAppButton *appBtn = [CAppButton BtnWithType:UIButtonTypeCustom];
      [appBtn setFrame:CGRectMake(TAGH, TAGH, BTNWIDTH, BTNHIGHT)];
      [appBtn setImage:[UIImage imageNamed:@"useradd.png"] forState:UIControlStateNormal];
      [appBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
      [appBtn addTarget:self action:@selector(touchTheMenu:) forControlEvents:UIControlEventTouchUpInside];
      appBtn.tag =i;
      [nView addSubview:appBtn];
      [self.headView addSubview:nView];
       nView.userInteractionEnabled = YES;
    }
    else if (i==(dataArray.count+1)) {
      UIView *nView = [[[UIView alloc] initWithFrame:CGRectMake(width * d + 5, HIGHT * t +10, WIDTH, HIGHT)] autorelease];
      CAppButton *appBtn = [CAppButton BtnWithType:UIButtonTypeCustom];
      [appBtn setFrame:CGRectMake(TAGH, TAGH, BTNWIDTH, BTNHIGHT)];
      [appBtn setImage:[UIImage imageNamed:@"userdel.png"] forState:UIControlStateNormal];
      [appBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
      [appBtn addTarget:self action:@selector(touchTheMenu:) forControlEvents:UIControlEventTouchUpInside];
       appBtn.tag =i;
      [nView addSubview:appBtn];
      [self.headView addSubview:nView];
      nView.userInteractionEnabled = YES;
    }
    
   else
   {
    NSDictionary *dic = [dataArray objectAtIndex:i];
    UIView *nView = [[[UIView alloc] initWithFrame:CGRectMake(width * d + 5, HIGHT * t +10, WIDTH, HIGHT)] autorelease];
    CAppButton *appBtn = [CAppButton BtnWithType:UIButtonTypeCustom];
    [appBtn setFrame:CGRectMake(TAGH, TAGH, BTNWIDTH, BTNHIGHT)];
    [appBtn setImage:[UIImage imageNamed:@"userset.png"] forState:UIControlStateNormal];
    [appBtn setTitle:[dic objectForKey:@"USERPRC"] forState:UIControlStateNormal];
    [appBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [appBtn addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    appBtn.tag = i;
    [nView addSubview:appBtn];
     
     NSNumber *number=[dic objectForKey:@"USERID"];
     if([number intValue]!= 422&&[number intValue]!= 339&&[number intValue]!= 283)
     {
       UIImageView *tagImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
       [tagImgView setImage:[UIImage imageNamed:@"deleteTag.png"]];
       [tagImgView setHidden:YES];
       [nView addSubview:tagImgView];
     }
      [self.headView addSubview:nView];
     nView.userInteractionEnabled = NO;
   }
  }
  _tableView.tableHeaderView = headView;
  [_tableView reloadData];
}

-(void)touchTheMenu:(UIButton *)sender{
  if (sender.tag ==(dataArray.count)) {
    AddGroupMember *add = [[AddGroupMember alloc]init];
    add.groupId =groupId;
    [self.navigationController pushViewController:add animated:YES];
    [add release];
  }else if (sender.tag ==(dataArray.count+1)){
    
    if (sender.selected ==YES) {
       sender.selected =NO;
      for (UIView *view in self.headView.subviews)
      {
        for (UIView *v in view.subviews)
        {
          if ([v isMemberOfClass:[UIImageView class]])
          {
            [v setHidden:YES];
            [v superview].userInteractionEnabled =NO;
          }
        }
      }
    }else{
      
      sender.selected =YES;
      for (UIView *view in self.headView.subviews)
      {
        for (UIView *v in view.subviews)
        {
          if ([v isMemberOfClass:[UIImageView class]])
          {
            [v setHidden:NO];
            [v superview].userInteractionEnabled =YES;
          }
        }
      }
    }
    
  }
}
- (void)btnClicked:(id)sender event:(id)event
{
  UIButton *btn = (UIButton *)sender;
  if (btn.tag ==(dataArray.count+1)||btn.tag ==(dataArray.count))
    return;
  [self deleteAppBtn:btn.tag];
}

- (void)deleteAppBtn:(int)index
{
  NSDictionary *dic = [dataArray objectAtIndex:index];
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"GroupService/changeGroupMember/%@/%@/1/%@",userId,groupId,[dic objectForKey:@"USERID"]];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    if ([result1 isEqualToString:@"0"]) {
      [SVProgressHUD showSuccessWithStatus:@"删除成员成功"];
      NSArray *views = self.headView.subviews;
      __block CGRect newframe;
      for (int i = index; i < [dataArray count]+2; i++)
      {
        UIView *obj = [views objectAtIndex:i];
        __block CGRect nextframe = obj.frame;
        if (i == index)
        {
          [obj removeFromSuperview];
        }
        else
        {
          for (UIView *v in obj.subviews)
          {
            if ([v isMemberOfClass:[CAppButton class]])
            {
              v.tag = i - 1;
              break;
            }
          }
          [UIView animateWithDuration:0.6 animations:^
           {
             obj.frame = newframe;
           } completion:^(BOOL finished)
           {
           }];
        }
        newframe = nextframe;
      }
      [dataArray removeObjectAtIndex:index];
      
      int height = ([dataArray count]+1)/4+1;
      self.headView.frame=CGRectMake( 5,10, 320, HIGHT*height);
      _tableView.tableHeaderView = headView;
      [_tableView reloadData];

    }
  } andErrorBlock:^(NSError *error) {
    
  }];
  
 }
-(void)changegroupName:(NSNotification*)sender{
    NSDictionary *dic = [sender userInfo];
    self.groupName = [[dic objectForKey:@"groupName"] copy];
    [_tableView reloadData];
}
-(void)exitGroup:(id)sender{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
  [alert show];
  [alert release];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
    NSString *Url = [NSString stringWithFormat:@"GroupService/exitGroup/%@/%@",userId,groupId];
      [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
        NSString *result1 = [result objectForKey:@"result"];
        if ([result1 isEqualToString:@"0"]) {
          [self.navigationController popToViewController:  [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -3]
                                                animated:YES];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"exitGroup" object:nil];
          
        }
      } andErrorBlock:^(NSError *error) {

      }];
    }
}
-(void)exitGroupWithArray:(NSArray *)array request:(id)request{
    
    NSLog(@"array =%@",array);
    
    NSDictionary *dic  =[array objectAtIndex:0];
    
    NSString *result = [dic objectForKey:@"result"]; 
    NSLog(@"result = %@",result);
    if ([result isEqualToString:@"0"]) {
        [self.navigationController popToViewController:  [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -3]
                                              animated:YES];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"exitGroup" object:nil];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   GroupSettingCell *cell =[tableView dequeueReusableCellWithIdentifier:@"GroupSettingCell"];
    if (cell ==nil) {
   
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupSettingCell" owner:nil options:nil]objectAtIndex:0];
        
    }
   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.nameLabel.text =groupName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  ChangeGroupNameVIew *change = [[ChangeGroupNameVIew alloc]init];
  change.groupId =groupId;
  change.groupName =groupName;
  [self.navigationController pushViewController:change animated:YES];
  [change release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
