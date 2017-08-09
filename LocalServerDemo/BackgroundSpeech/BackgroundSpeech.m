//
//  BackgroundSpeech.m
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/27.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import "BackgroundSpeech.h"

///系统库
@import AVFoundation;
@import UIKit;
@import MediaPlayer;

///自定义.h文件
#import "MusicInfo.h"

@interface BackgroundSpeech ()<AVAudioPlayerDelegate>
{
    //音乐播放器
    AVAudioPlayer *_avAudioPlayer; // 播放器palyer
    
    NSTimer *_timer; //计时器
    
    //当前歌曲的索引值
    NSInteger currentIndexOfSong;
}

@end

@implementation BackgroundSpeech

+ (instancetype)sharedBackgroundSpeech {
    static BackgroundSpeech *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BackgroundSpeech new];
        
        //默认索引值
        instance->currentIndexOfSong = 0;
    });
    return instance;
}

#pragma mark - 播放本地音频文件
- (void)playAudio {
    MusicInfo *currentMusicInfo = [self currentSongsInfo];
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:currentMusicInfo.name ofType:@"mp3"];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    NSError *playerError;
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:&playerError];
    if (_avAudioPlayer == NULL)
    {
        NSLog(@"fail to play audio :(");
        return;
    }
    
    [_avAudioPlayer setNumberOfLoops:-1];
    [_avAudioPlayer setVolume:0.1];
    [_avAudioPlayer prepareToPlay];
    [_avAudioPlayer play];
    _avAudioPlayer.delegate = self;
    
    [self configNowPlayingInfoCenter];
}
- (void)pause {
    [_avAudioPlayer pause];
}
- (void)continuePlay {
    [_avAudioPlayer play];
}
- (void)stop {
    [_avAudioPlayer stop];
}
- (void)nextSong {
    currentIndexOfSong++;
    if (currentIndexOfSong == [MusicInfo allSongsInfo].count) {
        currentIndexOfSong = 0;
    }
    [self playAudio];
}
- (void)previousSong {
    currentIndexOfSong--;
    if (currentIndexOfSong == -1) {
        currentIndexOfSong = [MusicInfo allSongsInfo].count - 1;
    }
    [self playAudio];
}


#pragma mark - 设置锁屏状态，显示的歌曲信息
// @import MediaPlayer;
-(void)configNowPlayingInfoCenter {
    MusicInfo *currentMusicInfo = [self currentSongsInfo];
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        @autoreleasepool {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            //歌曲名称
            [dict setObject:currentMusicInfo.name forKey:MPMediaItemPropertyTitle];
            
            //演唱者
            [dict setObject:currentMusicInfo.singer forKey:MPMediaItemPropertyArtist];
            
            //专辑名
            [dict setObject:currentMusicInfo.album forKey:MPMediaItemPropertyAlbumTitle];
            
            //专辑缩略图
            UIImage *image = [UIImage imageNamed:currentMusicInfo.image];
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(80, 80) requestHandler:^UIImage * _Nonnull(CGSize size) {
                return image;
            }];
            [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
            
            //音乐剩余时长
            [dict setObject:[NSNumber numberWithDouble:_avAudioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
            
            //音乐当前播放时间 在计时器中修改
            [dict setObject:[NSNumber numberWithDouble:0.0] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
            
            //设置锁屏状态下屏幕显示播放音乐信息
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeProgress:) userInfo:@{} repeats:YES];
        }
    }
}
//计时器修改进度
- (void)changeProgress:(NSTimer *)sender{
    if(_avAudioPlayer){
        //当前播放时间
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
        [dict setObject:[NSNumber numberWithDouble:_avAudioPlayer.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经过时间
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
}
#pragma mark - AVAudioPlayerDelegate
// 当播放完成时执行的代理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying");
}
// 当播放发生错误时调用
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"播放发生错误%@",error);
}
// 当播放器发生中断时调用 如来电
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"audioPlayerBeginInterruption");
    // 暂停播放 用户不暂停，系统也会帮你暂停。但是如果你暂停了，等来电结束，需要再开启
    [_avAudioPlayer pause];
}
// 当中断停止时调用 如来电结束
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    NSLog(@"audioPlayerEndInterruption");
    // 你可以帮用户开启 也可以什么都不执行，让用户自己决定
    [_avAudioPlayer play];
}

#pragma mark - 获取当前音乐
- (MusicInfo *)currentSongsInfo {
    return [[MusicInfo allSongsInfo] objectAtIndex:currentIndexOfSong];
}

#pragma mark - dealloc
- (void)dealloc {
    _timer = nil;
}

@end
