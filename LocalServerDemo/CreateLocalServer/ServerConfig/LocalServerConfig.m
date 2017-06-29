//
//  LocalServerConfig.m
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/29.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import "LocalServerConfig.h"

@implementation LocalServerConfig


#pragma mark - 本地服务器 添加响应头
+ (NSDictionary *)localServerResponseHeaders {
    return @{
             @"Access-Control-Allow-Origin":@"*",
             @"Content-Type":@"application/json",
             @"USER_AGENT":@"yi.bella"
             };
}

@end
