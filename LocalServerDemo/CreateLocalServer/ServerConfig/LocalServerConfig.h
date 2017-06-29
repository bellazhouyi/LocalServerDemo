//
//  LocalServerConfig.h
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/29.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 本地服务器相关设置
 */
@interface LocalServerConfig : NSObject


/*
 * 本地服务器 
 * 响应头
 */
+ (NSDictionary *)localServerResponseHeaders;

@end
