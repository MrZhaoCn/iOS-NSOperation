//
//  ZCNetWorkingTool.h
//  随手记
//
//  Created by MrZhao on 16/8/22.
//  Copyright © 2016年 MrZhao. All rights reserved.
//
/*网络请求工具类，封装成单例**/
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void (^sucess)(id reponseBody);
typedef void (^failure)(NSError *error);


@interface ZCNetWorkingTool : NSObject
//单列方法
+(instancetype)shareNetWorking;

//封装一个GET请求
- (void)GETWithURL:(NSString *)url parameters:(id)parameters sucess:(sucess)sucess failure:(failure)failure;
@end
