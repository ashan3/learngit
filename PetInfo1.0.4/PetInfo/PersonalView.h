//
//  PersonalView.h
//  MBA
//
//  Created by 海普科技  on 14-5-20.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZAreaPickerView.h"
@interface PersonalView : BaseViewController<UITextFieldDelegate,HZAreaPickerDelegate>{
    
    
   IBOutlet UITextField *nameField;
   IBOutlet UITextField *emailField;
   IBOutlet UITextField *addressField;
    NSInteger sex;
    
}


@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@property (strong, nonatomic) NSString *areaValue;
-(IBAction)selectSex:(UIButton *)sender;

-(IBAction)sender:(id)sender;


@end
