> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [www.jianshu.com](https://www.jianshu.com/p/325b8d200114)

从一个函数说起

```
    NSSet *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        if (completionHandler) {
            completionHandler();
        }
    }];


```

```
/*! @abstract Removes all website data of the given types that has been modified since the given date.
 @param dataTypes The website data types that should be removed.
 @param date A date. All website data modified after this date will be removed.
 @param completionHandler A block to invoke when the website data has been removed.
*/
- (void)removeDataOfTypes:(NSSet<NSString *> *)dataTypes modifiedSince:(NSDate *)date completionHandler:(void (^)(void))completionHandler;


```

这个函数是 WKWebsiteDataStore 的 WKWebView 的一个内存清理函数，dataTypes 表示需要清理的类型，date 表示修改时间，清理在这个修改时间之后的缓存，completionHandler 是回调函数。这次主要来看一下 dataTypes 里都有什么类型的缓存。**本文较长，有需要的可以先看结论**。  
dataTypes 主要包含 WKWebsiteDataRecord 里定义的几种缓存类型：

```
/*! @constant WKWebsiteDataTypeFetchCache On-disk Fetch caches. */
WK_EXTERN NSString * const WKWebsiteDataTypeFetchCache API_AVAILABLE(macos(10.13.4), ios(11.3));

/*! @constant WKWebsiteDataTypeDiskCache On-disk caches. */
WK_EXTERN NSString * const WKWebsiteDataTypeDiskCache API_AVAILABLE(macos(10.11), ios(9.0));

/*! @constant WKWebsiteDataTypeMemoryCache In-memory caches. */
WK_EXTERN NSString * const WKWebsiteDataTypeMemoryCache API_AVAILABLE(macos(10.11), ios(9.0));

/*! @constant WKWebsiteDataTypeOfflineWebApplicationCache HTML offline web application caches. */
WK_EXTERN NSString * const WKWebsiteDataTypeOfflineWebApplicationCache API_AVAILABLE(macos(10.11), ios(9.0));

/*! @constant WKWebsiteDataTypeCookies Cookies. */
WK_EXTERN NSString * const WKWebsiteDataTypeCookies API_AVAILABLE(macos(10.11), ios(9.0));

/*! @constant WKWebsiteDataTypeSessionStorage HTML session storage. */
WK_EXTERN NSString * const WKWebsiteDataTypeSessionStorage API_AVAILABLE(macos(10.11), ios(9.0));

/*! @constant WKWebsiteDataTypeLocalStorage HTML local storage. */
WK_EXTERN NSString * const WKWebsiteDataTypeLocalStorage API_AVAILABLE(macos(10.11), ios(9.0));

/*! @constant WKWebsiteDataTypeWebSQLDatabases WebSQL databases. */
WK_EXTERN NSString * const WKWebsiteDataTypeWebSQLDatabases API_AVAILABLE(macos(10.11), ios(9.0));

/*! @constant WKWebsiteDataTypeIndexedDBDatabases IndexedDB databases. */
WK_EXTERN NSString * const WKWebsiteDataTypeIndexedDBDatabases API_AVAILABLE(macos(10.11), ios(9.0));

/*! @constant WKWebsiteDataTypeServiceWorkerRegistrations Service worker registrations. */
WK_EXTERN NSString * const WKWebsiteDataTypeServiceWorkerRegistrations API_AVAILABLE(macos(10.13.4), ios(11.3));


```

打开 webKit 源码 (源码下载 [https://webkit.org/getting-the-code/](https://links.jianshu.com/go?to=https%3A%2F%2Fwebkit.org%2Fgetting-the-code%2F))，看一看 removeDataOfTypes 如果传入不同类型的缓存，清理结果是怎样的。。  
先把上述缓存类型和源码中 WebsiteDataType 中的类型对应起来

```
//WKWebsiteDataRecordInternal.h
static inline std::optional<WebsiteDataType> toWebsiteDataType(NSString *websiteDataType)
{
    if ([websiteDataType isEqualToString:WKWebsiteDataTypeCookies])
        return WebsiteDataType::Cookies;
    if ([websiteDataType isEqualToString:WKWebsiteDataTypeFetchCache])
        return WebsiteDataType::DOMCache;
    if ([websiteDataType isEqualToString:WKWebsiteDataTypeDiskCache])
        return WebsiteDataType::DiskCache;
    if ([websiteDataType isEqualToString:WKWebsiteDataTypeMemoryCache])
        return WebsiteDataType::MemoryCache;
    if ([websiteDataType isEqualToString:WKWebsiteDataTypeOfflineWebApplicationCache])
        return WebsiteDataType::OfflineWebApplicationCache;
    if ([websiteDataType isEqualToString:WKWebsiteDataTypeSessionStorage])
        return WebsiteDataType::SessionStorage;
    if ([websiteDataType isEqualToString:WKWebsiteDataTypeLocalStorage])
        return WebsiteDataType::LocalStorage;
    if ([websiteDataType isEqualToString:WKWebsiteDataTypeWebSQLDatabases])
        return WebsiteDataType::WebSQLDatabases;
    if ([websiteDataType isEqualToString:WKWebsiteDataTypeIndexedDBDatabases])
        return WebsiteDataType::IndexedDBDatabases;
#if ENABLE(SERVICE_WORKER)
    if ([websiteDataType isEqualToString:WKWebsiteDataTypeServiceWorkerRegistrations])
        return WebsiteDataType::ServiceWorkerRegistrations;
#endif
    if ([websiteDataType isEqualToString:_WKWebsiteDataTypeHSTSCache])
        return WebsiteDataType::HSTSCache;
    if ([websiteDataType isEqualToString:_WKWebsiteDataTypeMediaKeys])
        return WebsiteDataType::MediaKeys;
    if ([websiteDataType isEqualToString:_WKWebsiteDataTypeSearchFieldRecentSearches])
        return WebsiteDataType::SearchFieldRecentSearches;
    if ([websiteDataType isEqualToString:_WKWebsiteDataTypeResourceLoadStatistics])
        return WebsiteDataType::ResourceLoadStatistics;
    if ([websiteDataType isEqualToString:_WKWebsiteDataTypeCredentials])
        return WebsiteDataType::Credentials;
    if ([websiteDataType isEqualToString:_WKWebsiteDataTypeAdClickAttributions])
        return WebsiteDataType::PrivateClickMeasurements;
    if ([websiteDataType isEqualToString:_WKWebsiteDataTypePrivateClickMeasurements])
        return WebsiteDataType::PrivateClickMeasurements;
#if HAVE(CFNETWORK_ALTERNATIVE_SERVICE)
    if ([websiteDataType isEqualToString:_WKWebsiteDataTypeAlternativeServices])
        return WebsiteDataType::AlternativeServices;
#endif
    return std::nullopt;
}


```

WKWebsiteDataRecord 里只提供了前十种，以下缓存清理的步骤中也只讨论这 10 种类型，即 WebsiteDataType::Cookies, WebsiteDataType::DOMCache,WebsiteDataType::DiskCache,WebsiteDataType::MemoryCache,WebsiteDataType::OfflineWebApplicationCache,WebsiteDataType::SessionStorage,WebsiteDataType::LocalStorage,WebsiteDataType::WebSQLDatabases,WebsiteDataType::IndexedDBDatabases,WebsiteDataType::ServiceWorkerRegistrations，其他类型的源码暂时不去探究，以下粘贴源码时会做模糊处理。

以下代码是调用 removeDataOfTypes:modifiedSince:completionHandler: 的源码：

```
- (void)removeDataOfTypes:(NSSet *)dataTypes modifiedSince:(NSDate *)date completionHandler:(void (^)(void))completionHandler
{
    auto completionHandlerCopy = makeBlockPtr(completionHandler);
    _websiteDataStore->removeData(WebKit::toWebsiteDataTypes(dataTypes), toSystemClockTime(date ? date : [NSDate distantPast]), [completionHandlerCopy] {
        completionHandlerCopy();
    });
}

//跳转到websiteDataStore.cpp
void WebsiteDataStore::removeData(OptionSet<WebsiteDataType> dataTypes, WallTime modifiedSince, Function<void()>&& completionHandler)
{
    auto callbackAggregator = RemovalCallbackAggregator::create(*this, WTFMove(completionHandler));

#if ENABLE(VIDEO)
    if (dataTypes.contains(WebsiteDataType::DiskCache)) {
        m_queue->dispatch([modifiedSince, mediaCacheDirectory = m_configuration->mediaCacheDirectory().isolatedCopy(), callbackAggregator] {
            WebCore::HTMLMediaElement::clearMediaCache(mediaCacheDirectory, modifiedSince);
        });
    }
#endif

#if ENABLE(INTELLIGENT_TRACKING_PREVENTION)
    bool didNotifyNetworkProcessToDeleteWebsiteData = false;
#endif
    auto networkProcessAccessType = computeNetworkProcessAccessTypeForDataRemoval(dataTypes, !isPersistent());
    switch (networkProcessAccessType) {
    case ProcessAccessType::Launch:
        networkProcess();
        ASSERT(m_networkProcess);
        FALLTHROUGH;
    case ProcessAccessType::OnlyIfLaunched:
        if (m_networkProcess) {
            m_networkProcess->deleteWebsiteData(m_sessionID, dataTypes, modifiedSince, [callbackAggregator] { });
#if ENABLE(INTELLIGENT_TRACKING_PREVENTION)
            didNotifyNetworkProcessToDeleteWebsiteData = true;
#endif
        }
        break;
    case ProcessAccessType::None:
        break;
    }

    auto webProcessAccessType = computeWebProcessAccessTypeForDataRemoval(dataTypes, !isPersistent());
    if (webProcessAccessType != ProcessAccessType::None) {
        for (auto& processPool : processPools()) {
            // Clear back/forward cache first as processes removed from the back/forward cache will likely
            // be added to the WebProcess cache.
            processPool->backForwardCache().removeEntriesForSession(sessionID());
            processPool->webProcessCache().clearAllProcessesForSession(sessionID());
        }

        for (auto& process : processes()) {
            switch (webProcessAccessType) {
            case ProcessAccessType::OnlyIfLaunched:
                if (process.state() != WebProcessProxy::State::Running)
                    continue;
                break;

            case ProcessAccessType::Launch:
                // FIXME: Handle this.
                ASSERT_NOT_REACHED();
                break;

            case ProcessAccessType::None:
                ASSERT_NOT_REACHED();
            }

            process.deleteWebsiteData(m_sessionID, dataTypes, modifiedSince, [callbackAggregator] { });
        }
    }

    ...

    if (dataTypes.contains(WebsiteDataType::OfflineWebApplicationCache) && isPersistent()) {
        m_queue->dispatch([applicationCacheDirectory = m_configuration->applicationCacheDirectory().isolatedCopy(), applicationCacheFlatFileSubdirectoryName = m_configuration->applicationCacheFlatFileSubdirectoryName().isolatedCopy(), callbackAggregator] {
            auto storage = WebCore::ApplicationCacheStorage::create(applicationCacheDirectory, applicationCacheFlatFileSubdirectoryName);
            storage->deleteAllCaches();
        });
    }

    if (dataTypes.contains(WebsiteDataType::WebSQLDatabases) && isPersistent()) {
        m_queue->dispatch([webSQLDatabaseDirectory = m_configuration->webSQLDatabaseDirectory().isolatedCopy(), callbackAggregator, modifiedSince] {
            WebCore::DatabaseTracker::trackerWithDatabasePath(webSQLDatabaseDirectory)->deleteDatabasesModifiedSince(modifiedSince);
        });
    }
     /*
          省略其余类型缓存处理
     */
#endif
}


```

根据代码逻辑，这里分成四部分去探究。

### Part_1

```
#if ENABLE(VIDEO)
    if (dataTypes.contains(WebsiteDataType::DiskCache)) {
        m_queue->dispatch([modifiedSince, mediaCacheDirectory = m_configuration->mediaCacheDirectory().isolatedCopy(), callbackAggregator] {
            WebCore::HTMLMediaElement::clearMediaCache(mediaCacheDirectory, modifiedSince);
        });
    }
#endif


```

这一部分清理的是临时文件中的 video 缓存。首先探究 WebCore::HTMLMediaElement::clearMediaCache，以下是源码，按顺序跟着代码一起跳转。。。

```
//HTMLMediaElement.cpp
void HTMLMediaElement::clearMediaCache(const String& path, WallTime modifiedSince)
{
    MediaPlayer::clearMediaCache(path, modifiedSince);
}
//MediaPlayer.cpp
void MediaPlayer::clearMediaCache(const String& path, WallTime modifiedSince)
{
    for (auto& engine : installedMediaEngines())
        engine->clearMediaCache(path, modifiedSince);
}
这里要找到MediaEgines实例，installedMediaEngines()里返回的都是父类的class，最终捋着代码找到子类。
//MediaPlayerPrivateAVFoundationObjC.mm
void MediaPlayerPrivateAVFoundationObjC::clearMediaCache(const String& path, WallTime modifiedSince)
{
    AVAssetCache* assetCache = assetCacheForPath(path);
    if (!assetCache)
        return;
    
    for (NSString *key in [assetCache allKeys]) {
        if (toSystemClockTime([assetCache lastModifiedDateOfEntryForKey:key]) > modifiedSince)
            [assetCache removeEntryForKey:key];
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *baseURL = [assetCache URL];

    if (modifiedSince <= WallTime::fromRawSeconds(0)) {
        [fileManager removeItemAtURL:baseURL error:nil];
        return;
    }
    
    NSArray *propertyKeys = @[NSURLNameKey, NSURLContentModificationDateKey, NSURLIsRegularFileKey];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:baseURL includingPropertiesForKeys:
        propertyKeys options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
        errorHandler:nil];
    
    RetainPtr<NSMutableArray> urlsToDelete = adoptNS([[NSMutableArray alloc] init]);
    for (NSURL *fileURL : enumerator) {
        NSDictionary *fileAttributes = [fileURL resourceValuesForKeys:propertyKeys error:nil];
    
        if (![fileAttributes[NSURLNameKey] hasPrefix:@"CachedMedia-"])
            continue;
        
        if (![fileAttributes[NSURLIsRegularFileKey] boolValue])
            continue;
        
        if (toSystemClockTime(fileAttributes[NSURLContentModificationDateKey]) <= modifiedSince)
            continue;
        
        [urlsToDelete addObject:fileURL];
    }
    
    for (NSURL *fileURL in urlsToDelete.get())
        [fileManager removeItemAtURL:fileURL error:nil];
}


```

可以看到这里清理了 path 中符合时间条件的文件。至于 path 表示哪里，从

```
//WebsiteDataStoreCocoa.mm
String WebsiteDataStore::defaultMediaCacheDirectory()
{
    return tempDirectoryFileSystemRepresentation("MediaCache");
}


```

可以得知，path 指的是 tmp 里的 MediaCache 文件夹，经检验，具体位置为 沙盒目录 / tmp/WebKit/MediaCache

Part_2
------

```
#if ENABLE(INTELLIGENT_TRACKING_PREVENTION)
    bool didNotifyNetworkProcessToDeleteWebsiteData = false;
#endif
    auto networkProcessAccessType = computeNetworkProcessAccessTypeForDataRemoval(dataTypes, !isPersistent());
    switch (networkProcessAccessType) {
    case ProcessAccessType::Launch:
        networkProcess();
        ASSERT(m_networkProcess);
        FALLTHROUGH;
    case ProcessAccessType::OnlyIfLaunched:
        if (m_networkProcess) {
            m_networkProcess->deleteWebsiteData(m_sessionID, dataTypes, modifiedSince, [callbackAggregator] { });
#if ENABLE(INTELLIGENT_TRACKING_PREVENTION)
            didNotifyNetworkProcessToDeleteWebsiteData = true;
#endif
        }
        break;
    case ProcessAccessType::None:
        break;
    }

    auto webProcessAccessType = computeWebProcessAccessTypeForDataRemoval(dataTypes, !isPersistent());
    if (webProcessAccessType != ProcessAccessType::None) {
        for (auto& processPool : processPools()) {
            // Clear back/forward cache first as processes removed from the back/forward cache will likely
            // be added to the WebProcess cache.
            processPool->backForwardCache().removeEntriesForSession(sessionID());
            processPool->webProcessCache().clearAllProcessesForSession(sessionID());
        }

        for (auto& process : processes()) {
            switch (webProcessAccessType) {
            case ProcessAccessType::OnlyIfLaunched:
                if (process.state() != WebProcessProxy::State::Running)
                    continue;
                break;

            case ProcessAccessType::Launch:
                // FIXME: Handle this.
                ASSERT_NOT_REACHED();
                break;

            case ProcessAccessType::None:
                ASSERT_NOT_REACHED();
            }

            process.deleteWebsiteData(m_sessionID, dataTypes, modifiedSince, [callbackAggregator] { });
        }
    }


```

这里就要结合 computeNetworkProcessAccessTypeForDataRemoval 函数去看

```
//WebsiteDataStore.cpp
static ProcessAccessType computeNetworkProcessAccessTypeForDataRemoval(OptionSet<WebsiteDataType> dataTypes, bool isNonPersistentStore)
{
    ProcessAccessType processAccessType = ProcessAccessType::None;

    for (auto dataType : dataTypes) {
        if (dataType == WebsiteDataType::Cookies) {
            if (isNonPersistentStore)
                processAccessType = std::max(processAccessType, ProcessAccessType::OnlyIfLaunched);
            else
                processAccessType = std::max(processAccessType, ProcessAccessType::Launch);
        } else if (WebsiteData::ownerProcess(dataType) == WebsiteDataProcessType::Network)
            return ProcessAccessType::Launch;
    }
    
    return processAccessType;
}


```

这里，满足条件的执行 m_networkProcess->deleteWebsiteData: 这个函数源码如下：

```
//NetworkProcess.cpp
void NetworkProcess::deleteWebsiteData(PAL::SessionID sessionID, OptionSet<WebsiteDataType> websiteDataTypes, WallTime modifiedSince, CompletionHandler<void()>&& completionHandler)
{
    ...
    ...

    if (websiteDataTypes.contains(WebsiteDataType::Cookies)) {
        if (auto* networkStorageSession = storageSession(sessionID))
            networkStorageSession->deleteAllCookiesModifiedSince(modifiedSince);
    }

    /*
        省略部分源码
   */

    auto clearTasksHandler = WTF::CallbackAggregator::create(WTFMove(completionHandler));

    if (websiteDataTypes.contains(WebsiteDataType::DOMCache))
        CacheStorage::Engine::clearAllCaches(*this, sessionID, [clearTasksHandler] { });

    if (websiteDataTypes.contains(WebsiteDataType::SessionStorage) && m_storageManagerSet->contains(sessionID))
        m_storageManagerSet->deleteSessionStorage(sessionID, [clearTasksHandler] { });

    if (websiteDataTypes.contains(WebsiteDataType::LocalStorage) && m_storageManagerSet->contains(sessionID))
        m_storageManagerSet->deleteLocalStorageModifiedSince(sessionID, modifiedSince, [clearTasksHandler] { });

    if (websiteDataTypes.contains(WebsiteDataType::IndexedDBDatabases) && !sessionID.isEphemeral())
        webIDBServer(sessionID).closeAndDeleteDatabasesModifiedSince(modifiedSince, [clearTasksHandler] { });

#if ENABLE(SERVICE_WORKER)
    bool clearServiceWorkers = websiteDataTypes.contains(WebsiteDataType::DOMCache) || websiteDataTypes.contains(WebsiteDataType::ServiceWorkerRegistrations);
    if (clearServiceWorkers && !sessionID.isEphemeral())
        swServerForSession(sessionID).clearAll([clearTasksHandler] { });
#endif

    ...
    ...

    if (auto* networkSession = this->networkSession(sessionID))
        networkSession->removeNetworkWebsiteData(modifiedSince, std::nullopt, [clearTasksHandler] { });

    if (websiteDataTypes.contains(WebsiteDataType::DiskCache) && !sessionID.isEphemeral())
        clearDiskCache(modifiedSince, [clearTasksHandler] { });
    ...
    ...
}


```

这里我们也只看上述提到的 10 种类型的处理。先看一下 networkStorageSession->deleteAllCookiesModifiedSince 都做了什么

```
//NetworkStorageSessionCocoa.mm
void NetworkStorageSession::deleteAllCookiesModifiedSince(WallTime timePoint)
{
    ASSERT(hasProcessPrivilege(ProcessPrivilege::CanAccessRawCookies));

    if (![NSHTTPCookieStorage instancesRespondToSelector:@selector(removeCookiesSinceDate:)])
        return;

    NSTimeInterval timeInterval = timePoint.secondsSinceEpoch().seconds();
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];

    auto *storage = nsCookieStorage();

    [storage removeCookiesSinceDate:date];
    [storage _saveCookies];
}


```

其中关键部分 storage 是引用 #import <pal/spi/cf/CFNetworkSPI.h> 中的 NSHTTPCookieStorage 对象，目前来看这部分为黑盒部分，无法追究是删除哪些文件，相关文档参考 [https://developer.apple.com/documentation/foundation/nshttpcookiestorage/1407256-removecookiessincedate](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.apple.com%2Fdocumentation%2Ffoundation%2Fnshttpcookiestorage%2F1407256-removecookiessincedate)  
再来看一下 CacheStorage::Engine::clearAllCaches 这个函数在做什么

```
//CacheStorageEngine.cpp
void Engine::clearAllCaches(CompletionHandler<void()>&& completionHandler)
{
    ASSERT(RunLoop::isMain());

    auto callbackAggregator = CallbackAggregator::create([this, completionHandler = createClearTask(WTFMove(completionHandler))]() mutable {
        if (!this->shouldPersist())
            return completionHandler();
        
        this->clearAllCachesFromDisk(WTFMove(completionHandler));
    });

    for (auto& caches : m_caches.values())
        caches->clear([callbackAggregator] { });
}

void Engine::clearAllCachesFromDisk(CompletionHandler<void()>&& completionHandler)
{
    ASSERT(RunLoop::isMain());

    m_ioQueue->dispatch([path = m_rootPath.isolatedCopy(), completionHandler = WTFMove(completionHandler)]() mutable {
        Locker locker { globalSizeFileLock };
        for (auto& fileName : FileSystem::listDirectory(path)) {
            auto filePath = FileSystem::pathByAppendingComponent(path, fileName);
            if (FileSystem::fileType(filePath) == FileSystem::FileType::Directory)
                FileSystem::deleteNonEmptyDirectory(filePath);
        }
        RunLoop::main().dispatch(WTFMove(completionHandler));
    });
}

//CacheStorageEngineCaches.cpp
void Caches::clear(CompletionHandler<void()>&& completionHandler)
{
    if (m_isWritingCachesToDisk) {
        m_pendingWritingCachesToDiskCallbacks.append([this, completionHandler = WTFMove(completionHandler)] (auto&& error) mutable {
            this->clear(WTFMove(completionHandler));
        });
        return;
    }

    auto pendingCallbacks = WTFMove(m_pendingInitializationCallbacks);
    for (auto& callback : pendingCallbacks)
        callback(Error::Internal);

    if (m_engine)
        m_engine->removeFile(cachesListFilename(m_rootPath));
    if (m_storage) {
        m_storage->clear(String { }, -WallTime::infinity(), [protectedThis = Ref { *this }, completionHandler = WTFMove(completionHandler)]() mutable {
            ASSERT(RunLoop::isMain());
            protectedThis->clearMemoryRepresentation();
            completionHandler();
        });
        return;
    }
    clearMemoryRepresentation();
    clearPendingWritingCachesToDiskCallbacks();
    completionHandler();
}
//CacheStorageEngine.cpp
void Engine::removeFile(const String& filename)
{
    if (!shouldPersist())
        return;

    m_ioQueue->dispatch([filename = filename.isolatedCopy()]() mutable {
        FileSystem::deleteFile(filename);
    });
}


```

这里看到 Engine::clearAllCachesFromDisk 和 Engine::removeFile，删除的应该是 / Library/Caches/WebKit/CacheStorage 里面的文件（还有待进一步探究）  
接下来再看 m_storageManagerSet->deleteSessionStorage: 都清理了什么，从源码继续追踪：

```
//StorageManagerSet.cpp
void StorageManagerSet::deleteSessionStorage(PAL::SessionID sessionID, DeleteCallback&& completionHandler)
{
    ASSERT(RunLoop::isMain());

    m_queue->dispatch([this, protectedThis = Ref { *this }, sessionID, completionHandler = WTFMove(completionHandler)]() mutable {
        auto* storageManager = m_storageManagers.get(sessionID);
        ASSERT(storageManager);

        storageManager->deleteSessionStorageOrigins();
        RunLoop::main().dispatch(WTFMove(completionHandler));
    });
}
//StorageManager.cpp  这里是/NetworkProcess/WebStorage/StorageManager.cpp
void StorageManager::deleteSessionStorageOrigins()
{
    ASSERT(!RunLoop::isMain());

    for (auto& sessionStorageNamespace : m_sessionStorageNamespaces.values())
        sessionStorageNamespace->clearAllStorageAreas();
}
//SessionStorageNamespace.cpp
void SessionStorageNamespace::clearAllStorageAreas()
{
    ASSERT(!RunLoop::isMain());
    for (auto& storageArea : m_storageAreaMap.values())
        storageArea->clear();
}
//StorageArea.cpp
void StorageArea::clear()
{
    ASSERT(!RunLoop::isMain());
    if (isEphemeral())
        m_sessionStorageMap->clear();
    else {
        if (m_localStorageDatabase) {
            m_localStorageDatabase->close();
            m_localStorageDatabase = nullptr;
        }
    }

    for (auto& listenerUniqueID : m_eventListeners)
        IPC::Connection::send(listenerUniqueID, Messages::StorageAreaMap::ClearCache(), m_identifier.toUInt64());
}
//StorageMap.cpp
void StorageMap::clear()
{
    if (m_impl->refCount() > 1 && length()) {
        m_impl = Impl::create();
        return;
    }
    m_impl->map.clear();
    m_impl->currentSize = 0;
    invalidateIterator();
}
这里m_impl的数据结构如下
struct Impl : public RefCounted<Impl> {
        static Ref<Impl> create()
        {
            return adoptRef(*new Impl);
        }

        Ref<Impl> copy() const;

        HashMap<String, String> map;
        HashMap<String, String>::iterator iterator { map.end() };
        unsigned iteratorIndex { std::numeric_limits<unsigned>::max() };
        unsigned currentSize { 0 };
    };
//清理完缓存StorageMap的缓存，还要执行Messages::StorageAreaMap::ClearCache()
//StorageAreaMap.cpp
void StorageAreaMap::clearCache()
{
    resetValues();
}
void StorageAreaMap::resetValues()
{
    m_map = nullptr;

    m_pendingValueChanges.clear();
    m_hasPendingClear = false;
    ++m_currentSeed;
}
//这里的m_pendingValueChanges是一个hash表结构。


```

到这里，WebsiteDataType::SessionStorage 类型也就清理完了，没有涉及到文件的操作，是对内存变量进行的清理动作。  
对于 WebsiteDataType::LocalStorage 类型，进行 m_storageManagerSet->deleteLocalStorageModifiedSince: 函数，直接上源码：

```
//StorageManagerSet.cpp
void StorageManagerSet::deleteLocalStorageModifiedSince(PAL::SessionID sessionID, WallTime time, DeleteCallback&& completionHandler)
{
    ASSERT(RunLoop::isMain());

    m_queue->dispatch([this, protectedThis = Ref { *this }, sessionID, time, completionHandler = WTFMove(completionHandler)]() mutable {
        auto* storageManager = m_storageManagers.get(sessionID);
        ASSERT(storageManager);

        storageManager->deleteLocalStorageOriginsModifiedSince(time);
        RunLoop::main().dispatch(WTFMove(completionHandler));
    });
}
//StorageManager.cpp  这里是/NetworkProcess/WebStorage/StorageManager.cpp
void StorageManager::deleteLocalStorageOriginsModifiedSince(WallTime time)
{
    ASSERT(!RunLoop::isMain());

    if (m_localStorageDatabaseTracker) {
        auto originsToDelete = m_localStorageDatabaseTracker->databasesModifiedSince(time);

        for (auto& transientLocalStorageNamespace : m_transientLocalStorageNamespaces.values())
            transientLocalStorageNamespace->clearAllStorageAreas();

        for (const auto& origin : originsToDelete) {
            for (auto& localStorageNamespace : m_localStorageNamespaces.values())
                localStorageNamespace->clearStorageAreasMatchingOrigin(origin);
            m_localStorageDatabaseTracker->deleteDatabaseWithOrigin(origin);
        }
    } else {
        for (auto& localStorageNamespace : m_localStorageNamespaces.values())
            localStorageNamespace->clearAllStorageAreas();
    }
}

//这里 transientLocalStorageNamespace->clearAllStorageAreas();localStorageNamespace->clearStorageAreasMatchingOrigin(origin);同样是对内存进行清理
//LocalStorageDatabaseTracker.cpp  这里是这里是/NetworkProcess/WebStorage/LocalStorageDatabaseTracker.cpp
void LocalStorageDatabaseTracker::deleteDatabaseWithOrigin(const SecurityOriginData& securityOrigin)
{
    auto path = databasePath(securityOrigin);
    if (!path.isEmpty())
        SQLiteFileSystem::deleteDatabaseFile(path);

    // FIXME: Tell clients that the origin was removed.
}
//这里通过databasePath获取path，源码就不放了。再接着看另个一分支中localStorageNamespace->clearAllStorageAreas();
//LocalStorageNamespace.cpp
void LocalStorageNamespace::clearAllStorageAreas()
{
    ASSERT(!RunLoop::isMain());
    for (auto& storageArea : m_storageAreaMap.values())
        storageArea->clear();
}
//这里仍然是对内存进行清理，不涉及文件。


```

最终由 databasePath: 找到文件清理的位置

```
String WebsiteDataStore::defaultLocalStorageDirectory()
{
    return websiteDataDirectoryFileSystemRepresentation("LocalStorage");
}


```

所以 WebsiteDataType::LocalStorage 类型清理的文件位置在 / Library/WebKit/WebsitData/LocalStorage 。好了，继续找下一个类型 WebsiteDataType::IndexedDBDatabases，按惯例，继续追踪源码 webIDBServer(sessionID).closeAndDeleteDatabasesModifiedSince:

```
//WebIDBServer.cpp
void WebIDBServer::closeAndDeleteDatabasesModifiedSince(WallTime modificationTime, CompletionHandler<void()>&& callback)
{
    ASSERT(RunLoop::isMain());

    postTask([this, protectedThis = Ref { *this }, modificationTime, callback = WTFMove(callback)]() mutable {
        ASSERT(!RunLoop::isMain());

        Locker locker { m_serverLock };
        m_server->closeAndDeleteDatabasesModifiedSince(modificationTime);
        postTaskReply([callback = WTFMove(callback)]() mutable {
            callback();
        });
    });
}
//IDBServer.cpp
void IDBServer::closeAndDeleteDatabasesModifiedSince(WallTime modificationTime)
{
    ASSERT(!isMainThread());
    ASSERT(m_lock.isHeld());

    // If the modification time is in the future, don't both doing anything.
    if (modificationTime > WallTime::now())
        return;

    HashSet<UniqueIDBDatabase*> openDatabases;
    for (auto& database : m_uniqueIDBDatabaseMap.values())
        database->immediateClose();

    m_uniqueIDBDatabaseMap.clear();

    if (!m_databaseDirectoryPath.isEmpty()) {
        removeDatabasesModifiedSinceForVersion(modificationTime, "v0");
        removeDatabasesModifiedSinceForVersion(modificationTime, "v1");
    }
}


```

这个函数很 "清晰的" 表示了先关闭数据库句柄，清理内存，最终清理 m_databaseDirectoryPath 的缓存文件，通过以下函数获取 m_databaseDirectoryPath 位置

```
String WebsiteDataStore::defaultIndexedDBDatabaseDirectory()
{
    return websiteDataDirectoryFileSystemRepresentation("IndexedDB");
}


```

所以 WebsiteDataType::IndexedDBDatabases 类型清理的文件位置在 / Library/WebKit/WebsitData/IndexedDB 这里有两个文件夹 v0 和 v1，一起都清理掉。让我们继续往下探究 WebsiteDataType::DOMCache 类型，继续看 swServerForSession(sessionID).clearAll: 源码：

```
//SWServer
void SWServer::clearAll(CompletionHandler<void()>&& completionHandler)
{
    if (!m_importCompleted) {
        m_clearCompletionCallbacks.append([this, completionHandler = WTFMove(completionHandler)] () mutable {
            ASSERT(m_importCompleted);
            clearAll(WTFMove(completionHandler));
        });
        return;
    }

    m_jobQueues.clear();
    while (!m_registrations.isEmpty())
        m_registrations.begin()->value->clear();
    m_pendingContextDatas.clear();
    m_originStore->clearAll();
    if (m_registrationStore)
        m_registrationStore->clearAll(WTFMove(completionHandler));
}
//这里m_registrations.begin()->value->clear()进行的操作是将安装/等待/活跃的SWServerWorker全都中止，停止DOM的一切行为后，清理内存。在进行SQL文件的清理
//RegistrationDatabase.cpp
void RegistrationDatabase::clearAll(CompletionHandler<void()>&& completionHandler)
{
    postTaskToWorkQueue([this, completionHandler = WTFMove(completionHandler)]() mutable {
        m_database = nullptr;
        m_scriptStorage = nullptr;

        SQLiteFileSystem::deleteDatabaseFile(m_databaseFilePath);
        FileSystem::deleteNonEmptyDirectory(scriptStorageDirectory());
        SQLiteFileSystem::deleteEmptyDatabaseDirectory(databaseDirectoryIsolatedCopy());

        callOnMainThread(WTFMove(completionHandler));
    });
}


```

最终确定删除的 SQL 文件在 / Library/WebKit/WebsitData/WebSQL 好了，继续探究 WebsiteDataType::DiskCache，它在 NetworkProcess::deleteWebsiteData: 里的清理函数是 NetworkProcess::clearDiskCache: 看一下这个函数的源码：

```
//NetworkProcessCocoa.mm
void NetworkProcess::clearDiskCache(WallTime modifiedSince, CompletionHandler<void()>&& completionHandler)
{
    if (!m_clearCacheDispatchGroup)
        m_clearCacheDispatchGroup = adoptOSObject(dispatch_group_create());

    auto group = m_clearCacheDispatchGroup.get();
    dispatch_group_async(group, dispatch_get_main_queue(), makeBlockPtr([this, protectedThis = Ref { *this }, modifiedSince, completionHandler = WTFMove(completionHandler)] () mutable {
        auto aggregator = CallbackAggregator::create(WTFMove(completionHandler));
        forEachNetworkSession([modifiedSince, &aggregator](NetworkSession& session) {
            if (auto* cache = session.cache())
                cache->clear(modifiedSince, [aggregator] () { });
        });
    }).get());
}

//NetworkCache.cpp
void Cache::clear(WallTime modifiedSince, Function<void()>&& completionHandler)
{
    LOG(NetworkCache, "(NetworkProcess) clearing cache");

    String anyType;
    m_storage->clear(anyType, modifiedSince, WTFMove(completionHandler));

    deleteDumpFile();
}
//NetworkCacheStorage.cpp
void Storage::clear(const String& type, WallTime modifiedSinceTime, CompletionHandler<void()>&& completionHandler)
{
    ASSERT(RunLoop::isMain());
    LOG(NetworkCacheStorage, "(NetworkProcess) clearing cache");

    if (m_recordFilter)
        m_recordFilter->clear();
    if (m_blobFilter)
        m_blobFilter->clear();
    m_approximateRecordsSize = 0;

    ioQueue().dispatch([this, protectedThis = Ref { *this }, modifiedSinceTime, completionHandler = WTFMove(completionHandler), type = type.isolatedCopy()] () mutable {
        auto recordsPath = this->recordsPathIsolatedCopy();
        traverseRecordsFiles(recordsPath, type, [modifiedSinceTime](const String& fileName, const String& hashString, const String& type, bool isBlob, const String& recordDirectoryPath) {
            auto filePath = FileSystem::pathByAppendingComponent(recordDirectoryPath, fileName);
            if (modifiedSinceTime > -WallTime::infinity()) {
                auto times = fileTimes(filePath);
                if (times.modification < modifiedSinceTime)
                    return;
            }
            FileSystem::deleteFile(filePath);
        });

        deleteEmptyRecordsDirectories(recordsPath);

        // This cleans unreferenced blobs.
        m_blobStorage.synchronize();

        RunLoop::main().dispatch(WTFMove(completionHandler));
    });
}



```

这里可以看到清理的是 path/Records 和 path/Blobs 文件夹，这里 path 是 baseDirectoryPath + Version X，baseDirectoryPath 可以根据源码：

```
String WebsiteDataStore::defaultNetworkCacheDirectory()
{
    return cacheDirectoryFileSystemRepresentation("NetworkCache");
}


```

可以看出 WebsiteDataType::DiskCache 所清理的文件夹是 / Library/Caches/WebKit/NetworkCache/Version 16(根据系统版本决定是 16 还是其他)/Records 和 Blobs。Part_2 到此结束。。。

Part_3
------

```
if (dataTypes.contains(WebsiteDataType::OfflineWebApplicationCache) && isPersistent()) {
        m_queue->dispatch([applicationCacheDirectory = m_configuration->applicationCacheDirectory().isolatedCopy(), applicationCacheFlatFileSubdirectoryName = m_configuration->applicationCacheFlatFileSubdirectoryName().isolatedCopy(), callbackAggregator] {
            auto storage = WebCore::ApplicationCacheStorage::create(applicationCacheDirectory, applicationCacheFlatFileSubdirectoryName);
            storage->deleteAllCaches();
        });
    }


```

这里就比较简单了，直接看删除的源码，主要是在 storage->deleteAllCaches() 中进行：

```
//ApplicationCacheStorage.cpp
void ApplicationCacheStorage::deleteAllCaches()
{
    auto origins = originsWithCache();
    for (auto& origin : origins)
        deleteCacheForOrigin(origin);

    vacuumDatabaseFile();
}


```

// 这里主要是两步，第一个清理内存 deleteCacheForOrigin: 第二步是清理文件 vacuumDatabaseFile:

```
//ApplicationCacheStorage.cpp
void ApplicationCacheStorage::vacuumDatabaseFile()
{
    SQLiteTransactionInProgressAutoCounter transactionCounter;

    openDatabase(false);
    if (!m_database.isOpen())
        return;

    m_database.runVacuumCommand();
}
//SQLiteDatabase.cpp
int SQLiteDatabase::runVacuumCommand()
{
    if (!executeCommand("VACUUM;"_s))
        LOG(SQLDatabase, "Unable to vacuum database - %s", lastErrorMsg());
    return lastError();
}


```

这里最终清理的是 目录是 m_configuration->applicationCacheDirectory().isolatedCopy()，根据源码：

```
//WebsiteDataStoreConfiguration.cpp
setApplicationCacheDirectory(WebsiteDataStore::defaultApplicationCacheDirectory());
//WebsiteDataStoreCocoa.mm
String WebsiteDataStore::defaultApplicationCacheDirectory()
{
#if PLATFORM(IOS_FAMILY)
    // This quirk used to make these apps share application cache storage, but doesn't accomplish that any more.
    // Preserving it avoids the need to migrate data when upgrading.
    // FIXME: Ideally we should just have Safari, WebApp, and webbookmarksd create a data store with
    // this application cache path.
    if (WebCore::IOSApplication::isMobileSafari() || WebCore::IOSApplication::isWebBookmarksD()) {
        NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.apple.WebAppCache"];

        return WebKit::stringByResolvingSymlinksInPath(cachePath.stringByStandardizingPath);
    }
#endif

    return cacheDirectoryFileSystemRepresentation("OfflineWebApplicationCache");
}


```

可以看出，如果是苹果 iOS 的浏览器 Safari，则清理目录是 Library/Caches/com.apple.WebAppCache，其他则是 /Library/Caches/WebKit/OfflineWebApplicationCache

Part_4
------

```
if (dataTypes.contains(WebsiteDataType::WebSQLDatabases) && isPersistent()) {
        m_queue->dispatch([webSQLDatabaseDirectory = m_configuration->webSQLDatabaseDirectory().isolatedCopy(), callbackAggregator, modifiedSince] {
            WebCore::DatabaseTracker::trackerWithDatabasePath(webSQLDatabaseDirectory)->deleteDatabasesModifiedSince(modifiedSince);
        });
    }


```

这里删除的是 WebSQL 数据，以下是删除的源码：

```
void DatabaseTracker::deleteDatabasesModifiedSince(WallTime time)
{
    for (auto& origin : origins()) {
        Vector<String> databaseNames = this->databaseNames(origin);
        Vector<String> databaseNamesToDelete;
        databaseNamesToDelete.reserveInitialCapacity(databaseNames.size());
        for (const auto& databaseName : databaseNames) {
            auto fullPath = fullPathForDatabase(origin, databaseName, false);

            // If the file doesn't exist, we previously deleted it but failed to remove the information
            // from the tracker database. We want to delete all of the information associated with this
            // database from the tracker database, so still add its name to databaseNamesToDelete.
            if (FileSystem::fileExists(fullPath)) {
                auto modificationTime = FileSystem::fileModificationTime(fullPath);
                if (!modificationTime)
                    continue;

                if (modificationTime.value() < time)
                    continue;
            }

            databaseNamesToDelete.uncheckedAppend(databaseName);
        }

        if (databaseNames.size() == databaseNamesToDelete.size())
            deleteOrigin(origin);
        else {
            for (const auto& databaseName : databaseNamesToDelete)
                deleteDatabase(origin, databaseName);
        }
    }
}


```

删除的路径则是 m_configuration->webSQLDatabaseDirectory().isolatedCopy()，可以从源码中得出该路径：

```
//WebsiteDataStoreConfiguration.cpp
setWebSQLDatabaseDirectory(WebsiteDataStore::defaultWebSQLDatabaseDirectory());
//WebsiteDataStoreCocoa.mm
String WebsiteDataStore::defaultWebSQLDatabaseDirectory()
{
    return websiteDataDirectoryFileSystemRepresentation("WebSQL");
}


```

可以看到 WebsiteDataType::WebSQLDatabases 该类型最终清理的目录是 /Library/WebKit/WebsiteData/WebSQL 目录。  
好了，到这里 WKWebsiteDataRecord 展示的十种缓存类型就都处理完了~~。

结论
--

WKWebsiteDataTypeFetchCache 是先停止 DOM 的一切行为，清理内存后，再清理 / Library/WebKit/WebsitData/WebSQL 中的文件。

WKWebsiteDataTypeDiskCache 先清理 / tmp/WebKit/MediaCache 目录下缓存的 Media 文件，再清理 / Library/Caches/WebKit/NetworkCache/Version 16(根据系统版本决定是 16 还是其他)/Records 和 Blobs 中的文件。

WKWebsiteDataTypeMemoryCache 是清理内存里的内容，以及触发别的缓存类型的清理。

WKWebsiteDataTypeOfflineWebApplicationCache 先是清理内存的相关内容，接着清理文件，如果是苹果 iOS 的浏览器 Safari，则清理目录是 Library/Caches/com.apple.WebAppCache，其他则是 /Library/Caches/WebKit/OfflineWebApplicationCache

WKWebsiteDataTypeCookies 和 WKWebsiteDataTypeMemoryCache 相似，先是清理内存里的相关内容，然后触发别的缓存类型的清理。

WKWebsiteDataTypeSessionStorage 没有涉及到文件的操作，是对内存变量进行的清理动作。

WKWebsiteDataTypeLocalStorage 清理的是 / Library/WebKit/WebsitData/LocalStorage 中的文件。

WKWebsiteDataTypeWebSQLDatabases 清理的是 /Library/WebKit/WebsiteData/WebSQL 中的文件。

WKWebsiteDataTypeIndexedDBDatabases 清理的文件位置在 / Library/WebKit/WebsitData/IndexedDB 这里有两个文件夹 v0 和 v1，一起都清理掉。

WKWebsiteDataTypeServiceWorkerRegistrations 和 WKWebsiteDataTypeFetchCache 行为类似，不再赘述。