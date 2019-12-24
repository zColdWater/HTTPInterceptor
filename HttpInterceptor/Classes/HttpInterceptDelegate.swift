import UIKit

/// `HttpInterceptDelegate` Intercept delegate
/// Various stages of network request interception, including rewriting URLRequest, rewriting URLResponse, rewriting Data, request completion ...
/// `HttpInterceptDelegate` 拦截器代理
/// `Delegate` 会在拦截这个请求的生命周期内给外面回调，可以重写 URLRequest，URLResponse，Data 等。
@objc public protocol HttpInterceptDelegate {
    
    /// intercept `urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics)` method
    /// 拦截 `urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics)` 时给外层回调。
    @objc optional func httpRequest(request: URLRequest, didFinishCollecting metrics: URLSessionTaskMetrics)
    
    /// intercept `canonicalRequest(for request: URLRequest) -> URLRequest`，Use the return value for the request
    /// 拦截 `canonicalRequest(for request: URLRequest) -> URLRequest` 时给外层回调，使用返回值的URLRequest作为请求的Request。
    @objc optional func httpRequest(request: URLRequest) -> URLRequest
    
    /// intercept `urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) `，Use the return value for the response
    /// 拦截 `urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)` 时给外层回调，使用返回值的URLResponse作为请求的Response。
    @objc optional func httpRequest(response: URLResponse) -> URLResponse
    
    /// intercept ` urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)` method, Use the return value for the data
    /// 拦截 ` urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)` 时给外层回调，使用返回值的Data作为请求的Data。
    @objc optional func httpRequest(request: URLRequest, data: Data) -> Data
    
    /// intercept `urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)` method
    /// 拦截 `urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)` 时给外面回调。
    @objc optional func httpRequest(request: URLRequest, didCompleteWithError error: Error?)

}
