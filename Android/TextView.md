> ### 属性详解

```

```

> ### 跑马灯

```
<TextView
        android:id="@+id/marqueeTextView"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginStart="12dp"
        android:clickable="false"
        android:ellipsize="marquee"
        android:focusable="true"
        android:focusableInTouchMode="true"
        android:marqueeRepeatLimit="-1"
        android:maxWidth="100dp"
        android:singleLine="true"
        android:text="跑马灯12345678901234567890"
        android:textIsSelectable="false"
        android:textSize="12sp"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintStart_toStartOf="parent" />
        
android:marqueeRepeatLimit="-1" 跑马灯循环次数，-1则无限循环
android:focusableInTouchMode="true" 触控模式下取得焦点，必须 true
android:focusable="true" TextView取得焦点，必须true
android:ellipsize="marquee" 文本显示不下时处理方式 marquee:跑马灯式
```

代码实现方式

```
private void setTextMarquee(TextView textView) {
    if (textView != null) {
    textView.setEllipsize(TextUtils.TruncateAt.MARQUEE);
        textView.setSingleLine(true);
        textView.setSelected(true);
        textView.setFocusable(true);
        textView.setFocusableInTouchMode(true);
    }
}
```

[上下跑马灯](https://stackoverflow.com/questions/25731123/android-animations-similar-to-make-marquee-vertical)
