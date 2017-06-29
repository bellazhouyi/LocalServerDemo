//
//  HandleServerResponse.h
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/26.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

///三方库
#import "HTTPResponse.h"
/*
 * 处理服务器response
 */
@interface HandleServerResponse : NSObject


+ (NSObject<HTTPResponse> *)result_httpResponseForMethod:(NSString *)method URI:(NSString *)path;

@end
