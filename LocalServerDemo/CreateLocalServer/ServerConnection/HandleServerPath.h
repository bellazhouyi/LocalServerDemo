//
//  HandleServerPath.h
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/29.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 处理服务器地址&头
 */
@interface HandleServerPath : NSObject

/*
 * 是否是请求 重定向
 */
+ (BOOL)isRedirectRequest:(NSString *)path;

@end
