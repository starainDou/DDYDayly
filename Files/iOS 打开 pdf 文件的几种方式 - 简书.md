> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [www.jianshu.com](https://www.jianshu.com/p/ec21d364aecb)

##### 目录：

###### 一、 `WKWebView`加载本地或者网络 pdf 文档

###### 二、 利用`QLPreviewController`加载 pdf 文档 （系统框架`<QuickLook/QuickLook.h>`）

###### 三、 利用`PDFView`(系统框架`<PDFKit/PDFKit.h>`) 打开

> 特别说明⚠️：加载网络 pdf 文档最好下载到本地然后加载，不然可能会卡顿，有时还有莫名的加载失败甚至闪退...

第一种：`WKWebView`加载本地或者网络 pdf 文档

*   按照这种方式和普通的加载 html 没有任何区别，这里小编就不做多余的赘述；
*   存在的问题⚠️：加载 pdf 后，再 push 到另外一个页面，返回到`WKWebView`页面，原先的内容不见了, 会变成空白一片；

第二种：利用`QLPreviewController`加载 pdf 文档 , 首先判断是否加载到本地，如果有直接加载本地的，如果没有就进行文件下载，然后加载文件：

```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.previewController  =  [[QLPreviewController alloc]  init];
    self.previewController.dataSource  = self;
}
// 预览网络文件
- (void)previewInternet {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = self.url;
    NSString *fileName = [urlStr lastPathComponent]; //获取文件名称
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //判断是否存在
    if([self isFileExist:fileName]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        self.fileURL = url;
        [self presentViewController:self.previewController animated:YES completion:nil];
        //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
        [self.previewController refreshCurrentPreviewItem];
    }else {
        [SVProgressHUD showWithStatus:@"下载中"];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [SVProgressHUD dismiss];
            self.fileURL = filePath;
            [self presentViewController:self.previewController animated:YES completion:nil];
            //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
            [self.previewController refreshCurrentPreviewItem];
        }];
        [downloadTask resume];
    }
}

//判断文件是否已经在沙盒中存在
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

#pragma mark - QLPreviewControllerDataSource
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    return 1;
}


```

第三种：利用`PDFView`(系统框架`<PDFKit/PDFKit.h>`) 打开  
首先判断是否加载到本地，如果有直接加载本地的，如果没有就进行文件下载，然后加载文件：

> 注意⚠️：本框架在`iOS11.0+`后可用

```
-(void)setupPDF{
    
    self.pdfView = [[PDFView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight + 44, kScreenWidth, kScreenHeight - kNavBarAndStatusBarHeight - 44)];
    self.pdfView.autoScales = YES;
    self.pdfView.userInteractionEnabled = YES;
    [self.view addSubview:self.pdfView];
    
    if ([self.urlString isNoEmpty]) {
        self.sourceURL = [NSURL URLWithString:self.urlString];
    }else{
        return;
    }
    //路径作为缓存key
    _cacheFileKey = self.sourceURL.absoluteString;
    
    __weak __typeof(self) wself = self;
    _queryCacheOperation = [[WebCacheHelpler sharedWebCache] queryDataFromMemory:_cacheFileKey cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(hasCache) {
                wself.pdfDocument = [[PDFDocument alloc] initWithData:data];
                wself.pdfDocument.delegate = self;
                wself.pdfView.document = self.pdfDocument;
            }else{
                [wself startDownloadTask:_sourceURL isBackground:YES];
            }
        });
    }];
}

//开始资源下载任务
- (void)startDownloadTask:(NSURL *)URL isBackground:(BOOL)isBackground {
    __weak __typeof(self) wself = self;
    _queryCacheOperation = [[WebCacheHelpler sharedWebCache] queryDataFromMemory:_cacheFileKey cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(hasCache) {
                wself.pdfDocument = [[PDFDocument alloc] initWithData:data];
                wself.pdfDocument.delegate = self;
                wself.pdfView.document = self.pdfDocument;
                return;
            }
            
            if(wself.combineOperation != nil) {
                [wself.combineOperation cancel];
            }
            [WEHUD showWaitHUD];
            wself.combineOperation = [[WebDownloader sharedDownloader] downloadWithURL:URL responseBlock:^(NSHTTPURLResponse *response) {
                
            } progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, NSData *data) {
                
            } completedBlock:^(NSData *data, NSError *error, BOOL finished) {
                if(!error && finished) {
                    //下载完毕，将缓存数据保存到本地
                    [[WebCacheHelpler sharedWebCache] storeDataToDiskCache:data key:wself.cacheFileKey];
                }
                [WEHUD hideHUD];
                wself.pdfDocument = [[PDFDocument alloc] initWithData:data];
                wself.pdfDocument.delegate = self;
                wself.pdfView.document = self.pdfDocument;
            } cancelBlock:^{
                [WEHUD hideHUD];
                [WEHUD showWarningHUD:@"文件下载失败"];
            } isBackground:isBackground];
        });
    }];
}




```