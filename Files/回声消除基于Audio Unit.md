> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [www.jianshu.com](https://www.jianshu.com/p/a53ab35b81cc#comments)

#### 2018.07.26 更新

Audio Unit 应用实例：**[XBVoiceTool](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fhuisedediao%2FXBVoiceTool)**

写了一个 Audio Unit 运用的例子，包括录音、播放 PCM、播放 MP3|AAC、音频数据相加进行混音、用 MixUnit 混音、根据传入的文件获取混音后的文件（搬运）、AAC 编码、MP3 编码  

#### 2018.03.28 更新

----- 好多同学私信不会用，GitHub 项目添加了 demo，具体使用参考 demo  
----- 添加了 pcm 转 WAV 的方法（我只是搬运工）  

原文
==

**_本文 Demo：_** **[XBEchoCancellation](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fhuisedediao%2FXBEchoCancellation)**

先说下为什么会有回声。

由于手机 app（A 端）需要一边录音一边播放声音。A 端 在通过麦克风采集输入声音的时候，把手机正在播放的声音（由 B 端 传输过来）也采集进去了，并将采集到的声音传到 B 端 播放，因此在 B 端 听起来除了有 A 端 原本想要传的声音，还有 B 端 之前传出去的声音（也就是回声）。

我们要将采集到的声音数据中的属于手机播放的那部分声音去除，基于 Audio Unit 封装了一个工具类，支持回声消除和对 pcm 数据进行播放。

### 使用：

#### 获取麦克风输入：

```
XBEchoCancellation *echo = [XBEchoCancellation shared];
echo.bl_input = ^(AudioBufferList *bufferList) {
    AudioBuffer buffer = bufferList->mBuffers[0];
    // buffer即从麦克风获取到的数据，默认已经消除了回音
};
[echo startInput];


```

#### 播放 pcm 音频数据：

```
XBEchoCancellation *echo = [XBEchoCancellation shared];
echo.bl_output = ^(AudioBufferList *bufferList, UInt32 inNumberFrames) {
    AudioBuffer buffer = bufferList->mBuffers[0];
    // 这里把要传给发声设备的pcm数据赋给buffer
};
[echo startOutput];


```

种草一波
----

### IOS FFmpeg 从零开始编写属于自己的媒体播放器:

[IOS FFmpeg 零到自己的播放器 1，解码](https://www.jianshu.com/p/31a45aa43380)  
[IOS FFmpeg 零到自己的播放器 2，OpenGL 显示图片](https://www.jianshu.com/p/7aecdc83d9e5)  
[IOS FFmpeg 零到自己的播放器 3，Audio Unit 播放 PCM 音频数据](https://www.jianshu.com/p/e488da03f0ec)  
[IOS FFmpeg 零到自己的播放器 4，架构](https://www.jianshu.com/p/f8fb60e92558)