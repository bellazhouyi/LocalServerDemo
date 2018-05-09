//
//  LocalSocketServer.h
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2018/1/24.
//  Copyright © 2018年 Yi Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

/**
 socket 服务器
 */
@interface LocalSocketServer : NSObject<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *_serverSocket;
    dispatch_queue_t _golbalQueue;
}

//客户端socket数组
@property (strong,nonatomic) NSMutableArray *clientSocket;

+ (instancetype)sharedServer;
/**
 *  开启socket服务器
 */
-(void)startServer;

@end
