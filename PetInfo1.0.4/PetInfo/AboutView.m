//
//  AboutView.m
//  MBA
//
//  Created by 海普科技  on 14-5-21.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "AboutView.h"

@interface AboutView ()

@end

@implementation AboutView

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
    self.title =@"关于";

    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
