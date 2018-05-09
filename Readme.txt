本地音频后台播放：

1、导入音频文件；
- 找到相应音频格式，导入项目中。
- 例子： Dizzy-Ours.mp3

2、配置播放对象；
- 导入 @import AVFoundation;
- AVAudioPlayer *_avAudioPlayer;
-


3、播放对应路径的音频；
- - (void)playAudio;
实现代理AVAudioPlayerDelegate

以上步骤是完成播放。

4、开启后台播放权限；
- a.在Capabilities开启Background Modes选取Audio,AirPlay,and Picture in Picture
- b.在appdelegate的didEnterBackground中添加 
	{
	//允许后台播放音乐
    [application beginBackgroundTaskWithExpirationHandler:nil];
    
    //后台操作
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
	}
- c.- (void)settingBackground;
5、设置控制中心以及锁屏状态下的展示；
- -(void)configNowPlayingInfoCenter;

6、响应远程控制音频中心。
- 在appdelegate中实现- (void)remoteControlReceivedWithEvent:(UIEvent *)event;


本地服务器搭建：

<服务器对象一定要是 单例> 保证对象不会被销毁


1.借助第三方库CocoaHttpServer;

2.建立一个本地服务器存储路径，蓝色文件夹(真实路径);

3.配置服务器；
- (void)configLocalServer;

4.开启服务器；
- (void)startServer；

5.响应请求，继承自HTTPConnection；
实现 - (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path；

6.设置额外响应头；
在遵循HTTPResponse协议的 响应反馈类中，实现- (NSDictionary *)httpHeaders；添加响应头字典即可。

7.关于获取请求方的信息在HTTPMessage类中。
比如可以获取信息，作域名拦截器。

