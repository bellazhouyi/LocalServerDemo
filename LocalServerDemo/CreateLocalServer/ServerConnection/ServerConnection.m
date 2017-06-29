//
//  ServerConnection.m
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/26.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import "ServerConnection.h"

///自定义.h文件
#import "HandleServerResponse.h"

@implementation ServerConnection


- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path {
    if ([method isEqualToString:@"POST"]) {
        return YES;
    }
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    return [HandleServerResponse result_httpResponseForMethod:method URI:path];
}



@end
