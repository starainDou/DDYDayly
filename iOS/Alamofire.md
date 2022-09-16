> ### Alamofire5 设置请求超时时间

* 通过自定义 requestModifier 实现

```
AF.request(strUrl, method: .get, parameters: paras, headers: nh,
                   requestModifier: { $0.timeoutInterval = UrlSetting.K_APP_REQUEST_TIME_OUT })
            .validate()
            .validate(contentType: UrlSetting.K_APP_ACCEPTABLE_CONTENTTYPES)
            .responseJSON { response in
                var msg:String? = response.error?.localizedDescription ?? ""
                print("请求结果：\(response)")
                if response.error != nil {
                    print(msg)
                }
                else{
                  print("请求成功")
                }
            }
```

* 通过自定义 URLRequest 实现

```
var request = URLRequest.init(url: URL.init(string: strUrl.urlEncoded())!)
        request.httpBody = body
        request.httpMethod = "PUT"
        request.timeoutInterval = UrlSetting.K_APP_REQUEST_TIME_OUT
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        if  let userLoginToken: String = UserDefaults.standard.value(forKey: Key.userLoginToken) as? String {
            request.setValue(userLoginToken, forHTTPHeaderField: UrlSetting.K_USER_TOKEN)
        }
        
        AF.request(request)
            .validate()
            .validate(contentType: UrlSetting.K_APP_ACCEPTABLE_CONTENTTYPES)
            .responseJSON { response in
           
                var msg:String? = response.error?.localizedDescription ?? ""
                print("请求结果：\(response)")
                if response.error != nil {
                    print(msg)
                }
                else{
                    print("请求成功")
                }
            }

```


* [Alamofire5 设置请求超时时间](https://blog.csdn.net/yimiyuangguang/article/details/118015999)
* [Alamofire（5）— Response](https://juejin.cn/post/6844903923224936455)
* 