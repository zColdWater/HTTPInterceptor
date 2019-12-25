![HTTPInterceptor: intercepting http/https request](http://47.99.237.180:2088/files/6a93b4a10761a6fd68b482ba27947c35)

[![CI Status](https://img.shields.io/badge/build-success-green)](https://travis-ci.org/1486297824@qq.com/HttpInterceptor)
[![Version](https://img.shields.io/badge/pod-v1.0.1-green)](https://cocoapods.org/pods/HttpInterceptor)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://cocoapods.org/pods/HttpInterceptor)
[![Platform](https://img.shields.io/badge/platform-ios-gray)](https://cocoapods.org/pods/HttpInterceptor)

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

## Usage

1.Register Intercept Rules
```swift
import BestHttpInterceptor

enum PathExtension: String {
     case gif = "gif"
     case png = "png"
     case jpeg = "jpeg"
     case svg = "svg"
     case jpg = "jpg"
 }

let condition = HttpIntercepCondition(schemeType: .all) { (request) -> Bool in
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
interceptor?.register()
```

2.Implement **HttpInterceptDelegate** Delegate
```swift
extension WKViewController: HttpInterceptDelegate {
    // Replace Request URL
    func httpRequest(request: URLRequest) -> URLRequest {
        var newRequest = request
        newRequest.url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577182928067&di=4a039119f074e775880d33ee7589e556&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170307%2Fc1529f8154f949ef83abee83f6d5ece7.jpg")!
        return newRequest
    }
    
    func httpRequest(response: URLResponse) -> URLResponse {
        return response
    }
    
    func httpRequest(request: URLRequest, data: Data) -> Data {
        return data
    }
    
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
