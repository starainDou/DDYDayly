> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [juejin.cn](https://juejin.cn/post/7056968779032428575#heading-1)

NSMethodSignature
=================

**NSMethodSignature** 主要是方法的返回值和参数的类型信息的记录。

方法签名由方法返回类型的一个或多个字符组成，后跟隐式参数`self`和`_cmd`的字符串编码，还有零个或多个显式参数。可以使用`methodReturnType`和`methodReturnLength`属性确定字符串编码和返回类型的长度。`numberOfArguments`属性获取方法参数个数。可以使用`getArgumentTypeAtIndex:` 根据索引获取方法参数。

例如，**NSString** 实例方法`containsString:`有一个带有以下参数的方法签名: @encode(BOOL) (c) 为返回类型 @encode(id) (@) 为接收者 (self) @encode(SEL) (:) 为选择器 (_cmd) @encode(NSString *) (@) 为第一个显式参数

NSInvocation
============

**NSInvocation** 对象用于在对象之间存储和转发消息。**NSInvocation** 对象包含一个 Objective-C 消息的所有元素: 目标、选择器、参数和返回值。每个元素都可以直接设置，当 **NSInvocation** 对象被分派时，返回值会自动设置。

一个 **NSInvocation** 对象可以被重复地分派到不同的目标；它的参数可以修改之间的调度不同的结果；甚至它的选择器也可以更改为具有相同方法签名 (参数和返回类型) 的另一个选择器。这种灵活性使得 **NSInvocation** 在使用许多参数和变量重复消息时非常有用；在每次将 **NSInvocation** 对象发送到一个新目标之前，你可以根据需要修改它，而不是为每个消息重新输入稍微不同的表达式。

**NSInvocation** 不支持使用可变数量的参数或联合参数的方法调用。创建 **NSInvocation** 对象应该使用`invocationWithMethodSignature:`类方法来创建，不应该使用`alloc`和`init`创建。

默认情况下，该类不保留包含的调用的参数。如果那些对象可能在你创建 **NSInvocation** 实例的时间和你使用它的时间之间释放，你应该显式地保留你自己的对象或调用`retainArguments`方法来让调用对象保留它们自己。

> 注意： NSInvocation 遵循 NSCoding 协议，但只支持 NSPortCoder 编码。NSInvocation 不支持归档。

使用
==

1.  获取对象方法签名。

```
NSMethodSignature *signature = [object methodSignatureForSelector:selector];


```

2.  根据方法签名创建 **NSInvocation** 对象。

```
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];


```

3.  设置执行方法的对象和方法选择器。

```
invocation.target = object;
invocation.selector = selector;


```

4.  设置方法参数。由于前两个参数为隐式 self 和_cmd，所以需要从第三个参数开始传入显式参数。

入参需要根据参数的类型进行转换后再设置给 **invocation** 对象。如果不正确根据类型编码设置参数，会导致在方法中无法获取到正确的值。比如传入 BOOL 值 @(YES)，期望接收到的参数为 YES，实际为 NO（参数默认值）。

```
NSUInteger paramCount = MIN(signature.numberOfArguments - 2, params.count);
for (int i = 0; i < paramCount; i++) {
    id argument = params[i];
    //获取参数类型编码。如果不正确根据类型编码设置参数，会导致在方法中无法获取到正确的值。比如传入BOOL值@(YES)，期望接收到的参数为YES，实际为NO（参数默认值）
    const char *argumentType = [signature getArgumentTypeAtIndex:i + 2];
    if ([argument isKindOfClass:[NSNumber class]]) {
        if (!strcmp(argumentType, @encode(BOOL))) {
            BOOL arg = [argument boolValue];
            [invocation setArgument:&arg atIndex:i + 2];
        }
        else if (!strcmp(argumentType, @encode(int))) {
            int arg = [argument intValue];
            [invocation setArgument:&arg atIndex:i + 2];
        }
        ...
    }
    else {
        [invocation setArgument:&argument atIndex:i + 2];
    }
}


```

**invocation** 设置的参数可以比方法的入参个数少，未被赋值的参数变量为默认值。 比如：id 类型参数默认值为 nil，BOOL 类型参数默认为 NO 等等。

5.  引用参数并执行方法。invocation 默认不会对入参进行引用，为了防止在方法执行完成之前参数被释放，需要手动持有一下参数。

```
//引用参数，防止在方法执行完成之前参数释放
[invocation retainArguments];
//执行方法
[invocation invoke];


```

6.  获取返回值并根据返回值类型进行类型转换。因为返回的是 c 的数据类型 void *，所以需要将返回的类型转换成对应的 OC 对象。 更多编码请参见 Objective-C 运行时编程指南中的[类型编码](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FCocoa%2FConceptual%2FObjCRuntimeGuide%2FArticles%2FocrtTypeEncodings.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40008048-CH100 "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100")。

```
//判断是否有返回值
if (signature.methodReturnLength) {
    //获取返回值类型
    const char *returnType = signature.methodReturnType;
    //返回值类型转换
    if (!strcmp(returnType, @encode(void))) {//无返回值
        return nil;
    }
    else if (!strcmp(returnType, @encode(id))) {//对象类型
        void *returnValue;
        [invocation getReturnValue:&returnValue];
        return (__bridge id)returnValue;
    }
    else {//基本数据类型
        void *returnValue = (void *)malloc(signature.methodReturnLength);
        [invocation getReturnValue:returnValue];
        
        id result = nil;
        //根据类型转成NSNumber
        if (!strcmp(returnType, @encode(BOOL))) {
            result = [NSNumber numberWithBool:*((BOOL *)returnValue)];
        }
        else if (!strcmp(returnType, @encode(int))) {
            result = [NSNumber numberWithInt:*((int *)returnValue)];
        }
        else if (!strcmp(returnType, @encode(short))) {
            result = [NSNumber numberWithShort:*((short *)returnValue)];
        }
        ...
        free(returnValue);
        
        return result;
    }
}


```

完整代码如下： **HYInjectionCenter.h**

```
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYInjectionCenter : NSObject

+ (id)invocationMethod:(NSString *)methodName
                object:(id)object
                params:(NSArray *)params;

+ (id)invocationMethod:(NSString *)methodName
             className:(NSString *)className
                params:(NSArray *)params;

@end

NS_ASSUME_NONNULL_END


```

**HYInjectionCenter.m**

```
#import "HYInjectionCenter.h"
#import <objc/runtime.h>

@implementation HYInjectionCenter

+ (id)invocationMethod:(NSString *)methodName object:(id)object params:(NSArray *)params {
    if (![methodName isKindOfClass:[NSString class]] || methodName.length == 0 || !object) {
        return nil;
    }
    
    SEL selector = NSSelectorFromString(methodName);
    //获取对象方法签名
    NSMethodSignature *signature = [object methodSignatureForSelector:selector];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = object;
        invocation.selector = selector;
        
        //由于前两个参数为隐式self和_cmd，所以需要从第三个参数开始传入显式参数。
        NSUInteger paramCount = MIN(signature.numberOfArguments - 2, params.count);
        for (int i = 0; i < paramCount; i++) {
            id argument = params[i];
            const char *argumentType = [signature getArgumentTypeAtIndex:i + 2];
            if ([argument isKindOfClass:[NSNumber class]]) {
                if (!strcmp(argumentType, @encode(BOOL))) {
                    BOOL arg = [argument boolValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(int))) {
                    int arg = [argument intValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(short))) {
                    int arg = [argument intValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(long))) {
                    long arg = [argument longValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(long long))) {
                    long long arg = [argument longLongValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(float))) {
                    float arg = [argument floatValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(double))) {
                    double arg = [argument doubleValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(char))) {
                    char arg = [argument charValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(unsigned short))) {
                    unsigned short arg = [argument unsignedShortValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(unsigned int))) {
                    unsigned int arg = [argument unsignedIntValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(unsigned long))) {
                    unsigned long arg = [argument unsignedLongValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(unsigned long long))) {
                    unsigned long long arg = [argument unsignedLongLongValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
                else if (!strcmp(argumentType, @encode(unsigned char))) {
                    unsigned char arg = [argument unsignedCharValue];
                    [invocation setArgument:&arg atIndex:i + 2];
                }
            }
            else {
                [invocation setArgument:&argument atIndex:i + 2];
            }
        }
        //引用参数，防止在方法执行完成之前参数释放
        [invocation retainArguments];
        //执行方法
        [invocation invoke];
        
        //判断是否有返回值
        if (signature.methodReturnLength) {
            //获取返回值类型
            const char *returnType = signature.methodReturnType;
            //返回值类型转换
            if (!strcmp(returnType, @encode(void))) {//无返回值
                return nil;
            }
            else if (!strcmp(returnType, @encode(id))) {//对象类型
                void *returnValue;
                [invocation getReturnValue:&returnValue];
                return (__bridge id)returnValue;
            }
            else {//基本数据类型
                void *returnValue = (void *)malloc(signature.methodReturnLength);
                [invocation getReturnValue:returnValue];
                
                id result = nil;
                //根据类型转成NSNumber
                if (!strcmp(returnType, @encode(BOOL))) {
                    result = [NSNumber numberWithBool:*((BOOL *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(int))) {
                    result = [NSNumber numberWithInt:*((int *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(short))) {
                    result = [NSNumber numberWithShort:*((short *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(long))) {
                    result = [NSNumber numberWithLong:*((long *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(long long))) {
                    result = [NSNumber numberWithLongLong:*((long long *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(float))) {
                    result = [NSNumber numberWithFloat:*((float *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(double))) {
                    result = [NSNumber numberWithDouble:*((double *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(char))) {
                    result = [NSNumber numberWithChar:*((char *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(unsigned short))) {
                    result = [NSNumber numberWithUnsignedShort:*((unsigned short *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(unsigned int))) {
                    result = [NSNumber numberWithUnsignedInt:*((unsigned int *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(unsigned long))) {
                    result = [NSNumber numberWithUnsignedLong:*((unsigned long *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(unsigned long long))) {
                    result = [NSNumber numberWithUnsignedLongLong:*((unsigned long long *)returnValue)];
                }
                else if (!strcmp(returnType, @encode(unsigned char))) {
                    result = [NSNumber numberWithUnsignedChar:*((unsigned char *)returnValue)];
                }
                free(returnValue);
                
                return result;
            }
        }
    }
    return nil;
}

+ (id)invocationMethod:(NSString *)methodName className:(NSString *)className params:(NSArray *)params {
    if (![className isKindOfClass:[NSString class]] || className.length == 0) {
        return nil;
    }
    return [self invocationMethod:methodName object:NSClassFromString(className) params:params];
}

@end


```

测试
==

创建一个 HYManager 类，类中包含以下方法。

```
@interface HYManager : NSObject

- (void)param1:(NSString *)param1 param2:(BOOL)param2 param3:(NSInteger)param3;
- (NSString *)formatWithParam1:(NSString *)param1 param2:(NSInteger)param2;

- (BOOL)boolTest;
- (CGFloat)CGFloatTest;
- (NSInteger)integerTest;


```