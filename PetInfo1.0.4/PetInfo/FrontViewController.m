//
//  FrontViewController.m
//  hack
//
//  Created by ZhaoyangSu on 13-7-20.
//  Copyright (c) 2013年 ZhaoyangSu. All rights reserved.
//

#import "FrontViewController.h"

#import "AnswerView.h"
@interface FrontViewController ()
@property (nonatomic, assign) NSInteger selected;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@end

@implementation FrontViewController
- (id)init
{
  if (self = [super init])
  {
    
  }
  return self;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  self.title = @"你问我答";
  NSArray *items = [NSArray arrayWithObjects:
                    @"已回答",
                    @"未回答",
                    nil];
	segmentedControl = [[MCSegmentedControl alloc] initWithItems:items];
	
	// set frame, add to view, set target and action for value change as usual
	segmentedControl.frame = CGRectMake(37.0f, 5.0f, 246.0f, 34.0f);
	[segmentedControl addTarget:self action:@selector(segmentedControlDidChange1:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.selectedSegmentIndex = _selected;
	segmentedControl.tintColor = UIColorFromRGB(0x386cb8);
	segmentedControl.selectedItemColor   = [UIColor whiteColor];
	segmentedControl.unselectedItemColor =  UIColorFromRGB(0x90a1ab);
	[self.view addSubview:segmentedControl];
  
  if (!self.viewControllers) {
    self.viewControllers = [[NSMutableArray alloc]initWithCapacity:2];
    AnswerView *briefVC = [[AnswerView alloc]init];
    briefVC.statusFlag=@"1";
    briefVC.frontVC = self;
    AnswerView *mediaVC = [[AnswerView alloc]init];
    [self.viewControllers addObject:briefVC];
    mediaVC.statusFlag=@"0";
    mediaVC.frontVC = self;
    [self.viewControllers addObject:mediaVC];
    [mediaVC.view setFrame:CGRectMake(0.0f, 45.0f, App_Frame_Width, App_Frame_Height - kTopBarHeight-44)];
    [briefVC.view setFrame:CGRectMake(0.0f, 45.0f, App_Frame_Width, App_Frame_Height - kTopBarHeight-44)];
     mediaVC.view.hidden=YES;
    [self.view addSubview:briefVC.view];
    [self.view addSubview:mediaVC.view];
    [briefVC release];
    [mediaVC release];
  }
  
  
  
}
- (void)backclick{
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setBackgroundColor: [UIColor whiteColor]];
  BACKBUTTON(backclick);


}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}
- (void)viewDidUnload
{
  [super viewDidUnload];
  for (UIViewController *viewController in self.viewControllers)
  {
    [viewController removeFromParentViewController];
  }
  [self.viewControllers removeAllObjects];
  
}
- (void)segmentedControlDidChange1:(MCSegmentedControl *)sender
{
	NSLog(@"%d", [sender selectedSegmentIndex]);
  if (_selected != [sender selectedSegmentIndex])
  {
    UIViewController *oldController = self.viewControllers[_selected];
    _selected = [sender selectedSegmentIndex];
    UIViewController *newController = self.viewControllers[[sender selectedSegmentIndex]];
    oldController.view.hidden=YES;
    newController.view.hidden=NO;
  }
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  [segmentedControl release];
  [_viewControllers release];
  [super dealloc];
}


@end
