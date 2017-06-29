//
//  ViewController.m
//  LocalServerDemo
//
//  Created by 航汇聚科技 on 2017/6/26.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

#import "ViewController.h"

///自定义文件
#import "StartServer.h"
#import "BackgroundSpeech.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[StartServer sharedStartServer] startServer];
    
    [[BackgroundSpeech sharedBackgroundSpeech] playAudio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
