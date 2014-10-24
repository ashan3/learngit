//
//  AskQuestionView.h
//  MBA
//
//  Created by 海普科技  on 14-6-4.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AskQuestionView : UIViewController<UITextViewDelegate>{
    
    
    IBOutlet UITextView * textView;
    IBOutlet UILabel *label;
    
    NSString * mesg;
}
@property (nonatomic,retain) IBOutlet UITextView *textView;
@property (nonatomic,retain) IBOutlet UILabel *label;
@property (nonatomic,retain) NSString *mesg;
@property (nonatomic,retain) NSString *articleId;
@property (nonatomic,retain) NSString *quePaterId; //quePaterId ！=0 追问
@property (nonatomic,retain) NSString *queID; //queID !=0 回答
-(IBAction)sender:(id)sender;

@end
