//
//  HandleServerResponse.m
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/26.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import "HandleServerResponse.h"

///第三方库
#import "HTTPDataResponse.h"
#import "HTTPRedirectResponse.h"

///自定义.h文件
#import "HandleServerPath.h"

@implementation HandleServerResponse

#pragma mark - 处理response
+ (NSObject<HTTPResponse> *)result_httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    if ([method isEqualToString:@"GET"]) {
        if ([HandleServerPath isRedirectRequest:path]) {
            return [self redirectResultForGetRequest_httpResponseForURI:path];
        }
        return [self resultForGetRequest_httpResponseForURI:path];
    }
    if ([method isEqualToString:@"POST"]) {
        return [self resultForPostRequest_httpResponseForURI:path];
    }
    return [[HTTPDataResponse alloc] init];
}


#pragma mark - get请求
+ (NSObject<HTTPResponse> *)resultForGetRequest_httpResponseForURI:(NSString *)path {
    NSMutableDictionary *responseDict = [NSMutableDictionary dictionary];
    [responseDict setValue:@"0" forKey:@"status"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDict options:NSJSONWritingPrettyPrinted error:&error];
    
    return [[HTTPDataResponse alloc] initWithData:jsonData];
}
+ (NSObject<HTTPResponse> *)redirectResultForGetRequest_httpResponseForURI:(NSString *)path {
    NSString *redirectPath = @"https://itunes.apple.com/cn/app/id1090632926?mt=8&at=1l3vntR";
    //不稳定
    return [[HTTPRedirectResponse alloc] initWithPath:redirectPath];
}


#pragma mark - post请求
+ (NSObject<HTTPResponse> *)resultForPostRequest_httpResponseForURI:(NSString *)path {
    return nil;
}
@end
