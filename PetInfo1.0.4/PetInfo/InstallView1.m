//
//  InstallView.m
//  MBA
//
//  Created by 海普科技  on 14-5-20.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "InstallView1.h"
#import "PersonalView.h"
#import "MyCommentView.h"
#import "AboutView.h"
#import "ChangePasswordView.h"
#import "UIButton+Block.h"
#import "CSLogInViewController.h"
@interface InstallView1 ()

@end

@implementation InstallView1

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    // Custom initialization
    self.tableView.rowHeight=44;
  }
  return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
   [self.view setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"bg.png"]]];
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }else if (section ==1){
        return 3;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    cell.accessoryType =UITableViewCellStyleValue1;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor =[UIColor grayColor];
    
    
    if (indexPath.section ==0) {
        
        if (indexPath.row ==0) {
            cell.textLabel.text =@"个人中心";
        }else if (indexPath.row ==1){
            
            cell.textLabel.text =@"修改密码";

        }else if (indexPath.row ==2){
            cell.textLabel.text =@"清除缓存";

            
        }
    }else if (indexPath.section ==1){
        
        if (indexPath.row ==0) {
            cell.textLabel.text =@"我的评论";
        }else if (indexPath.row ==1){
            
            cell.textLabel.text =@"我的收藏";
            
        }else if (indexPath.row ==2){
            cell.textLabel.text =@"关于";
            
        }

    }
  else if (indexPath.section ==2){
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0.0f, 0.0f, 300.0f, 45.0f);
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"bigBtn"] forState:UIControlStateNormal];
    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    [logoutBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
    [ CSLogInViewController logOut];
    }];
    
    [cell.contentView addSubview:logoutBtn];
  }
  
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.section ==0) {
    if (indexPath.row ==0) {
      PersonalView *per =[[PersonalView alloc]init];
      [self.navigationController pushViewController:per animated:YES];
      [per release];
      
    }else if (indexPath.row ==1){
      ChangePasswordView *cha = [[ChangePasswordView alloc]init];
      [self.navigationController pushViewController:cha animated:YES];
      [cha release];
      
    }else if (indexPath.row ==2){
      [[DataCenter sharedCenter] cleanCache];
        [SVProgressHUD showSuccessWithStatus:@"清除缓存成功"];
      
      //异步清除缓存
    }
    
  }else if (indexPath.section ==1){
    
    if (indexPath.row ==0) {
      MyCommentView *com =[[MyCommentView alloc]init];
      com.commentOrCollect=@"CommentService/getCommentInfoListPage";
      [self.navigationController pushViewController:com animated:YES];
      [com release];
    
    }else if (indexPath.row ==1){
      MyCommentView *com =[[MyCommentView alloc]init];
      com.commentOrCollect=@"CollectService/userCollectList";
      [self.navigationController pushViewController:com animated:YES];
      [com release];

    }else if (indexPath.row ==2){
      AboutView *abo = [[AboutView alloc]init];
      [self.navigationController pushViewController:abo animated:YES];
      [abo release];
    }
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
