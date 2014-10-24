//
// DemoTableHeaderView.h
//
// @author Shiki
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DemoTableHeaderView : UIView {
    
  UILabel *title;
  UIActivityIndicatorView *activityIndicator;
  	CALayer *arrowImage;
  	UILabel *lastUpdatedLabel;
    UIImageView *_arrowView;
}
@property (nonatomic, retain)  CALayer *arrowImage;
@property (nonatomic, retain)  UILabel *title;
@property (nonatomic, retain)  UILabel *lastUpdatedLabel;
@property (nonatomic, retain)  UIActivityIndicatorView *activityIndicator;

@end
