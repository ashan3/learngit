//
//  NoticeDetailView.h
//  MBA
//
//  Created by 海普科技  on 14-6-4.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NoticeDetailView : BaseViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *_webView;
    
}
@property (nonatomic,strong)NSString *noticeId;


@end
