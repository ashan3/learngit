//
//  AccountManager.m
//  hylink
//
//  Created by 李迪 on 14-9-17.
//  Copyright (c) 2014年 lidi. All rights reserved.
//

#import "AccountManager.h"

#define Account_UserDefaults    [NSUserDefaults standardUserDefaults]

#define Account_uname           @"uname"
#define Account_passwd          @"passwd"
#define Account_uid             @"uid"
#define Account_orgid           @"orgid"
#define Account_token           @"token"
#define Account_isLoginSuccess  @"isLoginSuccess"

@implementation AccountManager

+ (instancetype)manager
{
    static AccountManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (NSString *)uname
{
    return [Account_UserDefaults objectForKey:Account_uname];
}

- (NSString *)passwd
{
    return [Account_UserDefaults objectForKey:Account_passwd];
}

- (NSString *)uid
{
    return [Account_UserDefaults objectForKey:Account_uid];
}

- (NSString *)orgid
{
    return [Account_UserDefaults objectForKey:Account_orgid];
}

- (NSString *)token
{
    return [Account_UserDefaults objectForKey:Account_token];
}

- (BOOL)isLoginSuccess
{
    NSNumber *login = [Account_UserDefaults objectForKey:Account_isLoginSuccess];
    
    if (!login || !login.intValue) {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)setUname:(NSString *)uname
{
    [Account_UserDefaults setObject:uname forKey:Account_uname];
}

- (void)setPasswd:(NSString *)passwd
{
    [Account_UserDefaults setObject:passwd forKey:Account_passwd];
}

- (void)setUid:(NSString *)uid
{
    [Account_UserDefaults setObject:uid forKey:Account_uid];
}

- (void)setOrgid:(NSString *)orgid
{
    [Account_UserDefaults setObject:orgid forKey:Account_orgid];
}

- (void)setToken:(NSString *)token
{
    [Account_UserDefaults setObject:token forKey:Account_token];
}

- (void)setIsLoginSuccess:(BOOL)isLoginSuccess
{
    if (isLoginSuccess) {
        [Account_UserDefaults setObject:@1 forKey:Account_isLoginSuccess];
    }
    else
    {
        [Account_UserDefaults setObject:@0 forKey:Account_isLoginSuccess];
    }
    
}
@end
