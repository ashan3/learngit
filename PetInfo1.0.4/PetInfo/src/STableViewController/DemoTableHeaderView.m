//
// DemoTableHeaderView.m
//
// @author Shiki
//

#import "DemoTableHeaderView.h"
#define kPROffsetY 60.f
#define kPRMargin 5.f
#define kPRLabelHeight 20.f
#define kPRLabelWidth 100.f
#define kPRArrowWidth 20.f
#define kPRArrowHeight 40.f

#define kTextColor [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define kPRAnimationDuration .18f

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DemoTableHeaderView

@synthesize title;
@synthesize activityIndicator,lastUpdatedLabel,arrowImage;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) awakeFromNib
{
  self.backgroundColor = [UIColor clearColor];
  
  UIFont *ft = [UIFont systemFontOfSize:12.f];
  title = [[UILabel alloc] init ];
  title.font = ft;
  title.textColor = kTextColor;
  title.textAlignment = UITextAlignmentCenter;
  title.backgroundColor = [UIColor clearColor];
  title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  title.text = NSLocalizedString(@"下拉刷新", @"");
  [self addSubview:title];
  
  lastUpdatedLabel = [[UILabel alloc] init ];
  lastUpdatedLabel.font = ft;
  lastUpdatedLabel.textColor = kTextColor;
  lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
  lastUpdatedLabel.backgroundColor = [UIColor clearColor];
  lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  lastUpdatedLabel.text = NSLocalizedString(@"最后更新", @"");
  [self addSubview:lastUpdatedLabel];
  
  _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) ];
  arrowImage = [CALayer layer];
  arrowImage.frame = CGRectMake(0, 0, 20, 20);
  arrowImage.contentsGravity = kCAGravityResizeAspect;
  arrowImage.contents = (id)[UIImage imageWithCGImage:[UIImage imageNamed:@"blueArrow"].CGImage scale:1 orientation:UIImageOrientationDown].CGImage;
  [self.layer addSublayer:arrowImage];
  
  activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [self addSubview:activityIndicator];
  
  [self layouts];
  
 
  [super awakeFromNib];
}
- (void)layouts {
  
  CGSize size = self.frame.size;
  CGRect stateFrame,dateFrame,arrowFrame;
  
  float x,y,margin;
  x = 0;
  margin = (kPROffsetY - 2*kPRLabelHeight)/2;

    y = size.height - margin - kPRLabelHeight;
    dateFrame = CGRectMake(0,y,size.width,kPRLabelHeight);
    
    y = y - kPRLabelHeight;
    stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
    
    
    x = kPRMargin;
    y = size.height - margin - kPRArrowHeight;
    arrowFrame = CGRectMake(4*x, y, kPRArrowWidth, kPRArrowHeight);
    
    UIImage *arrow = [UIImage imageNamed:@"blueArrow"];
    arrowImage.contents = (id)arrow.CGImage;
    
  
  title.frame = stateFrame;
  lastUpdatedLabel.frame = dateFrame;
  _arrowView.frame = arrowFrame;
  activityIndicator.center = _arrowView.center;
  arrowImage.frame = arrowFrame;
  arrowImage.transform = CATransform3DIdentity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
  [title release];
  [activityIndicator release];
  [lastUpdatedLabel release];
  [_arrowView release];
  [super dealloc];
}

@end
