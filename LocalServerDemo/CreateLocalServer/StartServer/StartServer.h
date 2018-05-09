//
//  StartServer.h
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/26.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * HTTP服务器
 */
@interface StartServer : NSObject

+ (instancetype)sharedStartServer;

/*
 * 开启服务器
 */
- (void)startServer;

@end
