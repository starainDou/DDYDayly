> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [danleechina.github.io](https://danleechina.github.io/use-libclang-in-xcode/)

> 前言

之前写过一个小工具 [MixPlainText](https://github.com/danleechina/mixplaintext)，可以将 Xcode 工程代码中所有的明文加密。原理是使用正则表达式来提取代码中所有的明文。现在介绍一种新的更加完善、更有拓展性的方法。用到的工具主要是 `libclang`。

这里我已经将所有代码、配置上传到 GitHub 了，所以有兴趣也可以直接下载代码查看，地址 [UsingLibClang](https://github.com/danleechina/UsingLibClang)

由于我是用 C 语言来调用 `libclang` 的。所以这里介绍一下怎么配置 Xcode 工程来使用这个库。当然你也可以用 Python 来使用这个库，具体方式可以看这个文章 [Parsing C++ in Python with Clang](http://eli.thegreenplace.net/2011/07/03/parsing-c-in-python-with-clang)

1.  去 [http://llvm.org/svn/llvm-project/cfe/trunk/include/clang-c/](http://llvm.org/svn/llvm-project/cfe/trunk/include/clang-c/) 下载所有头文件。
2.  工程中添加上面下载的头文件
3.  点击工程配置中的 ‘Build Phases’，打开 ‘Link Binary With Libraries’, 点击 ‘+’ 号，然后选择 ‘Add other…’。
4.  使用快捷键 ⌘⇧G 打开 `/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libclang.dylib`, 将 Xcode 自带的 libclang.dylib 添加到环境中。
5.  转到 ‘Build Setting’。
6.  添加一个新的 ‘Runpath search paths’：‘`$(DEVELOPER_DIR)/Toolchains/XcodeDefault.xctoolchain/usr/lib`’
    
    这里的 `$(DEVELOPER_DIR)` 指代 `/Applications/Xcode.app/Contents/Developer`
    
7.  添加一个新的 ‘header search paths’：`$(SRCROOT)/path_to_clang_header_file`
    
    注意这里的 `$(SRCROOT)` 指代工程所在的目录。后面的具体路径就是上面下载的头文件的位置。
    
8.  添加新的 ‘Library Search Paths’： `$(DEVELOPER_DIR)/Toolchains/XcodeDefault.xctoolchain/usr/lib`
9.  将 `Enable Modules (C and Objective-C)` 设置为 NO

代码如下，必要地方有注释说明：

```
#import <Foundation/Foundation.h>
#include <cstdio>
#include <string>
#include <cstdlib>
// libclang 公开 API 均在这里
#include "clang-c/Index.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 一个编译单元，通常是一个文件
        CXTranslationUnit tu;
        // 一个 index 可以包含多个编译单元
        CXIndex index = clang_createIndex(1, 1);
        // 需要分析混淆的 Objective C 源代码文件
        const char *filePath = "/path_to_OC_code/HomeViewController.m";
        // 
        tu = clang_parseTranslationUnit(index, filePath, NULL, 0, nullptr, 0, 0);
        if (!tu) {
            printf("Couldn't create translation unit");
            return 1;
        }
        // 根 cursor
        CXCursor rootCursor = clang_getTranslationUnitCursor(tu);
        // 一个个经过词法分析以后得到的 token
        CXToken *tokens;
        unsigned int numTokens;
        CXCursor *cursors = 0;
        CXSourceRange range = clang_getCursorExtent(rootCursor);
        // 获取所有的 token
        clang_tokenize(tu, range, &tokens, &numTokens);
        cursors = (CXCursor *)malloc(numTokens * sizeof(CXCursor));
        // 获取每个 token 对应的 cursor
        clang_annotateTokens(tu, tokens, numTokens, cursors);
        // 遍历 token
        for(int i=0; i < numTokens; i++) {
            CXToken token = tokens[i];
            CXCursor cursor = cursors[i];
            CXString tokenSpelling = clang_getTokenSpelling(tu, token);
            CXString cursorSpelling = clang_getCursorSpelling(cursor);
            const char *tokenName = clang_getCString(tokenSpelling);
            if (CXToken_Literal == clang_getTokenKind(token) // 是明文的 token
                && CXCursor_PreprocessingDirective != cursor.kind // 排除预编译 token
                && strlen(tokenName) >= 2 // 排除所有非字符串 token
                && tokenName[0] == '\"'
                && tokenName[strlen(tokenName) - 1] == '\"' ) {
                // Do some replacing.
                NSData *content = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithUTF8String:filePath]];
                NSString *contentString = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
                // stringToBeResplaced 是需要被混淆的代码
                NSString *stringToBeResplaced = [NSString stringWithUTF8String:tokenName];
                // stringToBePutted 是经过混淆的代码
                NSString *stringToBePutted = @"\"Hello\"";
                contentString = [contentString stringByReplacingOccurrencesOfString:stringToBeResplaced withString:stringToBePutted];
                // 将经过混淆的代码写回原文件
                [contentString writeToFile:[NSString stringWithUTF8String:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                printf("\t%d\t%s\n", cursor.kind, tokenName);
            }
            // 释放内存
            clang_disposeString(tokenSpelling);
            clang_disposeString(cursorSpelling);
        }
        // 释放内存
        clang_disposeTokens(tu, tokens, numTokens);
        clang_disposeIndex(index);
        clang_disposeTranslationUnit(tu);
        free(cursors);
    }
    return 0;
}


```

建议将上述代码编译生成的二进制可执行文件，放到您需要混淆的工程里面。添加一个新的 ‘Run path’，调用这个二进制文件处理每个你想要处理的源代码。

1.  [Parsing C++ in Python with Clang](http://eli.thegreenplace.net/2011/07/03/parsing-c-in-python-with-clang)
2.  [libclang experiments](https://github.com/burnflare/libclang-experiments)
3.  [Apple libclang video](http://llvm.org/devmtg/2010-11/)
4.  [liblcang API](https://clang.llvm.org/doxygen/group__CINDEX.html)