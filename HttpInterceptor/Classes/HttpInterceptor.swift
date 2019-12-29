/// `HttpInterceptor` is a tool that intercepts HTTP requests
/// It can intercept network requests for URLSession NSURLConnection
/// There are also network requests in UIWebView and WKWebView
/// But the POST request in the WKWebView cannot read the HTTPBody data
@objc public class HttpInterceptor: NSObject {
        
    /// If condition is nil all HTTP requests are intercepted
    @objc var condition: HttpIntercepCondition? = nil
    
    /// Various stages of network request interception, including rewriting URLRequest, rewriting URLResponse, rewriting Data, request completion ...
    @objc weak var interceptorDelegate: HttpInterceptDelegate?
    
    /// If `HttpMockerDelegate` and `HttpInterceptDelegate` intercept the same Request at the same time, the `HttpMockerDelegate` is used without calling back the `HttpInterceptDelegate`
    /// 如果 `HttpMockerDelegate` 和 `HttpInterceptDelegate` 同时拦截了一个request，以`HttpMockerDelegate`为主，不给予`HttpInterceptDelegate`回调。
    @objc weak var mockerDelegate: HttpMockerDelegate?
    
    let identifier: String
    
    /// Create Interceptor instance
    ///
    /// - Parameter condition: Intercepting condition, default is nil all HTTP requests are intercepted
    /// - Parameter interceptorDelegate: `HttpInterceptDelegate` delegate
    /// - Returns: `HttpInterceptor` Instance
    @objc public init(condition: HttpIntercepCondition? = nil,
                      interceptorDelegate: HttpInterceptDelegate) {
        self.identifier = UUID().uuidString
        self.interceptorDelegate = interceptorDelegate
        super.init()
        self.condition = condition
    }
    
    /// Create Interceptor instance
    ///
    /// - Parameter condition: Intercepting condition, default is nil all HTTP requests are intercepted
    /// - Parameter mockerDelegate: `HttpMockerDelegate` delegate
    /// - Returns: `HttpInterceptor` Instance
    @objc public init(condition: HttpIntercepCondition? = nil,
                      mockerDelegate: HttpMockerDelegate) {
        self.identifier = UUID().uuidString
        self.mockerDelegate = mockerDelegate
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
