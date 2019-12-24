import UIKit

/// `HttpInterceptDelegate` 拦截代理
@objc public protocol HttpInterceptDelegate {
    
    /// 拦截 `urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics)` 方法
    @objc optional func httpRequest(request: URLRequest, didFinishCollecting metrics: URLSessionTaskMetrics)
    
    /// 拦截 URLRequest，网络请求以返回的URLRequest为准。
    @objc optional func httpRequest(request: URLRequest) -> URLRequest
    
    /// 拦截URLResponse，网络请求以返回的URLResponse为准。
    @objc optional func httpRequest(response: URLResponse) -> URLResponse
    
    /// 拦截ReceiveData，可以返回自定义的Data。
    @objc optional func httpRequest(request: URLRequest, data: Data) -> Data
    
    /// 拦截DidCompleteWithError，用于得知网络请求已经完成。
    @objc optional func httpRequest(request: URLRequest, didCompleteWithError error: Error?)

}

