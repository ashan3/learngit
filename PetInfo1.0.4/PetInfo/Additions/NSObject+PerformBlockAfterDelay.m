//
//  NSObject+PerformBlockAfterDelay.m
//  ganqishi
//
//  Created by 李迪 on 14-6-10.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "NSObject+PerformBlockAfterDelay.h"

@implementation NSObject (PerformBlockAfterDelay)
- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}
- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}
- (BOOL)cancleAllBlock
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    return YES;
}

@end
