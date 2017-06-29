//
//  HandleServerPath.m
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/29.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import "HandleServerPath.h"

@implementation HandleServerPath

#pragma mark - 是否 重定向请求
+ (BOOL)isRedirectRequest:(NSString *)path {
    if ([path containsString:@"forward"]) {
        return YES;
    }
    return NO;
}

@end
