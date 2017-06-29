//
//  BackgroundSpeech.h
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/27.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 音频播放
 */
@interface BackgroundSpeech : NSObject


+ (instancetype)sharedBackgroundSpeech;

- (void)playAudio;

- (void)pause;
- (void)continuePlay;
- (void)stop;

@end
