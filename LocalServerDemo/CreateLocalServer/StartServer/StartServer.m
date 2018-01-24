//
//  StartServer.m
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/26.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

///本地服务器保存地址,这个一定得是真实目录，蓝色文件夹。
#define LOCAL_SERVER_PATH [[NSBundle mainBundle] pathForResource:@"LocalServer" ofType:nil]
///服务器端口
#define LOCAL_SERVER_PORT 24476

#import "StartServer.h"

///导入第三方库
#import "HTTPServer.h"

///自定义.h文件
#import "Config.h"
#import "ServerConnection.h"

@interface StartServer ()
{
    HTTPServer *_httpServer;
}
@end

@implementation StartServer

+ (instancetype)sharedStartServer {
    static StartServer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [StartServer new];
        
        [instance configLocalServer];
    });
    return instance;
}

#pragma mark - 配置服务器
- (void)configLocalServer {
    _httpServer = [HTTPServer new];
    [_httpServer setType:@"_http.tcp"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //检验本地服务器地址是否存在
    if (![fileManager fileExistsAtPath:LOCAL_SERVER_PATH]) {
        NSLog(@"服务器地址不存在");
    }else {
        [_httpServer setDocumentRoot:LOCAL_SERVER_PATH];
        [_httpServer setPort:LOCAL_SERVER_PORT];
        
        [_httpServer setConnectionClass:[ServerConnection class]];
    }
}

#pragma mark - 开启服务器
- (void)startServer {
    NSError *error = nil;
    if ([_httpServer start:&error]) {
        NSLog(@"开启服务器");
    }else {
        NSLog(@"服务器开启失败");
    }
}


@end
