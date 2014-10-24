//
//  Additions.h
//  hylink
//
//  Created by 李迪 on 14-9-7.
//  Copyright (c) 2014年 lidi. All rights reserved.
//

#ifndef hylink_Additions_h
#define hylink_Additions_h

#pragma mark Color
#define OrangeColor [UIColor colorWithRed:255.0f / 255.0f green:125.0f / 255.0f blue:19.0f / 255.0f alpha:1.0f]
#define GreenColor  [UIColor colorWithRed:87.0f / 255.0f green:169.0f / 255.0f blue:0 / 255.0f alpha:1.0f];

#pragma mark enum
typedef enum
{
    WorkType_Working=0,
    WorkType_Worked
}WorkType;

#import "hylinkURLs.h"
#import "AFNetWorking.h"
#import "SVProgressHUD.h"

#import "NSObject+PerformBlockAfterDelay.h"
#import "UIButton+Block.h"
#import "UIViewController+WhiteTitle.h"
#import "UIImage+UIColor.h"
#import "UIAlertView+ShowNotice.h"
#import "UIImageView+WebCache.h"


#import "MJRefresh.h"

#endif
