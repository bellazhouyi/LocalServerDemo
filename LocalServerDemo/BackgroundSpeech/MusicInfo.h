//
//  MusicInfo.h
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/30.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 歌曲信息
 */
@interface MusicInfo : UIView

@property(nonatomic, copy) NSString *name; //歌名
@property(nonatomic, copy) NSString *singer; //演唱者
@property(nonatomic, copy) NSString *album; //歌曲相册
@property(nonatomic, copy) NSString *image; //歌曲封面


/*
 * 所有的歌曲信息
 */
+ (NSArray<MusicInfo *> *)allSongsInfo;

@end
