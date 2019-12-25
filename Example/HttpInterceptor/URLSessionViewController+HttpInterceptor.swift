import Foundation
import BestHttpInterceptor

extension URLSessionViewController {
    
    func registerInterceptor() {
        let condition = HttpIntercepCondition(schemeType: .all) { (request) -> Bool in
            return true
        }
        interceptor = HttpInterceptor(condition: condition, delegate: self)
        interceptor?.register()
    }
    
    func interceptingHttpRequestDescription(request: URLRequest) -> String {
        
        var httpRequestURL: String?
        var requestHeader: String?
        var httpRequestBody: String?
        var httpRequestQueryString: String?
        
        
        if let urlStr = request.url?.absoluteString {
            httpRequestURL = urlStr
        }
        
        if let header = request.allHTTPHeaderFields {
            let jsonData = try! JSONSerialization.data(withJSONObject: header, options: [.prettyPrinted,.fragmentsAllowed])
            let headerStr = String.init(data: jsonData, encoding: String.Encoding.utf8)
            requestHeader = headerStr
        }
        
        if let body = request.interceptHttpBodyAsJSON() {
            httpRequestBody = "\(body)"
        }
        
        httpRequestQueryString = request.url?.query
        
        let result = """
        HTTP URL: \(httpRequestURL ?? "None")) \n
        HTTP AllHTTPHeaderFields: \(requestHeader ?? "None") \n
        HTTP RequestBody: \(httpRequestBody ?? "None") \n
        HTTP RequestQueryString: \(httpRequestQueryString ?? "None") \n
        """
        
        return result
    }
    
    func interceptingHttpResponseHeaderDescription(response: URLResponse) -> String {
        
        var httpResponseHeader: String?
        let httpResponse = response as! HTTPURLResponse
        let jsonData = try! JSONSerialization.data(withJSONObject: httpResponse.allHeaderFields, options: [.prettyPrinted,.fragmentsAllowed])
        let headerStr = String.init(data: jsonData, encoding: String.Encoding.utf8)
        httpResponseHeader = headerStr
        
        return httpResponseHeader ?? ""
    }
    
    func interceptingHttpResponseBodyDescription(data: Data) -> String {
        
        var httpResponseBody: String? = nil
        let bodyString = String(data: data, encoding: String.Encoding.utf8)
        httpResponseBody = bodyString
        
        return httpResponseBody ?? ""
    }
    
}

extension URLSessionViewController: HttpInterceptDelegate {
    
    func httpRequest(request: URLRequest) -> URLRequest {
        print("✅[成功拦截] HttpInterceptDelegate URLRequest:\n\(request)")
        print("✅[成功拦截] HttpInterceptDelegate QueryString:\n\(String(describing: request.url?.query))")
        if let body = request.interceptHttpBodyAsJSON() {
            print("✅[成功拦截] HttpInterceptDelegate HTTPBody:\n\(body)")
        }
        
        self.httpIntercepingRequest = interceptingHttpRequestDescription(request: request)
        return request
    }
    
    func httpRequest(response: URLResponse) -> URLResponse {
        print("✅[成功拦截] HttpInterceptDelegate URLResponse:\n\(response)")
        
        self.httpIntercepingResponseHeader = interceptingHttpResponseHeaderDescription(response: response)
        self.httpIntercepingStatusCode = HTTPURLResponse.localizedString(forStatusCode: (response as! HTTPURLResponse).statusCode)
        return response
    }
    
    func httpRequest(request: URLRequest, data: Data) -> Data {
        print("✅[成功拦截] HttpInterceptDelegate Data:\n\(data)")
        
        self.httpIntercepingResponseBody = interceptingHttpResponseBodyDescription(data: data)
        return data
    }
    
    func httpRequest(request: URLRequest, didCompleteWithError error: Error?) {
        print("✅[成功拦截] HttpInterceptDelegate didCompleteWithError:\n\(String(describing: error))")
    }
    
    func httpRequest(request: URLRequest, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("✅[成功拦截] HttpInterceptDelegate didFinishCollecting metrics:\n\(metrics)")
        self.httpIntercepingMetrics = "\(metrics)"
    }
    
}
