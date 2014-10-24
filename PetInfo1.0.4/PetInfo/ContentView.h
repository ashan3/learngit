//
//  ContentView.h
//  MBA
//
//  Created by 海普科技  on 14-5-22.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MBProgressHUD.h"
@interface ContentView : BaseViewController <ASIRequest,UIWebViewDelegate,UITextViewDelegate> {
    
    IBOutlet UIWebView *_webView;
    
    IBOutlet UILabel *titleLael;
    IBOutlet UILabel *timeLabel;
    
    NSString * speechStr;
}
@property (readwrite,strong) NSString *articleId;
-(IBAction)back:(id)sender;
-(IBAction)comment:(id)sender;
-(IBAction)collection:(id)sender;
-(IBAction)goInstall:(id)sender;
@end
