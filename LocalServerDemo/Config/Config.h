//
//  Config.h
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/26.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#ifndef DEBUG

#define YLog(fmt, ...)  NSLog((@" %s,%s,%d \n" fmt), fmt, __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);

#else

#define YLog( ...)

#endif


#import <Foundation/Foundation.h>

@interface Config : NSObject

@end
