//
//  zysViewController.m
//  MyGitDemo
//
//  Created by 张远山 on 14-10-24.
//  Copyright (c) 2014年 张远山. All rights reserved.
//

#import "zysViewController.h"

@interface zysViewController ()
@property (nonatomic) int sum;
@end

@implementation zysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  int a = 5;
  int b = 10;
  self.sum = a + b;
  NSLog(@"The result is: %d", self.sum);
}

@end
