//
//  ZCNetWorkingTool.m
//  随手记
//
//  Created by MrZhao on 16/8/22.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ZCNetWorkingTool.h"
static ZCNetWorkingTool *_instance;
@implementation ZCNetWorkingTool
#pragma 单列相关方法
+ (instancetype)shareNetWorking {
    
    if (_instance == nil) {
        return [[self alloc] init];
    }
    return _instance;
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    if (_instance == nil) {
        static dispatch_once_t  once;
        dispatch_once(&once, ^{
            
            _instance =  [super allocWithZone:zone];
            
        });
        
    }
    return _instance;
}

- (instancetype)init {
    
    if (_instance == nil) {
        
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            _instance = [super init];
        });
    }
    return _instance;
}
- (instancetype)copy {
    
    return  _instance;
    
}

#pragma GET请求
- (void)GETWithURL:(NSString *)url parameters:(id)parameters sucess:(sucess)sucess failure:(failure)failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval = 5.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
}

@end
