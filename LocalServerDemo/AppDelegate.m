//
//  AppDelegate.m
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/26.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import "AppDelegate.h"

@import AVFoundation;

///自定义文件
#import "BackgroundSpeech.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self settingBackground];
    //允许后台播放音乐
    [application beginBackgroundTaskWithExpirationHandler:nil];
    
    //后台操作
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //同时，需要实现- (BOOL)canBecomeFirstResponder方法。
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    //    [self resignFirstResponder];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/**
 *  响应远程音乐播放控制消息
 *
 */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
                
            case UIEventSubtypeRemoteControlPause:
                //点击了暂停
                [[BackgroundSpeech sharedBackgroundSpeech] pause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                //点击了下一首
                [[BackgroundSpeech sharedBackgroundSpeech] nextSong];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                //点击了上一首
                [[BackgroundSpeech sharedBackgroundSpeech] previousSong];
                //此时需要更改歌曲信息
                break;
            case UIEventSubtypeRemoteControlPlay:
                //点击了播放
                [[BackgroundSpeech sharedBackgroundSpeech] continuePlay];
                break;
            default:
                break;
        }
    }
}

#pragma mark - 后台播放设置
- (void)settingBackground {
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}
@end
