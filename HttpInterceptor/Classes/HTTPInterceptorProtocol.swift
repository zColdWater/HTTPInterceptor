import UIKit

fileprivate let HTTPInterceptorProtocolKey = "HTTPInterceptorProtocolKey"

@objc public class HTTPInterceptorProtocol: URLProtocol {
    
    private var requestTask: URLSessionTask?
    static var interceptorMap: [String: HttpInterceptor] = [:]
    
    override public class func canInit(with request: URLRequest) -> Bool {
        return shouldHandle(request: request)
    }
    
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return handleRequest(request: request)
    }
    
    override public func startLoading() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        requestTask = session.dataTask(with: self.request)
        requestTask?.resume()
    }
    
    override public func stopLoading() {
        requestTask?.cancel()
    }
    
}

extension HTTPInterceptorProtocol {
    
    class func canInterceptRequest(request: URLRequest, interceptors: [HttpInterceptor]) -> Bool {
        guard let scheme = request.url?.scheme,
              let schemeType = HttpIntercepCondition.convertSchemeType(scheme: scheme) else { return false }
        for interceptor in interceptors {
            guard let condition = interceptor.condition else { return true }
            if schemeType == condition.interceptSchemeType || condition.interceptSchemeType == .all {
                if let match = condition.matchRequest, match(request) == true {
                    return true
                }
            } else {
                continue
            }
        }
        return false
    }
    
    class func matchInterceptor(request: URLRequest, matchingCallback:(HttpInterceptor)->Void) {
        for (_,interceptor) in HTTPInterceptorProtocol.interceptorMap {
            guard let condition = interceptor.condition else {
                matchingCallback(interceptor)
                continue
            }
            if let matcher = condition.matchRequest {
                let isCanMatch = matcher(request)
                if isCanMatch {
                    matchingCallback(interceptor)
                }
                continue
            } else {
                matchingCallback(interceptor)
                continue
            }
        }
    }
    
    class func shouldHandle(request: URLRequest) -> Bool {
        let interceptors = self.interceptorMap.map { (key,value) -> HttpInterceptor in
            return value
        }
        guard canInterceptRequest(request: request, interceptors: interceptors) == true else {
            return false
        }
        if let mark = URLProtocol.property(forKey: HTTPInterceptorProtocolKey, in: request) as? Bool, mark == true {
            return false
        } else {
            return true
        }
    }
    
    class func handleRequest(request: URLRequest) -> URLRequest {
        var finalRequest: URLRequest = request
        HTTPInterceptorProtocol.matchInterceptor(request: request) { interceptor in
            if let r = interceptor.delegate?.httpRequest?(request: request) {
                finalRequest = r
            }
        }
        guard let result = (finalRequest as NSURLRequest).mutableCopy() as? NSMutableURLRequest else { return finalRequest }
        URLProtocol.setProperty(true, forKey: HTTPInterceptorProtocolKey, in: result)
        return result as URLRequest
    }
}


extension HTTPInterceptorProtocol: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        // 如果有多个拦截器，同时拦截了这个response，返回最后设置拦截response。
        var newResponse = response
        HTTPInterceptorProtocol.matchInterceptor(request: self.request) { interceptor in
            if let httpResponse = interceptor.delegate?.httpRequest?(response: response) {
                newResponse = httpResponse
            }
        }
        self.client?.urlProtocol(self, didReceive: newResponse, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(request)
        self.client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        var newData: Data = data
        HTTPInterceptorProtocol.matchInterceptor(request: self.request) { interceptor in
            if let d = interceptor.delegate?.httpRequest?(request: self.request, data: data) {
                newData = d
            }
        }
        self.client?.urlProtocol(self, didLoad: newData)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        HTTPInterceptorProtocol.matchInterceptor(request: self.request) { interceptor in
            interceptor.delegate?.httpRequest?(request: self.request, didCompleteWithError: error)
        }
        if let e = error {
            self.client?.urlProtocol(self, didFailWithError: e)
        } else {
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
  
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let challengeWrapper = URLAuthenticationChallenge(authenticationChallenge: challenge, sender: HttpURLSessionChallengeSender(completionHandler: completionHandler))
        self.client?.urlProtocol(self, didReceive: challengeWrapper)
    }

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let challengeWrapper = URLAuthenticationChallenge(authenticationChallenge: challenge, sender: HttpURLSessionChallengeSender(completionHandler: completionHandler))
        self.client?.urlProtocol(self, didReceive: challengeWrapper)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        HTTPInterceptorProtocol.matchInterceptor(request: self.request) { interceptor in
            interceptor.delegate?.httpRequest?(request: self.request, didFinishCollecting: metrics)
        }
    }
    
}

extension URLRequest {

    func interceptHttpBodyAsData() -> Data? {
        guard let bodyStream = self.httpBodyStream else { return nil }
        bodyStream.open()
        let bufferSize: Int = 16
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        var dat: Data = Data()
        while bodyStream.hasBytesAvailable {
            let readDat = bodyStream.read(buffer, maxLength: bufferSize)
            dat.append(buffer, count: readDat)
        }
        buffer.deallocate()
        bodyStream.close()
        return dat
    }
    
     public func interceptHttpBodyAsJSON() -> Any? {
        var bodyData: Data? = nil
        if let data = interceptHttpBodyAsData() {
            bodyData = data
        }
        if let data = self.httpBody {
            bodyData = data
        }
        guard let d = bodyData else {
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: d, options: [.allowFragments, .mutableContainers])
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
