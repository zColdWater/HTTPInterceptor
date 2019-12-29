![HTTPInterceptor: intercepting http/https request](http://47.99.237.180:2088/files/6a93b4a10761a6fd68b482ba27947c35)

[![CI Status](https://img.shields.io/badge/build-success-green)](https://travis-ci.org/1486297824@qq.com/HttpInterceptor)
[![Version](https://img.shields.io/badge/pod-v1.0.1-green)](https://cocoapods.org/pods/HttpInterceptor)
[![Language Version](https://img.shields.io/badge/swift-4.2-orange)](https://cocoapods.org/pods/HttpInterceptor)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://cocoapods.org/pods/HttpInterceptor)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey)](https://cocoapods.org/pods/HttpInterceptor)


项目有在调用苹果私有api，为了拦截WKWebView发出去的网络请求，但是方法名已经使用Base64进行了编码，为了防止苹果静态扫描和检查，所以存在一定架风险，请大家合理利用，最安全还是在Debug下，开发中使用。   

The project is calling apple private api, in order to intercept the WKWebView sent to the network request, but the api signature has been encoded in Base64, in order to prevent apple static scanning and inspection, so there is a certain risk, please reasonable use, the most secure or in the Debug, the development of the use. 🙏🙏

如果HTTPInterceptor对你有帮助，给楼主一个小星星✨是对楼主最好的支持和动力。   
如果有疑问，欢迎来提issue，你们的提问是对楼主最好的反馈。

If it helps you, plesae give the project a little stars ✨ is the best support for me.
If you have any questions, please submit issue for me. Your issues are the best feedback for me.

## About HTTPInterceptor
新:  我为HTTPInterceptor新增了 Mock Data 的功能，API 非常简单清晰，使用非常方便。
I've added Mock Data functionality to Interceptor, and the API is simple and clear. It's very easy to use.

HTTPInterceptor 是一个iOS网络请求拦截器，它可以拦截基于`URLSession`和`NSURLConnection`发出的HTTP(s)请求。
对于已经使用过URLProtocol的项目来说，如果`HTTPInterceptor`和其他`URLProtocol` Handle的URL一样，就要看注入的先后顺序。

1. 你可以使用它去拦截一个特定的request，然后返回一个新的request，意味着你可以改变它访问的目标地址和参数等等。
2. 你可以使用它去拦截一个特定的request，然后返回一个新的`URLResponse`和`Data`，意味着你可以返回一个自定义Response，比如Mock数据等操作。
3. 你可以使用它去拦截一个特定的request，然后返回一个`URLSessionTaskMetrics`，意味着你可以得到这个Request创建的请求Task的性能指标，比如创建Task，DNSLookup，Establish链接，各项指标，用于数据上报等。

HTTPInterceptor is an iOS network request interceptor that intercepts HTTP(s) requests made by URLSession and NSURLConnection.

1. You can intercept a specific request and return a new one.
2. It can intercept a specific request and return a specific response and data.
3. It can also intercept a specific request and callback the URLSessionTaskMetrics object.

## About WKWebView
HTTPInterceptor 虽然可以拦截WKWebView中的网络请求，但是却无法得到`POST`请求的`HTTPBody`。
因为去拦截WKWebView中的网络请求，HTTPInterceptor 使用了苹果私有API，这是不安全的，也是不应该的，但是如果你是`Debug`下使用它，这就另当别论了。 

关于如何得到，WKWebView中`POST`请求的`HTTPBody`，我看了一些文章。
例如: WKWebView注入JS脚本，JS脚本Hook所有的`XHR`和`Fetch`网络请求，然后再通过Native和Web通信通道，比如在WK容器中，JS使用`alert`方法，`prompt`方法，都可以将JS侧的内容发送给Native，Native解析传来的内容，解析出类名，方法签名，参数等等，在Runtime下创建对象调用去保存，等等。

可以看到的是这样的逻辑实在有些麻烦，而且需要考虑的东西非常多，因为你是`Hook`了JS的请求入口，这是一个block操作，稍有不慎就会给H5带来线上灾难，而且全部是因为要拿一个`HTTPBody`，所以我认为这是非常不值得的， 为了程序的鲁棒性也不应该使用这样的实现。 

Fetching HTTPBody using HTTPInterceptor is not supported.


## About Name
The `HttpInterceptor` name is taken by someone else, so use `BestHttpInterceptor`.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


### 一，Mock Data (Mock数据)
<div>
<img style="float: left;" src="http://47.99.237.180:2088/files/bf930163e01042dec34541ee6bb0d317" width="200" height="400" />

<img style="float: left;" src="http://47.99.237.180:2088/files/46b81ac98c69a9f13f2ec381e1da2a8e" width="200" height="400" />

<img style="float: left;" src="http://47.99.237.180:2088/files/b15d01f6096bbfe8a5421bfcc5452b12" width="200" height="400" />

<img style="float: left;" src="http://47.99.237.180:2088/files/c410db7a84b276cfe814cf9e383dc8f2" width="200" height="400" />

<img style="float: left;" src="http://47.99.237.180:2088/files/55be78d072a15b6d4cab4759fe83d2be" width="200" height="400" />

<img style="float: left;" src="http://47.99.237.180:2088/files/908e1d787e225e9866b0dce2cd656903" width="200" height="400" />

<img style="float: left;" src="http://47.99.237.180:2088/files/781f82e14f3ab0cf2e1770f7fffb5369" width="200" height="400" />

</div>

1.注册拦截条件
```swift
import BestHttpInterceptor
let jsonURL: URL = URL(string: "https://mocker.example.com/json?arg1=1234567890")!

class MockerTemplateViewController: UIViewController {
    
    var interceptor: HttpInterceptor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerInterceptor()
        doTask()
    }
    
    deinit {
        print("MockerTemplateViewController deinit")
        interceptor.unregister()
    }
    
    func registerInterceptor() {
        let condition = HttpIntercepCondition.init(schemeType: .all) { (request) -> Bool in
            if let url = request.url, URLS.contains(url) {
                return true
            }
            return false
        }
        interceptor = HttpInterceptor(condition: condition, mockerDelegate: self)
        interceptor.register()
    }
    
    func doTask() {
        URLSession.shared.dataTask(with: jsonURL) { (data, response, error) in
            if let e = error {
                print("e:\(e)")
            } else {
                let jsonStr = String(data: data!, encoding: .utf8)
                DispatchQueue.main.async {
                    self.contentLabel.text = jsonStr
                }
            }
        }.resume()
    }
}
```

2.实现 **HttpMockerDelegate** 代理
```swift
extension MockerTemplateViewController: HttpMockerDelegate {
    func httpMocker(request: URLRequest) -> HttpMocker {
        guard let url = request.url else { fatalError() }
        switch url {
        case jsonURL:
            let jsonUrl = Bundle(for: MockerTemplateViewController.self).url(forResource: "mock_json", withExtension: "json")!
            let mocker = HttpMocker(dataType: .json, mockData: jsonUrl.data, statusCode: 200, httpVer: .http1_1)
            return mocker
        default:
            fatalError()
        }        
    }
}
```

### 二，Intercept Request (拦截请求)

<div>
<img style="float: left;" src="http://47.99.237.180:2088/files/eb14aeb76f4261f66502eec0a86108ee" width="200" height="400" />

<img style="float: left;" src="http://47.99.237.180:2088/files/21c6bccc5dc85983e73c09794dd48a75" width="200" height="400" />

<img style="float: left;" src="http://47.99.237.180:2088/files/0426219c13311c0e680fed353c8da725" width="200" height="400" />

<img style="float: left;" src="http://47.99.237.180:2088/files/8b2e4a9d43903b2aa8ff9d6ff3dba111" width="200" height="400" />
</div>

1.注册拦截条件
```swift
import UIKit
import WebKit
import BestHttpInterceptor

class WKViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    var interceptor: HttpInterceptor? = nil
    
    enum PathExtension: String {
        case gif = "gif"
        case png = "png"
        case jpeg = "jpeg"
        case svg = "svg"
        case jpg = "jpg"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WKWebViewController"
        
        registerInterceptor()
        
        let url = URL(string: "https://www.baidu.com/")
        webview.load(URLRequest(url: url!))
    }
    
    func registerInterceptor() {
        // 定义拦截条件，根据URLRequest参数来进行判断，是否需要拦截此Request，返回Bool告诉HTTPInterceptor。
        let condition = HttpIntercepCondition(schemeType: .all) { (request) -> Bool in
            
            // 拦截逻辑，这里是要拦截host带有ss和timgmb和结尾是 gif，jpeg，png，svg，jpg的Request。
            // 大家可以根据自己的需求来定义这个条件。
            guard let pathExtensionStr = request.url?.pathExtension,
                  let host = request.url?.host else {
                return false
            }
            if host.contains("ss") || host.contains("timgmb") {
                return true
            }
            let pathExtension = WKViewController.PathExtension(rawValue: pathExtensionStr)
            switch pathExtension {
            case .gif,.jpeg,.png,.svg,.jpg:
                return true
            case .none:
                return false
            }
            
        }
        interceptor = HttpInterceptor(condition: condition, interceptorDelegate: self)
        
        // 开始注册
        interceptor?.register()
    }
    
    deinit {
        print("WKViewController deinit")
        // 取消注册
        interceptor?.unregister()
    }
    
}
```

2.实现 **HttpInterceptDelegate** 代理
```swift
extension WKViewController: HttpInterceptDelegate {
    // Replace Request URL
    func httpRequest(request: URLRequest) -> URLRequest {
        // 将拦截到的Request，换成我们新的Request。 
        var newRequest = request
        newRequest.url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577182928067&di=4a039119f074e775880d33ee7589e556&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170307%2Fc1529f8154f949ef83abee83f6d5ece7.jpg")!
        return newRequest
    }    
}
```

## Features

- [x] WKWebView, UIWebView, URLSession, URLConnection, all network http(s) requests can be intercepted.
- [x] Cannot intercept HTTPBody in WKWebView Post request.
- [x] Custom filter URLRequest.
- [x] Can intercept and replace URLRequest, URLResponse, Data.

## Usage


### 一，Mock Data (Mock数据)
1.Define intercept condition
```swift
let condition = HttpIntercepCondition(schemeType: .all) { (request) -> Bool in
    return true
}
```

2.New a interceptor instance
```swift
let interceptor = HttpInterceptor(condition: condition, mockerDelegate: self)
```

3.Start register
```swift
interceptor.register()
```

4.Cancel register
```swift
interceptor.unregister()
```

5.Implement `HttpMockerDelegate` delegate,  callback to you
```swift
extension MockerTemplateViewController: HttpMockerDelegate {

    // 例子
    // Example
    func httpMocker(request: URLRequest) -> HttpMocker {
        let jsonUrl = Bundle(for: MockerTemplateViewController.self).url(forResource: "mock_json", withExtension: "json")!
        let mocker = HttpMocker(dataType: .json, mockData: jsonUrl.data, statusCode: 200, httpVer: .http1_1)
        return mocker
    }
}
```


### 二，Intercept Request (拦截请求)

1.Define intercept condition
```swift
let condition = HttpIntercepCondition(schemeType: .all) { (request) -> Bool in
    return true
}
```

2.New a interceptor instance
```swift
let interceptor = HttpInterceptor(condition: condition, interceptorDelegate: self)
```

3.Start register
```swift
interceptor.register()
```

4.Cancel register
```swift
interceptor.unregister()
```

5.Implement `HttpInterceptorDelegate` delegate,  callback to you
```swift
extension SomeClass: HttpInterceptDelegate {
    
    // Intercept http request then return a new request 
    func httpRequest(request: URLRequest) -> URLRequest {
        return request
    }
    
    // Intercept http response then return a new response 
    func httpRequest(response: URLResponse) -> URLResponse {
        return response
    }
    
    // Intercept http response data then return a new response data
    func httpRequest(request: URLRequest, data: Data) -> Data {
        return data
    }
    
    // When the request is complete call this api
    func httpRequest(request: URLRequest, didCompleteWithError error: Error?) {
    }
    
    func httpRequest(request: URLRequest, didFinishCollecting metrics: URLSessionTaskMetrics) {
    }
}
```


## Requirements

iOS 10+

## Installation

HttpInterceptor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby

pod 'BestHttpInterceptor'

```

if you want use it with Debug 

```ruby

pod 'BestHttpInterceptor',:configurations => ['Debug'] 

```

## Author

zColdWater

## License

HttpInterceptor is available under the MIT license. See the LICENSE file for more info.
