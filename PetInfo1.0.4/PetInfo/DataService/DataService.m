//
//  DataService.m
//  testLanucher
//
//  Created by 佐筱猪 on 13-11-18.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "DataService.h"
#import "ASIDownloadCache.h"
#import "Reachability.h"
#import "FileUrl.h"
#import "NSString+URLEncoding.h"
@implementation DataService

+(ASIHTTPRequest *)nocacheWithURL:(NSString *)urlstring andparams:(NSMutableDictionary *)params  completeBlock:(RequestFinishBlock) block andErrorBlock:(RequestErrorBlock) errorBlock{
    return [self requestWithURL:urlstring andparams:params andhttpMethod:@"GET" andCache:ASIOnlyLoadIfNotCachedCachePolicy  completeBlock:block andErrorBlock:errorBlock];
}

+(ASIHTTPRequest *)requestWithURL:(NSString *)urlstring andparams:(NSMutableDictionary *)params andhttpMethod:(NSString *) httpMethod andCache :(ASICachePolicy)ASIcache  completeBlock:(RequestFinishBlock)block andErrorBlock:(RequestErrorBlock)errorBlock{
    //拼接url地址
    urlstring = [BASE_URL stringByAppendingString:urlstring];
    NSComparisonResult compGET =[httpMethod caseInsensitiveCompare:@"GET"];//忽略大小写比较。返回值是枚举类型的升序、降序、相同
    //处理post请求的参数
    if (compGET==NSOrderedSame) {//相同
        //用于做拼接字符串
        NSMutableString *paramsString =[NSMutableString string];
        NSArray *allKey=[params allKeys];
        for (int i=0; i<params.count; i++) {
            NSString *key=[allKey objectAtIndex:i];
            id value=[params objectForKey:key];
            if ([value isKindOfClass:[NSString class]]) {
                NSString *str = (NSString *)value;
                value = str.URLEncodedString;
            }
            [paramsString appendFormat:@"%@=%@",key,value];
            if (i<params.count-1) {
                [paramsString appendString:@"&"];
            }
        }
        //判断它是不是大于0 大于0就可以拼接
        if (paramsString.length > 0) {
            urlstring = [urlstring stringByAppendingFormat:@"?%@",paramsString];
        }
    }
    //设置请求url地址
    NSLog(@"%@",urlstring);
    NSURL *url=[NSURL URLWithString:urlstring];//ashan

    //设置请求完成的block
    /*    [request setCompletionBlock: 会retain block
     NSData *data = request.responseData;  block  retain   request.
     这样导致循环retain。
     */
    __block ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    //设置超时时间
    [request setTimeOutSeconds:30];
    //设置请求方法
    [request setRequestMethod:httpMethod];
    NSComparisonResult compPost =[httpMethod caseInsensitiveCompare:@"POST"];//忽略大小写比较。返回值是枚举类型的升序、降序、相同
    //处理post请求的参数
    //处理POST请求方式
    //如果httpMethod = post 写的时候要忽略大小写
    //返回的是枚举
    if (compPost==NSOrderedSame) {//相同
        NSArray *allKey=[params allKeys];
        for (int i=0; i<params.count; i++) {
            NSString *key=[allKey objectAtIndex:i];
            
            id value=[params objectForKey:key];
            //判断是否是文件上传
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value withFileName:@"test.png" andContentType:@"image/png" forKey:@"image"];
            }else{
                [request addPostValue:value forKey:key];
            }
        }
    }
//    get方法时 可以采取缓存策略
    if (compGET==NSOrderedSame){
        //    设置缓存--
        ASIDownloadCache *cache = [[ASIDownloadCache alloc]init];//创建缓存对象
        NSString *cachePath = [FileUrl getCacheFileURL]; //设置缓存目录
        DLOG(@"cachepath:%@",cachePath);
        [cache setStoragePath:cachePath];
        
//        判断当前网络情况
        BOOL isExistenceNetwork = YES;
        Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        switch ([reach currentReachabilityStatus]) {
            case NotReachable:
                isExistenceNetwork = NO;
                //NSLog(@"notReachable");
                break;
            case ReachableViaWiFi:
                isExistenceNetwork = YES;
                //NSLog(@"WIFI");
                break;
            case ReachableViaWWAN:
                isExistenceNetwork = YES;
                //NSLog(@"3G");
                break;
        }
        
        if ( isExistenceNetwork) {
            
            cache.defaultCachePolicy = ASIcache;
//            ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy; //设置缓存策略
            
        }else{
            cache.defaultCachePolicy =ASIOnlyLoadIfNotCachedCachePolicy; //设置缓存策略
            
        }

        
        //每次请求会将上一次的请求缓存文件清除,默认策略，基于session的缓存数据存储。当下次运行或[ASIHTTPRequest clearSession]时，缓存将失效。
        //    request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
        //持久缓存，一直保存在本地(是持久缓存，程序下次启动，缓存仍然还在)
        request.cacheStoragePolicy =ASICachePermanentlyCacheStoragePolicy;
        request.downloadCache = cache;

    }
    _po(url);
    [request setCompletionBlock:^{
        NSData *data = request.responseData;
        float version = WXHLOSVersion();
        id result = nil ;
        if (version>=5.0) {
            result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }else {//版本定位5.0以上.
            //            result=[data obj]
        }
        if (block !=nil) {
            block(result);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if(errorBlock !=nil){
            errorBlock(error);
        }
    }];
    [request startAsynchronous];
    return  request;
}
//发送异步请求
+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring andparams:(NSMutableDictionary *)params andhttpMethod: (NSString *)httpMethod completeBlock:(RequestFinishBlock) block andErrorBlock:(RequestErrorBlock) errorBlock{
    return [self requestWithURL:urlstring andparams:params andhttpMethod:httpMethod andCache:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy completeBlock:block andErrorBlock:errorBlock];
}



