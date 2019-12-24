import UIKit


/// `HttpInterceptor` is a tool that intercepts HTTP requests
/// It can intercept network requests for URLSession NSURLConnection
/// There are also network requests in UIWebView and WKWebView
/// But the POST request in the WKWebView cannot read the HTTPBody data
@objc public class HttpInterceptor: NSObject {
        
    /// If condition is nil all HTTP requests are intercepted
    @objc public var condition: HttpIntercepCondition? = nil
    
    /// Various stages of network request interception, including rewriting URLRequest, rewriting URLResponse, rewriting Data, request completion ...
    @objc public var delegate: HttpInterceptDelegate
    
    let identifier: String
    
    /// Create Interceptor instance
    ///
    /// - Parameter condition: Intercepting condition, default is nil all HTTP requests are intercepted
    /// - Parameter delegate: `HttpInterceptDelegate` delegate
    /// - Returns: `HttpInterceptor` Instance
    @objc public init(condition: HttpIntercepCondition? = nil,
         delegate: HttpInterceptDelegate) {
        self.identifier = UUID().uuidString
        self.delegate = delegate
        super.init()
        self.condition = condition
    }
    
    /// Interceptor register
    @objc public func register() {
        HTTPInterceptorProtocol.interceptorMap[self.identifier] = self
    }
    
    /// Interceptor unregister
    @objc public func unregister() {
        HTTPInterceptorProtocol.interceptorMap[self.identifier] = nil
    }
}
