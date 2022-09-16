> Android Studio

```
下载地址 https://developer.android.google.cn/studio/
```

> JDK

```
下载地址 http://jdk.java.net/
```

> 基本目录文件 

```
.gitignore git管理忽略内容
build 存放构建结果
build.gradle 为gradle构建文件
libs 项目依赖的第三方库
proguard-rule.pro 混淆代码相关配置
src 存放源码(java/kotlin)、资源文件(图片、字符串、颜色、尺寸)、单元测试、manifest文件(系统清单文件，描述应用名称、图标、组件、权限信息)
```

> 四大组件

```
Activity:负责用户交互，使用view来显示内容
Service:运行于后台，不与用户交互，通常用于为其他组件提供后台服务或监控服务状态
broadcastReceiver:消息接收器，主要监听其他组件的消息
ContentProvider:跨应用数据交换的标准，用于在许可的情况下获取其他应用的数据
```

> Intent

```
通信载体，系统是大海，应用是海上国家，组件是国家的岛屿，载体为小船
```

> view组件解读

```
Android中大部分UI组件都放在 android.widget包及其子包、android.view包及其子包。所有UI组件继承自View类，view类还有一个重要的子类ViewGroup，可以作为组件的容器。
```

> 控制UI界面

```
Android中可以使用xml静态方式和动态常见view方式来控制UI界面。
1.静态控制UI方式：使用xml控制视图，通过setContentView设置xml布局文件，通过findViewById来从布局文件中获取UI组件的句柄索引，这样就可以对组件进行控制和事件监听了
2.动态控制UI方式：Android中可以使用java/kotlin语言来直接创建View、布局layout、监听器等
静态方式简约但不灵活，动态方式灵活但不利于解耦同时代码相对臃肿
```

> Color 颜色 

```
Android 颜色值支持4种形式(#开头)
#RGB #ARGB #RRGGBB #AARRGGBB

代码中可以使用Color类常量 int color = Color.BLUE
还可以ARGB构建 int color = Color.argb(127, 255, 0, 0)

values目录创建color.xml(该方法扩展性好，便于修改和共享)
<resources> 
<color name=”mycolor”> #7fff00ff</color> 
</resources> 

xml中使用 android:textColor= "@drawable/mycolor" 
代码中使用 int color = getResources().getColor(R.color.mycolor);

顺便补充 Android布局中背景图片的设置
可以使用纯色：android:background="@drawable/mycolor"
也可使用图片：android:background="@drawable/bg" 
(需将一个名为bg.jpg或png的图片拷贝到res/drawable-hdpi)
```

> 七大布局方式

* LinearLayout 线性布局
* RelativeLayout 相对布局
* FrameLayout 帧布局
* TableLayout 表格布局
* AbsoluteLayout 绝对布局
* GridLayout 网格布局
* ConstraintLayout 约束布局 

LinearLayout 线性布局

```
android:orientation 对应方法 setOrientation(int)，设置布局管理器内组件的排列方式，可以设置为horizontal/vertical 

android:gravity 对应方法 setGravity(int) 
gravity 组件重心也就是对齐方式，可以同时指定一种或多种对其方式
android:gravity 是相对view组件本身来说的，用以设置组件本身 内容应该显示在组件的什么位置。
android:layout_gravity 是相对于

top:将对象放在容器顶部，大小不变
bottom:将对象放在容器底部，大小不变
left:将对象放在容器左侧，大小不变
right:将对象放在容器的右侧，大小不变
start:兼容LTR和RTL布局，起始位置
end:兼容LTR和RTL布局，结束位置
center_vertical:纵向居中，大小不变
fill_vertical:如果需要，纵向填充
center_horizontal:横向居中，大小不变
fill_horizontal:如果需要，横向填充
center:纵向横向都居中，大小不变
fill:纵向横向都填充
clip_vertical:
clip_horizontal:

```

https://blog.51cto.com/u_14344871/5186538

https://www.jianshu.com/p/d4fb716893cc

https://cloud.tencent.com/developer/article/1035755