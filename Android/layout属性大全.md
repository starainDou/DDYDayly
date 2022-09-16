> ### 第一类 属性值true或false

```
android:layout_centerHrizontal 水平居中

android:layout_centerVertical 垂直居中

android:layout_centerInparent 相对于父元素完全居中

android:layout_alignParentBottom 贴紧父元素的下边缘

android:layout_alignParentLeft 贴紧父元素的左边缘

android:layout_alignParentRight 贴紧父元素的右边缘

android:layout_alignParentTop 贴紧父元素的上边缘

android:layout_alignWithParentIfMissing 如果对应的兄弟元素找不到的话就以父元素做参照物

android:layout_alignParentStart 紧贴父元素结束位置开始

android:layout_alignParentEnd 紧贴父元素结束位置结束

android:animateLayoutChanges 布局改变时是否有动画效果

android:clipChildren 定义子布局是否一定要在限定的区域内

android:clipToPadding 定义布局间是否有间距

android:animationCache 定义子布局也有动画效果

android:alwaysDrawnWithCache 定义子布局是否应用绘图的高速缓存

android:addStatesFromChildren 定义布局是否应用子布局的背景

android:splitMotionEvents 定义布局是否传递touch事件到子布局

android:focusableInTouchMode 定义是否可以通过touch获取到焦点

android:isScrollContainer 定义布局是否作为一个滚动容器 可以调整整个窗体

android:fadeScrollbars 滚动条自动隐藏

android:fitsSystemWindows 设置布局调整时是否考虑系统窗口(如状态栏)

android:visibility 定义布局是否可见 
visible:占位且可见 invisible:占位但不可见 gone:不占位且隐藏

android:clickable 定义是否可点击

android:longClickable 定义是否可长点击

android:saveEnabled 设置是否在窗口冻结时（如旋转屏幕）保存View的数据

android:filterTouchesWhenObscured 所在窗口被其它可见窗口遮住时,是否过滤触摸事件

android:keepScreenOn 设置屏幕常亮

android:duplicateParentState 是否从父容器中获取绘图状态(光标,按下等)

android:soundEffectsEnabled 点击或触摸是否有声音效果

android:hapticFeedbackEnabled 设置触感反馈
```

> ### 第二类：属性值必须为id的引用名"@id/id-name"

```
android:layout_alignBaseline 本元素的文本与父元素文本对齐

android:layout_below 在某元素的下方

android:layout_above 在某元素的的上方

android:layout_toLeftOf 在某元素的左边

android:layout_toRightOf 在某元素的右边

android:layout_toStartOf本元素从某个元素开始

android:layout_toEndOf本元素在某个元素结束

android:layout_alignTop 本元素的上边缘和某元素的的上边缘对齐

android:layout_alignLeft 本元素的左边缘和某元素的的左边缘对齐

android:layout_alignBottom 本元素的下边缘和某元素的的下边缘对齐

android:layout_alignRight 本元素的右边缘和某元素的的右边缘对齐

android:layout_alignStart 本元素与开始的父元素对齐

android:layout_alignEnd 本元素与结束的父元素对齐

android:ignoreGravity 指定元素不受重力的影响

android:layoutAnimation 定义布局显示时候的动画

android:id 为布局添加ID方便查找

android:tag 为布局添加tag方便查找与类似

android:scrollbarThumbHorizontal 设置水平滚动条的drawable。
横向短条

android:scrollbarThumbVertical 设置垂直滚动条的drawable
纵向短条

android:scrollbarTrackHorizontal 设置水平滚动条背景（轨迹）的色drawable
横向长条(背景)

android:scrollbarTrackVertical 设置垂直滚动条背景（轨迹）的色drawable
纵向长条(背景)

scrollbarThumbXXX/scrollbarTrackXXX 
可以使用Shape自定义Drawable、图片、.9.png、@color/xxx方式颜色
不可以 直接使用 #000 颜色值

android:scrollbarAlwaysDrawHorizontalTrack 设置水平滚动条是否含有轨道

android:scrollbarAlwaysDrawVerticalTrack 设置垂直滚动条是否含有轨道

android:nextFocusLeft 设置左边指定视图获得下一个焦点

android:nextFocusRight 设置右边指定视图获得下一个焦点

android:nextFocusUp 设置上边指定视图获得下一个焦点

android:nextFocusDown 设置下边指定视图获得下一个焦点

android:nextFocusForward 设置指定视图获得下一个焦点

android:contentDescription 说明

android:OnClick 点击时从上下文中调用指定的方法
```

> ### 第三类：属性值为具体的像素值，如30dip，40px,50dp

