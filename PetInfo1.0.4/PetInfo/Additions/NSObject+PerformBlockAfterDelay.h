//
//  NSObject+PerformBlockAfterDelay.h
//  ganqishi
//
//  Created by 李迪 on 14-6-10.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlockAfterDelay)
- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay;
- (BOOL)cancleAllBlock;
@end
