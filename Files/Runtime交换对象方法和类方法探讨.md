> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [www.jianshu.com](https://www.jianshu.com/p/aae1411b9cdc)

在项目中，经常用到 runtime 交换方法的地方，所以项目里前人给 NSObject 打了一个分类。代码如下 (方法为什么要先 addMethod 做判断，是因为我们要替换的方法有可能并没有在这个类中被实现，而是在他的父类中实现的，这个时候 originSEL 获取到的方法就是他父类中的方法，所以我们要在当前的类中添加一个 originSEL 方法，具体参考 [http://www.jianshu.com/p/a6b675f4d073](https://www.jianshu.com/p/a6b675f4d073)）

```
@implementation NSObject (Runtime)

+ (BOOL)swizzleMethod:(Class)class orgSel:(SEL)origSel swizzSel:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method altMethod = class_getInstanceMethod(class, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    BOOL didAddMethod = class_addMethod(class,origSel,
                                        method_getImplementation(altMethod),
                                        method_getTypeEncoding(altMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,altSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, altMethod);
    }
    
    return YES;
}


```

使用时就在相应的类的 load 方法类进行方法替换

```
@implementation NSArray (SafeArray)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 交换对象方法
      [self swizzleMethod:objc_getClass("__NSArrayI") orgSel:@selector(objectAtIndex:) swizzSel:@selector(safe_objectAtIndex:)];
        // 交换类方法
      [self swizzleMethod:object_getClass((id)self) orgSel:@selector(arrayWithObjects:count:) swizzSel:@selector(safe_arrayWithObjects:count:];
    });
}



```

##### 针对于上述数组类型的交换方法，交换对象方法和类方法使用了 objc_getClass，object_getClass。

先再了解一下 object_getClass，objc_getClass

> ### object_getClass :
> 
> 当 obj 为实例变量时，object_getClass(obj)与 [obj class] 输出结果一直，均获得 isa 指针，即指向类对象的指针。  
> 当 obj 为类对象时，object_getClass(obj) 返回类对象中的 isa 指针，即指向元类对象的指针；[obj class] 返回的则是其本身
> 
> ### objc_getClass:
> 
> 返回字符串对应的对象。和 NSClassFromString 一致

###### 为什么使用 objc_getClass, 因为 NSArray 是类簇， 关于 objectAtIndex，objectAtIndexedSubscript 方法的实现其实是_NSArrayI 实现的，所以使用 objc_getClass("__NSArrayI") 获取实际的类。不是类簇的类，是可以直接传入 self 或者 [self class] 进行交换对象方法的。

### ☆☆而此处要探讨的是为什么交换类方法可以使用`object_getClass`获取 Class, 也就是`[self swizzleMethod:object_getClass((id)self) orgSe...]`的方式交换成功☆☆

我们再回到交换方法的实现`+ (BOOL)swizzleMethod:(Class)class orgSel:(SEL)origSel swizzSel:(SEL)altSel`内部  
如果对 runtime 不是很了解的时候，看到这里之前就有几个疑问。  
**1. 分类里取 method 都是取对象方法`class_getInstanceMethod`取的，但是如果取类方法理应该是用`class_getClassMethod`这个 api。而上述分类不这样写也能成功交换到类方法，原因是什么**  
**2. 类方法交换时要这样使用`object_getClass("xxx")`取 Class 的原因**

> 为了便于测试，自己定义了一个类 以及分类，仿照 NSArray 的交换写法

```
#import <Foundation/Foundation.h>
@interface TestModel : NSObject
+ (void)classMethod;
- (void)instanceMethod;
@end

#import "TestModel.h"
@implementation TestModel
+ (void)classMethod {
    NSLog(@"调用了原本的类方法");
}
- (void)instanceMethod {
    NSLog(@"调用了原本的对象方法");
}
@end


```

```
#import "TestModel+swizzeTest.h"
#import "NSObject+SwizzleMethod.h"
@implementation TestModel (swizzeTest)

+ (void)load {
    // 使用这种写法可以
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:self orgSel:@selector(instanceMethod) swizzSel:@selector(swizzeInstanceMehtod)];
        [self swizzleMethod:object_getClass(self) orgSel:@selector(classMethod) swizzSel:@selector(swizzeClassMehtod)];
    });
}
- (void)swizzeInstanceMehtod {
    NSLog(@"调用了交换后的对象方法");
}
+ (void)swizzeClassMehtod {
    NSLog(@"调用了交换后的类方法");
}

@end


```

```
    TestModel *model = [TestModel new];
    [model instanceMethod];
    [TestModel classMethod];


```

输出：

![][img-0] 输出

### 结果可以看出交换成功，继续深入

深入一下 runtime([http://www.jianshu.com/p/54c190542aa8](https://www.jianshu.com/p/54c190542aa8))  
再自己瞎改瞎测试一下；

1. 首先  
NSObject 的分类方法还是如上一样，如果**不使用 object_getClass("xxx") 方式**, 那么交换类方法的代码改成

```
      [self swizzleMethod:self orgSel:@selector(classMethod) swizzSel:@selector(swizzeClassMehtod)];<----改动


```

经测试，果不其然交换类方法是交换失败的，`class_getInstanceMethod`取出的为`origMethod`和`altMethod` 为 nil。证实`class_getInstanceMethod`确实无法取出类方法的。  
再尝试再把分类里的代码`class_getInstanceMethod`改成`class_getClassMethod`。

```
+ (BOOL)swizzleMethod:(Class)class orgSel:(SEL)origSel swizzSel:(SEL)altSel {
    Method origMethod = class_getClassMethod(class, origSel);<----改动
    Method altMethod = class_getClassMethod(class, altSel);<----改动
    if (!origMethod || !altMethod) {
        return NO;
    }
    BOOL didAddMethod = class_addMethod(class,origSel,
                                        method_getImplementation(altMethod),
                                        method_getTypeEncoding(altMethod));
    
    if (didAddMethod) {
      // 方法已经添加
        class_replaceMethod(class,altSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, altMethod);
    }
    
    return YES;
}


```

照这样写，`origMethod`和`altMethod` 不为空，但是一测试还是没有交换成功类方法。  

![][img-1] image.png

每次都走了 if 里面的逻辑, 反而如果不进行`didAddMethod`判断直接使用`method_exchangeImplementations`交换就可以成功，所以怀疑是添加类方法`class_addMethod`有问题。

##### 再来读下资料：

**_创建对象的类本身也是对象，称为类对象，类对象中存放的是描述实例相关的信息，例如实例的成员变量，实例方法。  
类对象里的 isa 指针指向 Subclass（meta），Subclass（meta）也是一个对象，是元类对象，元类对象中存放的是描述类相关的信息，例如类方法_**  
读上面一段解释，我们可以大胆猜想，给对象加实例方法使用`class_addMethod(xx)`，xx 传入的是对象的类。 那使用给类添加类方法，应该给类的类（也就是元类 metaClass）进行添加。所以尝试对方法进行修改

```
    Method origMethod = class_getClassMethod(class, origSel);
    Method altMethod = class_getClassMethod(class, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
   //  使用object_getClass(class) 取得元类
    BOOL didAddMethod = class_addMethod(object_getClass(class),origSel, <----改动
                                        method_getImplementation(altMethod),
                                        method_getTypeEncoding(altMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,altSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, altMethod);
    }
    
    return YES;


```

### 这样写，交换成功

##### 通过几步的测试，我们可以就证实上面的猜想 (`给类添加类方法，应该给类的类（也就是元类metaClass`）以及解开关于文中刚开始的疑惑

> **1. 分类里取 method 都是取对象方法`class_getInstanceMethod`取的，但是如果取类方法应该是用`class_getClassMethod`这个 api。而上述分类为什么能交换到类方法?**

因为通过 object_getClass 获取到的是类的元类，因为类也是对象，类方法对于元类来说就是是它的对象方法，当 class 为元类时，使用 class_getInstanceMethod 是可以取出方法的，取出的为类方法。

> **2. 为什么类方法交换时要这样使用`object_getClass("xxx")`调用 swizzleMethod**

针对于文中最开始的的交换方法实现，对于交换实例方法，直接传入对象的 class 即可，而对于交换类方法，则需传入类的元类，object_getClass() 取出的就是元类，才能进行交换。

总结
--

1. 如果使用 object_getClass 得到元类来进行交换类方法的话，交换类方法和对象只需要共用一个交换对象方法的方法就行。

```
 [self swizzleMethod:self orgSel:@selector(instanceMethod) swizzSel:@selector(swizzeInstanceMehtod)];
 [self swizzleMethod:object_getClass(self) orgSel:@selector(classMethod) swizzSel:@selector(swizzeClassMehtod)];


```

2. 如果直接采用类进行调用的话，那么方法就应该分为交换对象方法和交换类方法。

```
 [self swizzleMethod:self orgSel:@selector(instanceMethod) swizzSel:@selector(swizzeInstanceMehtod)];
 [self swizzleClassMethod:self orgSel:@selector(classMethod) swizzSel:@selector(swizzeClassMehtod)];


```

```
+ (BOOL)swizzleMethod:(Class)class orgSel:(SEL)origSel swizzSel:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method altMethod = class_getInstanceMethod(class, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    BOOL didAddMethod = class_addMethod(class,origSel,
                                        method_getImplementation(altMethod),
                                        method_getTypeEncoding(altMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,altSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, altMethod);
    }
    
    return YES;
}

+ (BOOL)swizzleClassMethod:(Class)class orgSel:(SEL)origSel swizzSel:(SEL)altSel {
    Method origMethod = class_getClassMethod(class, origSel);
    Method altMethod = class_getClassMethod(class, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    BOOL didAddMethod = class_addMethod(object_getClass(class),origSel,
                                        method_getImplementation(altMethod),
                                        method_getTypeEncoding(altMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,altSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, altMethod);
    }
    
    return YES;
}


```

Demo：[https://github.com/sy5075391/RuntimeSwizze.git](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fsy5075391%2FRuntimeSwizze.git)

[img-0]:data:image/webp;base64,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

[img-1]:data:image/webp;base64,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