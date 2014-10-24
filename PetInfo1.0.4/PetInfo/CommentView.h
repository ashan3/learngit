//
//  CommentView.h
//  MBA
//
//  Created by 海普科技  on 14-5-28.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CommentView : BaseViewController <UITextViewDelegate>{
    IBOutlet UITextView * _textView;
    IBOutlet UILabel *_label;
}
@property (nonatomic,retain) NSString *articleId;

-(IBAction)sender:(id)sender;

@end
