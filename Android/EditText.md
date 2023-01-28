```
android:hint="默认提示文本" // 提示文本占位字符
android:textColorHint="#95A1AA" // 提示文本占位字符颜色
android:selectAllOnFocus="true" // 获得焦点后是否全选文本
android:minLines="3" // 最小行数
android:maxLines="3" // 最大行数(超过则滚动)
android:singleLine="true" // 单行
android:textScaleX="1.5"    // 设置字与字的水平间隔
android:textScaleY="1.5"    // 设置字与字的垂直间隔

android:capitalize 大写字符情况
none: 默认
sentences: 仅第一个字母大写
word: 单词第一个字母大写
characters: 所有字母都大写
```

输入类型【文本类型，多为大写、小写和数字符号】

```
android:inputType="none"  
android:inputType="text"  
android:inputType="textCapCharacters"  
android:inputType="textCapWords"  
android:inputType="textCapSentences"  
android:inputType="textAutoCorrect"  
android:inputType="textAutoComplete"  
android:inputType="textMultiLine"  
android:inputType="textImeMultiLine"  
android:inputType="textNoSuggestions"  
android:inputType="textUri"  
android:inputType="textEmailAddress"  
android:inputType="textEmailSubject"  
android:inputType="textShortMessage"  
android:inputType="textLongMessage"  
android:inputType="textPersonName"  
android:inputType="textPostalAddress"  
android:inputType="textPassword"  
android:inputType="textVisiblePassword"  
android:inputType="textWebEditText"  
android:inputType="textFilter"  
android:inputType="textPhonetic" 
```

数值类型

```
android:inputType="number"  
android:inputType="numberSigned"  
android:inputType="numberDecimal"  
android:inputType="phone"//拨号键盘  
android:inputType="datetime"  
android:inputType="date"//日期键盘  
android:inputType="time"//时间键盘
```

* [2.3.2 EditText(输入框)详解](https://www.runoob.com/w3cnote/android-tutorial-edittext.html)
* [Android零基础入门第18节：EditText的属性和使用方法](https://blog.csdn.net/cqkxzsxy/article/details/76290126)
* 