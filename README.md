![HTTPInterceptor: intercepting http/https request](http://47.99.237.180:2088/files/6a93b4a10761a6fd68b482ba27947c35)

[![CI Status](https://img.shields.io/badge/build-success-green)](https://travis-ci.org/1486297824@qq.com/HttpInterceptor)
[![Version](https://img.shields.io/badge/pod-v1.0.1-green)](https://cocoapods.org/pods/HttpInterceptor)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://cocoapods.org/pods/HttpInterceptor)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey)](https://cocoapods.org/pods/HttpInterceptor)


项目有在调用苹果私有api，为了拦截WKWebView发出去的网络请求，但是方法名已经使用Base64进行了编码，为了防止苹果静态扫描和检查，所以存在一定架风险，请大家合理利用，最安全还是在Debug下，开发中使用。   

The project is calling apple private api, in order to intercept the WKWebView sent to the network request, but the api signature has been encoded in Base64, in order to prevent apple static scanning and inspection, so there is a certain risk, please reasonable use, the most secure or in the Debug, the development of the use. 🙏🙏

如果HTTPInterceptor对你有帮助，给楼主一个小星星✨是对楼主最好的支持和动力。   
如果有疑问，欢迎来提issue，你们的提问是对楼主最好的反馈。

If it helps you, plesae give the project a little stars ✨ is the best support for me.
If you have any questions, please submit issue for me. Your issues are the best feedback for me.

## About HTTPInterceptor
HTTPInterceptor is an iOS network request interceptor that intercepts HTTP(s) requests made by URLSession and NSURLConnection.

1. You can intercept a specific request and return a new one.
2. It can intercept a specific request and return a specific response and data.
3. It can also intercept a specific request and callback the URLSessionTaskMetrics object.

HTTPInterceptor 是一个iOS网络请求拦截器，它可以拦截基于URLSession和NSURLConnection发出的HTTP(s)请求。

1. 你可以使用它去拦截一个特定的request，然后返回一个新的request，意味着你可以改变它访问的目标地址和参数等等。
2. 你可以使用它去拦截一个特定的request，然后返回一个新的URLResponse和Data，意味着你可以返回一个自定义Response，比如Mock数据等操作。
3. 你可以使用它去拦截一个特定的request，然后返回一个URLSessionTaskMetrics，意味着你可以得到这个Request创建的请求Task的性能指标，比如创建Task，DNSLookup，Establish链接，各项指标，用于数据上报等。

## About Name
The `HttpInterceptor` name is taken by someone else, so use `BestHttpInterceptor`.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

<div>
<img style="float: left;" src="http://47.99.237.180:2088/files/f689553368e1ced61ce4c1932757f71a" width="200" height="400" />

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
        interceptor = HttpInterceptor(condition: condition, delegate: self)
        
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

1.Define intercept condition
```swift
let condition = HttpIntercepCondition(schemeType: .all) { (request) -> Bool in
    return true
}
```

2.New a interceptor instance
```swift
let interceptor = HttpInterceptor(condition: condition, delegate: self)    
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

## Author

zColdWater

## License

HttpInterceptor is available under the MIT license. See the LICENSE file for more info.
