import UIKit


/// 作用范围:
/// 1.URLSession 2.NSURLConnection 3.WebKit
@objc public class HttpInterceptor: NSObject {
        
    /// 如果 nil ，全部拦截。
    public var condition: HttpIntercepCondition? = nil
    var delegate: HttpInterceptDelegate
    let identifier: String
    
    public init(condition: HttpIntercepCondition? = nil,
         delegate: HttpInterceptDelegate) {
        self.identifier = UUID().uuidString
        self.delegate = delegate
        super.init()
        self.condition = condition
    }
    
    public func register() {
        HTTPInterceptorProtocol.interceptorMap[self.identifier] = self
    }
    
    public func unregister() {
        HTTPInterceptorProtocol.interceptorMap[self.identifier] = nil
    }
}
