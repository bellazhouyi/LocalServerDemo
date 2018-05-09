//
//  LocalSocketServer.m
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2018/1/24.
//  Copyright © 2018年 Yi Zhou. All rights reserved.
//

#define SOCKET_PORT 1122

#import "LocalSocketServer.h"

@implementation LocalSocketServer

+ (instancetype)sharedServer {
    static LocalSocketServer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LocalSocketServer alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _clientSocket = [NSMutableArray array];
        //创建全局queue
        _golbalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //创建服务端的socket，注意这里的是初始化的同时已经指定了delegate
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_golbalQueue];
    }
    return self;
}

- (void)startServer {
    //打开监听端口
    NSError *err;
    //HTTP/0.9 只能用80端口
    [_serverSocket acceptOnPort:SOCKET_PORT error:&err];
    
    if (!err) {
        NSLog(@"服务开启成功");
        
    }else{
        NSLog(@"服务开启失败 %@",err);
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"%@",err);
    NSLog(@"链接断开 %@",err.userInfo);
    [self.clientSocket removeObject:sock];
}

#pragma mark 有客户端建立连接的时候调用
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    //sock为服务端的socket，服务端的socket只负责客户端的连接，不负责数据的读取。   newSocket为客户端的socket
    NSLog(@"有新链接 - 服务端的socket %p 客户端的socket %p",sock,newSocket);
    //保存客户端的socket，如果不保存，服务器会自动断开与客户端的连接（客户端那边会报断开连接的log）
    [self.clientSocket addObject:newSocket];
    
    //newSocket为客户端的Socket。这里读取数据
    [newSocket readDataWithTimeout:-1 tag:100];
}

#pragma mark 服务器写数据给客户端
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
    NSLog(@"服务器发送的tag: %ld",tag);
    [sock readDataWithTimeout:-1 tag:100];
}
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    NSLog(@"*** %lu ***",(unsigned long)partialLength);
}
#pragma mark 接收客户端传递过来的数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //sock为客户端的socket
    NSLog(@" 收到客户端的数据 - 客户端的socket %p",sock);
    
    //接收到数据
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    receiverStr = [receiverStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    receiverStr = [receiverStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSArray *receiveStrArray = [receiverStr componentsSeparatedByString:@" "];
    
    //请求地址指令
    NSString *commandUrl = [receiveStrArray objectAtIndex:1];
    
    //请求参数
    NSDictionary *paramsDict = [self params:commandUrl];
    
    //链接指令
    if ([commandUrl hasPrefix:@"/heartbeat"]) {
        [sock writeData:[self responseHeaderWithContent:@"{'status':'heartbeat'}"] withTimeout:-1 tag:0];
        [sock disconnectAfterWriting];
    }
    
    //转发指令
    if ([commandUrl hasPrefix:@"/forward"]) {
        id responseResult;
        if (paramsDict.allKeys == 0) {
            responseResult = @"{'status':'false','msg':'url未带任何参数'}";
        }else {
            responseResult = @"{'status':'false','msg':'url带参数访问后台服务器'}";
        }
        
        [sock writeData:[self responseHeaderWithContent:[NSString stringWithFormat:@"%@",responseResult]] withTimeout:-1 tag:0];
        [sock disconnectAfterWriting];
    }
    
    //获取用户信息
    if ([commandUrl hasPrefix:@"/user_info"]) {
        
        NSString *result = @"{'uid':'4','idfa':'eedrrrr','is_break':'1','version':'1.0','is_breakout':'YES'}";
        [sock writeData:[self responseHeaderWithContent:[NSString stringWithFormat:@"%@",result]] withTimeout:-1 tag:0];
        [sock disconnectAfterWriting];
    }
    
    
    //打开应用
    if ([commandUrl hasPrefix:@"/openApp"]) {
        NSString *result = @"{'openApp':'YES'}";
        [sock writeData:[self responseHeaderWithContent:[NSString stringWithFormat:@"%@",result]] withTimeout:-1 tag:0];
        [sock disconnectAfterWriting];
    }
}

//MARK:客户端请求地址 所带参数
- (NSDictionary *)params:(NSString *)url {
    NSArray *firstComponentsArr = [url componentsSeparatedByString:@"?"];
    if (firstComponentsArr.count < 2) {
        return nil;
    }
    NSArray *paramsStrArr = [[firstComponentsArr lastObject] componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *str in paramsStrArr) {
        NSArray *dictArr = [str componentsSeparatedByString:@"="];
        NSString *key = [dictArr firstObject];
        NSString *value = [dictArr lastObject];
        [dict setValue:value forKey:key];
    }
    return dict;
}

//MARK:http协议的响应头+响应内容
- (NSData *)responseHeaderWithContent:(NSString *)content {
    //获取Response Header
    NSMutableString *header = [[NSMutableString alloc]init];
    NSMutableData *returnData = [[NSMutableData alloc]init];
    
    NSData *fileContent = [content dataUsingEncoding:NSUTF8StringEncoding];
    int contentLength = (int)[fileContent length];
    
    [header appendString:@"HTTP/1.0 200 OK\r\n"];
    [header appendString:@"Connection: Upgrade\r\n"];
    [header appendString:@"Upgrade: websocket\r\n"];
    [header appendString:@"Server: Apache/1.3.0(Unix)\r\n"];
    [header appendString:@"Access-Control-Allow-Origin: *\r\n"];
    NSString *contentLengthString = [NSString stringWithFormat:@"Content-Length:%d\r\n",contentLength];
    [header appendString:contentLengthString];
    
    NSString *mimeString = @"Content-Type: application/json\r\n";
    [header appendString:mimeString];
    [header appendString:@"\r\n"];
    NSData *headerData = [header dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"response header = %@",header);
    [returnData appendData:headerData];
    [returnData appendData:fileContent];
    //    NSLog(@"return data = %@",returnData);
    return (NSData *)returnData;
}
@end
