> ### Activity Theme Translation 动画


```
activityOpenEnterAnimation
打开新Activity，新Activity进入动画

activityOpenExitAnimation
打开新Activity，旧Activity退出动画

activityCloseEnterAnimation
回退旧Activity，旧Activity进入动画

activityCloseExitAnimation
回退旧Activity，新Activity退出动画
```

> ### 生命周期 

1. onCreate（）：activity第一次启动时被调用，在该方法中初始化activity所能使用的全局资源和状态，如：绑定事件，创建线程等。

2. onStart（）：当activity对用户可见时调用，即activity展现在前端，该方法一般用来初始化或启动与更新界面相关的资源

3.  onResume（）：当用户与activity进行交互时被调用，此时activity位于返回栈的栈顶，并处于运行状态，该方法完成一些轻量级的工作，避免用户等待

4.  onPause（）：启动或恢复另一个activity的时候被调用，该方法一般用来保存界面的持久信息，提交未保存的数据，并释放消耗CPU的资源。

5.  onStop（）：该方法在activity不可见状态时调用，如：其他activity启动或恢复并将其覆盖时调用。

6.  onDestroy（）：在activity销毁之前被调用。

7、 onRestart（）：当activity重新启动时调用。

![生命周期图](https://img-blog.csdn.net/20180427171413687)


* [Activity的7个回调方法及生命周期案例](https://blog.csdn.net/weixin_42067967/article/details/80110745)
* [Android动画<第七篇>：Activity切换动画](events.jianshu.io/p/7a3c245a8883)