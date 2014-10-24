//
//  CreatingInitControlStyle.h
//  ThankYou
//
//  Created by cuiwen on 13-10-22.
//  Copyright (c) 2013年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KInitButtonStyle(x1,x2,x3,x4) [InitControlStyle initButtonStyle:x1 setTitle:x2 normal:x3 highlighted:x4]

#define KButtonStyle(x1,x2,x3) [InitControlStyle initButtonStyle:x1 normal:x2 highlighted:x3]

#define KForegroundColor(x1,x2,x3,x4) [InitControlStyle foregroundColor:x1 title:x2 start:x3 end:x4];

@interface InitControlStyle : NSObject

+ (UIButton *)initButtonStyle:(CGRect)rect setTitle:title normal:image1 highlighted:image2;

/* 设置button 自定义图片 */
+ (UIButton *)initButtonStyle:(UIButton *)button normal:image1 highlighted:image2;

/* 编辑前景色 */
+ (void)foregroundColor:(UILabel *)lable title:(NSString*)string start:(int)a end:(int)b;
@end
