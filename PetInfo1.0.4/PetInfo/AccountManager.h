//
//  AccountManager.h
//  hylink
//
//  Created by 李迪 on 14-9-17.
//  Copyright (c) 2014年 lidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

+ (instancetype)manager;

@property(nonatomic,strong)NSString *uname;
@property(nonatomic,strong)NSString *passwd;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *orgid;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,assign)BOOL      isLoginSuccess;

@end