- (ASIHTTPRequest *) requestWithURL:(NSString *)urlstring andparams:(NSMutableDictionary *)params
                            isJoint:(BOOL)isJoint    andhttpMethod: (NSString *)httpMethod {
    if (isJoint) {
        //拼接url地址
        urlstring = [BASE_URL stringByAppendingString:urlstring];
    }
    
    
    
    NSComparisonResult compGET =[httpMethod caseInsensitiveCompare:@"GET"];//忽略大小写比较。返回值是枚举类型的升序、降序、相同
    //处理post请求的参数
    if (compGET==NSOrderedSame) {//相同
        //用于做拼接字符串
        NSMutableString *paramsString =[NSMutableString string];
        NSArray *allKey=[params allKeys];
        for (int i=0; i<params.count; i++) {
            NSString *key=[allKey objectAtIndex:i];
            id value=[params objectForKey:key];
            if ([value isKindOfClass:[NSString class]]) {
                NSString *str = (NSString *)value;
                value = str.URLEncodedString;
            }
            [paramsString appendFormat:@"%@=%@",key,value];
            if (i<params.count-1) {
                [paramsString appendString:@"&"];
            }
        }
        //判断它是不是大于0 大于0就可以拼接
        if (paramsString.length > 0) {
            urlstring = [urlstring stringByAppendingFormat:@"?%@",paramsString];
        }
    }
    
    //设置请求url地址
    NSURL *url=[NSURL URLWithString:urlstring];

    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    //设置超时时间
    [request setTimeOutSeconds:20];
    //设置请求方法
    [request setRequestMethod:httpMethod];
    NSComparisonResult compPost =[httpMethod caseInsensitiveCompare:@"POST"];//忽略大小写比较。返回值是枚举类型的升序、降序、相同
    //处理post请求的参数
    //处理POST请求方式
    //如果httpMethod = post 写的时候要忽略大小写
    //返回的是枚举
    if (compPost==NSOrderedSame) {//相同
        NSArray *allKey=[params allKeys];
        for (int i=0; i<params.count; i++) {
            NSString *key=[allKey objectAtIndex:i];
            
            id value=[params objectForKey:key];
            //判断是否是文件上传
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value withFileName:@"test.png" andContentType:@"image/png" forKey:@"image"];
            }else{
                [request addPostValue:value forKey:key];
            }
        }
    }
  
    //    设置缓存--
    ASIDownloadCache *cache = [[ASIDownloadCache alloc]init];//创建缓存对象
    NSString *cachePath = [FileUrl getCacheFileURL]; //设置缓存目录，这里设置沙盒目录下的Documents目录作为缓存目录
    NSLog(@"cachepath:%@",cachePath);
    [cache setStoragePath:cachePath];
    cache.defaultCachePolicy =ASIAskServerIfModifiedCachePolicy; //设置缓存策略
    
    //每次请求会将上一次的请求缓存文件清除
    //    request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
    //持久缓存，一直保存在本地(是持久缓存，程序下次启动，缓存仍然还在)
    request.cacheStoragePolicy =ASICachePermanentlyCacheStoragePolicy;
    request.downloadCache = cache;
    _po(url);
    [request setDelegate:self];
    [request startAsynchronous];
    return request;
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSData *data = request.responseData;
    id result = nil ;
    result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if(_eventDelegate)
    [self.eventDelegate requestFinished:result];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    if(_eventDelegate)
    [self.eventDelegate requestFailed:request];
}


@end
