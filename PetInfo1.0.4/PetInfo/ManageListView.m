//
//  ManageListView.m
//  LandTex
//
//  Created by 海普科技  on 14-7-4.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "ManageListView.h"
#import "PersonnelmanageView.h"
#import "FrontViewController.h"
#import "HotNewsView.h"
@interface ManageListView ()

@end

@implementation ManageListView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    

    
}

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)sender:(UIButton*)sender{
    
    
    if (sender.tag ==101) {
        
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      
      NSNumber *POSID =[[userDefaults objectForKey:kUserinfo] objectForKey:@"POSID"];
      
      if ([POSID integerValue] == 9997) {
        
        PersonnelmanageView *per =[[PersonnelmanageView alloc]init];
        
        [self.navigationController pushViewController:per animated:YES];
        [per release];
        
      }else{
        
//        ChackTexUserView *cha = [[ChackTexUserView alloc]init];
//        cha.UserID =[[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
//        [self.navigationController pushViewController:cha animated:YES];
        
      }

      
    }else if (sender.tag ==102){
  
      FrontViewController *ans =[[FrontViewController alloc]init];
      
      [self.navigationController pushViewController:ans animated:YES];
      [ans release];
      
    }else{
        
      HotNewsView *hot = [[HotNewsView alloc]init];
      
      [self.navigationController pushViewController:hot animated:YES];
      [hot release];
      
    }
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
