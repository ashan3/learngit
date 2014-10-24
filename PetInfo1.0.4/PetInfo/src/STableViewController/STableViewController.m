//
// STableViewController.m
//
// @author Shiki
//

#import "STableViewController.h"
#import "DemoTableFooterView.h"
#import "DemoTableHeaderView.h"
#define DEFAULT_HEIGHT_OFFSET 52.0f
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
#define kPRAnimationDuration .18f
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation STableViewController

@synthesize tableView;
@synthesize headerView;
@synthesize footerView;

@synthesize isDragging;
@synthesize isRefreshing;
@synthesize isLoadingMore;

@synthesize canLoadMore;

@synthesize pullToRefreshEnabled;

@synthesize clearsSelectionOnViewWillAppear;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) initialize
{
  pullToRefreshEnabled = YES;
  
  canLoadMore = YES;
  isBusy=NO;
  clearsSelectionOnViewWillAppear = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init
{
  if ((self = [super init]))
    [self initialize];  
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
    [self initialize];
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidLoad
{
  [super viewDidLoad];
  
  self.tableView = [[[UITableView alloc] init] autorelease];
  tableView.frame = self.view.bounds;
  tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  tableView.dataSource = self;
  tableView.delegate = self;
  
  curPage=1;
  [self.view addSubview:tableView];
  NSArray *nib ;
  nib = [[NSBundle mainBundle] loadNibNamed:@"DemoTableHeaderView" owner:self options:nil];
  DemoTableHeaderView *headerView1 = (DemoTableHeaderView *)[nib objectAtIndex:0];
  self.headerView = headerView1;
  
  
  // set the custom view for "load more". See DemoTableFooterView.xib.
  nib = [[NSBundle mainBundle] loadNibNamed:@"DemoTableFooterView" owner:self options:nil];
  DemoTableFooterView *footerView1 = (DemoTableFooterView *)[nib objectAtIndex:0];
  self.footerView = footerView1;
  
  
  UIButton *button = [[UIButton alloc]init];
  button.backgroundColor = NenNewsgroundColor;
  [button setImage:[UIImage imageNamed:@"navagiton_back.png"] forState:UIControlStateNormal];
  button.frame = CGRectMake(0, 0, 40, 40);
  [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
  [button release];
  self.navigationItem.leftBarButtonItem = [backItem autorelease];
}
-(void)backAction{
  [self.navigationController popViewControllerAnimated:YES];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (clearsSelectionOnViewWillAppear) {
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected)
      [self.tableView deselectRowAtIndexPath:selected animated:animated];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Pull to Refresh

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setHeaderView:(UIView *)aView
{
  if (!tableView)
    return;
  
  if (headerView && [headerView isDescendantOfView:tableView])
    [headerView removeFromSuperview];
  [headerView release]; headerView = nil;
  
  if (aView) {
    headerView = [aView retain];
    
    CGRect f = headerView.frame;
    headerView.frame = CGRectMake(f.origin.x, 0 - f.size.height, f.size.width, f.size.height);
    headerViewFrame = headerView.frame;
    
    [tableView addSubview:headerView];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) headerRefreshHeight
{
  if (!CGRectIsEmpty(headerViewFrame))
    return headerViewFrame.size.height;
  else
    return DEFAULT_HEIGHT_OFFSET;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pinHeaderView
{
  [UIView animateWithDuration:0.3 animations:^(void) {
    self.tableView.contentInset = UIEdgeInsetsMake([self headerRefreshHeight], 0, 0, 0);
  }];
  DemoTableHeaderView *hv = (DemoTableHeaderView *)self.headerView;
  [hv.activityIndicator startAnimating];
  hv.title.text = @"正在刷新...";
  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
  hv.arrowImage.hidden = YES;
  [CATransaction commit];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unpinHeaderView
{
  [UIView animateWithDuration:0.3 animations:^(void) {
    self.tableView.contentInset = UIEdgeInsetsZero;
  }];
   [[(DemoTableHeaderView *)self.headerView activityIndicator] stopAnimating];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willBeginRefresh
{ 
  if (pullToRefreshEnabled)
    [self pinHeaderView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willShowHeaderView:(UIScrollView *)scrollView
{
  
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
  DemoTableHeaderView *hv = (DemoTableHeaderView *)self.headerView;
  if (willRefreshOnRelease)
  {
    hv.title.text = @"松开刷新...";
    [CATransaction begin];
    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
    hv.arrowImage.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    [CATransaction commit];
  }
  else
  {
    hv.title.text = @"下拉刷新...";
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    hv.arrowImage.hidden = NO;
    hv.arrowImage.transform = CATransform3DIdentity;
    [CATransaction commit];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		hv.lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:hv.lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) refresh
{
  if (isRefreshing)
    return NO;
  
  [self willBeginRefresh];
  isRefreshing = YES;
  canLoadMore = NO;
  return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) refreshCompleted
{
  isRefreshing = NO;
  canLoadMore = YES;
  if (pullToRefreshEnabled)
    [self unpinHeaderView];
}
- (void) loadDateCompleted
{
   isBusy=NO;
  [self refreshCompleted];
  [self loadMoreCompleted];
  if (curPage == maxPage)
    self.canLoadMore = NO;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load More

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterView:(UIView *)aView
{
  if (!tableView)
    return;
  
  tableView.tableFooterView = nil;
  [footerView release]; footerView = nil;
  
  if (aView) {
    footerView = [aView retain];
    
    tableView.tableFooterView = footerView;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willBeginLoadingMore
{
  DemoTableFooterView *fv = (DemoTableFooterView *)self.footerView;
  [fv.activityIndicator startAnimating];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadMoreCompleted
{
  isLoadingMore = NO;
  DemoTableFooterView *fv = (DemoTableFooterView *)self.footerView;
  [fv.activityIndicator stopAnimating];
  
  if (!self.canLoadMore) {
    // Do something if there are no more items to load
    
    // We can hide the footerView by: [self setFooterViewVisibility:NO];
    
    // Just show a textual info that there are no more items to load
    fv.infoLabel.hidden = NO;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (isLoadingMore&&isRefreshing)
    return NO;
  
  [self willBeginLoadingMore];
  isLoadingMore = YES;  
  return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) footerLoadMoreHeight
{
  if (footerView)
    return footerView.frame.size.height;
  else
    return DEFAULT_HEIGHT_OFFSET;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterViewVisibility:(BOOL)visible
{
  if (visible && self.tableView.tableFooterView != footerView)
    self.tableView.tableFooterView = footerView;
  else if (!visible)
    self.tableView.tableFooterView = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) allLoadingCompleted
{
  if (isRefreshing)
    [self refreshCompleted];
  if (isLoadingMore)
    [self loadMoreCompleted];
}


-(void)setTitle:(NSString *)title{
  [super setTitle:title];
  UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectZero];
  titlelabel.font=[UIFont boldSystemFontOfSize:18.0f];
  titlelabel.backgroundColor= NenNewsgroundColor;
  titlelabel.text=title;
  titlelabel.textColor=NenNewsTextColor;
  [titlelabel sizeToFit];
  self.navigationItem.titleView = [titlelabel autorelease];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [self scrollViewWillDragging];
  if (isRefreshing)
    return;
  isDragging = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (!isRefreshing && isDragging && scrollView.contentOffset.y < 0) {
    [self headerViewDidScroll:scrollView.contentOffset.y < 0 - [self headerRefreshHeight] 
                   scrollView:scrollView];
  }
  else if (!isLoadingMore && canLoadMore) {
    CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    if (scrollPosition < [self footerLoadMoreHeight] && curPage < maxPage) {
      [self loadMore];
    }
  }
}
- (void)launchRefreshing {
  canLoadMore=NO;
  isLoadingMore=YES;
  [self.tableView setContentOffset:CGPointMake(0, -60) animated:NO];
  [UIView animateWithDuration:kPRAnimationDuration animations:^{
    self.tableView.contentInset = UIEdgeInsetsMake(45, 0, 0, 0);
  }];
  if (pullToRefreshEnabled)
    [self refresh];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if (isRefreshing)
    return;
  
  isDragging = NO;
  if (scrollView.contentOffset.y <= 0 - [self headerRefreshHeight]) {
    if (pullToRefreshEnabled)
      [self refresh];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

- (void)scrollViewWillDragging
{
  
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) releaseViewComponents
{
  [headerView release];
  headerView = nil;
  [footerView release];
  footerView = nil;
  [tableView release];
  tableView = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
  
  [self releaseViewComponents];
  [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidUnload
{
  [self releaseViewComponents];
  [super viewDidUnload];
}

@end
