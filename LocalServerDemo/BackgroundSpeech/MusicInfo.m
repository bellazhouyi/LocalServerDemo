//
//  MusicInfo.m
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/30.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import "MusicInfo.h"

@implementation MusicInfo

+ (NSArray<MusicInfo *> *)allSongsInfo {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SongsInfo" ofType:@"json"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    for (NSDictionary *item in jsonArray) {
        MusicInfo *obj = [MusicInfo new];
        [obj setValuesForKeysWithDictionary:item];
        [array addObject:obj];
    }
    
    return array;
}




@end
