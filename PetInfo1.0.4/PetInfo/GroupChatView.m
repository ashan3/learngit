//
//  GroupChatView.m
//  LandTex
//
//  Created by 海普科技  on 14-7-14.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "GroupChatView.h"
#import "GroupChatCell.h"
#import "GroupSettingsView.h"
@interface GroupChatView ()

@end

@implementation GroupChatView
@synthesize groupId,groupName,OWNERUSERID;
@synthesize selectedIndexPath,messageId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
  [dataArray release];
  [footView release];
  [messageField release];
  [messageId release];
  [groupId release];
  [OWNERUSERID release];
  [selectedIndexPath release];
  [groupName release];
  [super dealloc];
}
-(id)initWithGroupId:(NSString *)_groupId{
  
    self = [super init];
    if (self) {
        groupId = [NSString stringWithString:_groupId];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =groupName;
   // self.tableView.frame= CGRectMake(0, 0, 320, App_Frame_Height);
  [self.view bringSubviewToFront:footView];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
    
    if ([userId isEqual:OWNERUSERID]) {
       
        UIButton *rightButton = KInitButtonStyle(CGRectMake(0, 0, 25, 25),@"查看",@"group_set.png",@"group_set_press.png");
        rightButton.exclusiveTouch = YES;
        [rightButton addTarget:self action:@selector(groupSetting:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBar;
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    NSLog(@"groupID = %@",groupId);
    
    dataArray =[[NSMutableArray alloc]init];
   [self launchRefreshing];
}

- (BOOL) refresh
{
  if (![super refresh])
    return NO;
  curPage=1;
  [self performSelector:@selector(getMessageWithArray) withObject:nil afterDelay:1.0];
  // See -addItemsOnTop for more info on how to finish loading
  return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (![super loadMore])
    return NO;
  curPage++;
  [self performSelector:@selector(getMessageWithArray) withObject:nil afterDelay:1.0];
  return YES;
}

-(void)getMessageWithArray{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [NSString stringWithFormat:@"GroupService/getMessageByGroupId/%@/%@/%d/%d",userId,groupId,curPage,KPageSize];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    NSString *result1 = [result objectForKey:@"result"];
    NSLog(@"result = %@",result);
    [self loadDateCompleted];
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

-(void)groupSetting:(id)sender{
  GroupSettingsView *gro = [[GroupSettingsView alloc]init];
  gro.groupName = groupName;
  gro.groupId = groupId;
  [self.navigationController pushViewController:gro animated:YES];
  [gro release];
}
-(void)senderMessage:(id)sender{
    if (messageField.text.length>0) {
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
      NSString *Url = [[NSString stringWithFormat:@"GroupService/addGroupMessage/%@/%@/%@",userId,groupId,messageField.text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
        NSString *result1 = [result objectForKey:@"result"];
        if ([result1 isEqualToString:@"0"]) {
          [self loadDateCompleted];
          [messageField resignFirstResponder];
           messageField.text = @"";
          [self refresh];
          [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
      } andErrorBlock:^(NSError *error) {
        [self loadDateCompleted];
      }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupChatCell *cell =[tableView dequeueReusableCellWithIdentifier:@"GroupChatCell"];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupChatCell" owner:nil options:nil]objectAtIndex:0];
    }
  
    NSDictionary *dic =[dataArray objectAtIndex:indexPath.row];
    NSString *userId = [dic objectForKey:@"USERID"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * myuserID = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  
    if ([myuserID isEqual:userId]) {
     
        [cell.nameLabel setHidden:YES];
        [cell.timeLabel setHidden:YES];
        [cell.headImage setHidden:YES];
        [cell.nameLabel2 setHidden:NO];
        [cell.timeLabel2 setHidden:NO];
        [cell.headImage2 setHidden:NO];
        cell.nameLabel2.text = [dic objectForKey:@"USERNAME"];
        cell.timeLabel2.text = [dic objectForKey:@"MESSAGETIME"];
    }else{
        
        [cell.nameLabel setHidden:NO];
        [cell.timeLabel setHidden:NO];
        [cell.headImage setHidden:NO];
        [cell.nameLabel2 setHidden:YES];
        [cell.timeLabel2 setHidden:YES];
        [cell.headImage2 setHidden:YES];
    cell.nameLabel.text = [dic objectForKey:@"USERNAME"];
    cell.timeLabel.text = [dic objectForKey:@"MESSAGETIME"];

    }
    cell.messageLabel.text = [dic objectForKey:@"MESSAGE"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (messageField.editing) {
        NSLog(@"-----------");
        [messageField resignFirstResponder];
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
        if ([userId isEqual:OWNERUSERID]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否删除消息" message:nil delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
        self.messageId = [dic objectForKey:@"MESSAGEID"];
        [alert show];
        self.selectedIndexPath=indexPath;
    }
        
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex ==0) {
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
      NSString *Url = [NSString stringWithFormat:@"GroupService/deleteGroupMessage/%@/%@",userId,messageId];
      [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
        NSString *result1 = [result objectForKey:@"result"];
        if ([result1 isEqualToString:@"0"]) {
          [self loadDateCompleted];
          [dataArray removeObjectAtIndex:selectedIndexPath.row];
          [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:YES];
          [self.tableView reloadData];
        }
      } andErrorBlock:^(NSError *error) {
        [self loadDateCompleted];
      }];
    }
}


-(void) keyBoardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = footView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	footView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyBoardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = footView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	footView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
