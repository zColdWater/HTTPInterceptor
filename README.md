# HttpInterceptor

[![CI Status](https://img.shields.io/travis/1486297824@qq.com/HttpInterceptor.svg?style=flat)](https://travis-ci.org/1486297824@qq.com/HttpInterceptor)
[![Version](https://img.shields.io/cocoapods/v/HttpInterceptor.svg?style=flat)](https://cocoapods.org/pods/HttpInterceptor)
[![License](https://img.shields.io/cocoapods/l/HttpInterceptor.svg?style=flat)](https://cocoapods.org/pods/HttpInterceptor)
[![Platform](https://img.shields.io/cocoapods/p/HttpInterceptor.svg?style=flat)](https://cocoapods.org/pods/HttpInterceptor)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

<img src="http://47.99.237.180:2088/files/21c6bccc5dc85983e73c09794dd48a75" width="40" height="40" />


## Usage

1.Register Intercept Rules
```swift
import HttpInterceptor

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
    
}
```


## Requirements

iOS 10+

## Installation

HttpInterceptor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HttpInterceptor'
```

## Author

zColdWater

## License

HttpInterceptor is available under the MIT license. See the LICENSE file for more info.