```
android:alpha 设置透明度

android:rotation 旋转度数

android:rotationX 水平旋转度数

android:rotationY 垂直旋转度数

android:scaleX 设置X轴缩放

android:scaleY 设置Y轴缩放

android:layout_width 定义本元素的宽度
0dp : match_constraint 占用所有可用空间
具体值：设置成该值的大小
wrap_content: 根据内容计算
match_parent: fill_parent 和父组件一样长度

android:layout_height 定义本元素的高度

android:layout_margin 本元素离上下左右间的距离

android:layout_marginBottom 离某元素底边缘的距离

android:layout_marginLeft 离某元素左边缘的距离

android:layout_marginRight 离某元素右边缘的距离

android:layout_marginTop 离某元素上边缘的距离

android:layout_marginStart 本元素里开始的位置的距离

android:layout_marginEnd 本元素里结束位置的距离

android:scrollX 水平初始滚动偏移

android:scrollY 垂直初始滚动偏移

android:padding 指定布局与子布局的间距

android:paddingLeft 指定布局左边与子布局的间距

android:paddingTop 指定布局上边与子布局的间距

android:paddingRight 指定布局右边与子布局的间距

android:paddingBottom 指定布局下边与子布局的间距

android:paddingStart 指定布局左边与子布局的间距与android:paddingLeft相同

android:paddingEnd 指定布局右边与子布局的间距与android:paddingRight相同

android:fadingEdgeLength 设置边框渐变的长度

android:minHeight 最小高度

android:minWidth 最小宽度

android:translationX 水平方向的移动距离

android:translationY 垂直方向的移动距离

android:transformPivotX 相对于一点的水平方向偏转量

android:transformPivotY 相对于一点的垂直方向偏转量
```

> ### 第四类：属性值问Android内置值的

```
android:gravity 控件布局方式 相对自身的内部元素对齐方式

android:layout_gravity 布局方式: 相对父容器的对齐方式

android:persistentDrawingCache 定义绘图的高速缓存的持久性
none: 0x0 The drawing cache is not persisted after use.
animation: 0x1 The drawing cache is persisted after a layout animation.
scrolling: 0x2 The drawing cache is persisted after a scroll.
all: 0x3 The drawing cache is always persisted.
定义绘图的高速缓存的持久性。 绘图缓存可能由一个ViewGroup 在特定情况下为其所有的子类启用，例如在一个滚动的过程中。 此属性可以在初次使用后保留在其在内存中的缓存。 坚持缓存会消耗更多的内存，但可能会阻止频繁的垃圾回收是反复创建缓存。 默认情况下持续存在设置为滚动

android:descendantFocusability 控制子布局焦点获取方式 常用于listView的item中包含多个控件 点击无效
beforeDescendants: viewgroup会优先其子控件而获得焦点.
afterDescendants: viewgroup只有当其子类控件不需要获取焦点时才获取焦点.
blockDescendants: viewgroup会覆盖子类控件而直接获得焦点.

android:scrollbars 设置滚动条的状态
none: 不显示
vertical：垂直方向
horizontal：水平方向


android:scrollbarStyle 设置滚动条的样式
可以定义滚动条的样式和位置，用于Listview、scrollview等滚动view
insideOverlay：默认值，表示在padding区域内并且覆盖在view上
insideInset：表示在padding区域内并且插入在view后面
outsideOverlay：表示在padding区域外并且覆盖在view上
outsideInset：表示在padding区域外并且插入在view后面

android:fitsSystemWindows 设置布局调整时是否考虑系统窗口(如状态栏)
CoordinatorLayout、CollapsingToolbarLayout、DrawerLayout布局时fitsSystemWindows设为true能延伸到状态栏，
FrameLayout布局时是不会延伸到状态栏的
CoordinatorLayout时还会对子元素偏移以防止被状态栏遮挡

android:scrollbarFadeDuration 设置滚动条淡入淡出时间，以毫秒为单位

android:scrollbarDefaultDelayBeforeFade 设置滚动条N毫秒后开始淡化，以毫秒为单位。

android:scrollbarSize 设置滚动条大小

android:fadingEdge 设置拉滚动条时，边框渐变的放向【level 14-】
none:无渐变
horizontal:横向
vertical:纵向

android:requiresFadingEdge 设置拉滚动条时，边框渐变的放向【level 14+】
none:无渐变
horizontal:横向
vertical:纵向


android:drawingCacheQuality 设置绘图时半透明质量
auto: 默认，由框架决定
high: 高质量，使用较高的颜色深度，消耗更多的内存
low: 低质量，使用较低的颜色深度，但是用更少的内存

android:OverScrollMode 滑动到边界时继续滑动光晕样式
always: 滑到边界后继续滑动也总是会出现弧形光晕
ifContentScrolls：滑到边界后继续滑动若recycleview里的内容可滑动，会出现弧形光晕，否则不出现弧形光晕
never：滑到边界后继续滑动也总是会出现弧形光晕


android:verticalScrollbarPosition 摄者垂直滚动条的位置

android:layerType 设定支持

android:layoutDirection 定义布局图纸的方向

android:textDirection 定义文字方向

android:textAlignment 文字对齐方式

android:importantForAccessibility 设置可达性的重要行

Android:labelFor 添加标签
```

> ### Drawable

```
android:background 本元素的背景
```

* [Android persistentDrawingCache](https://blog.csdn.net/lili_ko/article/details/39372457)
* [android:descendantFocusability](https://blog.csdn.net/CHS007chs/article/details/88734935)
* [自定义Scrollbar样式](https://www.bbsmax.com/A/Gkz1a0OQzR/)
* [再学一遍android:fitsSystemWindows属性](https://blog.csdn.net/u012165769/article/details/123088643)
* [Android RecycleView设置边缘模糊](https://www.jianshu.com/p/d2beab573b70)
* [ViewPager2 android:overScrollMode=“never“ 不生效的问题](https://blog.csdn.net/slyzlh/article/details/107568730)