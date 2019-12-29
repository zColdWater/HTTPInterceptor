import Foundation


class SessionManager: NSObject {
    
    typealias CompleteCallBack = () -> Void
    typealias Response = (String?) -> Void
    
    var complete: CompleteCallBack?
    var didReviceResponse: Response?
    var didReviceData: Response?
    
    deinit {
        print("SessionManager deinit")
    }
}

extension SessionManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("[SessionManager] URLSessionDelegate didBecomeInvalidWithError:\(String(describing: error))")
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling,nil)
        print("[SessionManager] URLSessionDelegate didReceive challenge:\(challenge)")
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("[SessionManager] URLSessionDelegate forBackgroundURLSession session:\(session)")
    }
}


extension SessionManager: URLSessionTaskDelegate {
    
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        print("[SessionManager] URLSessionTaskDelegate willBeginDelayedRequest")
    }

    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("[SessionManager] URLSessionTaskDelegate taskIsWaitingForConnectivity")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(request)
        print("[SessionManager] URLSessionTaskDelegate willPerformHTTPRedirection")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        print("[SessionManager] URLSessionTaskDelegate needNewBodyStream")
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("[SessionManager] URLSessionTaskDelegate didSendBodyData bytesSent")
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics){
        print("[SessionManager] URLSessionTaskDelegate didFinishCollecting metrics")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        complete?()
        print("[SessionManager] URLSessionTaskDelegate didCompleteWithError")
    }
}


extension SessionManager: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let httpResponse = response as! HTTPURLResponse
        let jsonData = try! JSONSerialization.data(withJSONObject: httpResponse.allHeaderFields, options: [.prettyPrinted,.fragmentsAllowed])
        let headerStr = String.init(data: jsonData, encoding: String.Encoding.utf8)
        didReviceResponse?(headerStr)
        completionHandler(.allow)
        print("[URLSessionViewController] URLSessionDataDelegate didReceive response")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        print("[URLSessionViewController] URLSessionDataDelegate didBecome downloadTask")
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        print("[URLSessionViewController] URLSessionDataDelegate didBecome streamTask")
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let bodyString = String(data: data, encoding: String.Encoding.utf8)
        didReviceData?(bodyString)
        print("[URLSessionViewController] URLSessionDataDelegate didReceive data")
    }

//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
//        print("[URLSessionViewController] URLSessionDataDelegate willCacheResponse proposedResponse")
//    }
}


extension SessionManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("[URLSessionViewController] URLSessionDownloadDelegate didFinishDownloadingTo location:\(location)")
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("[URLSessionViewController] URLSessionDownloadDelegate totalBytesWritten:\(totalBytesWritten)")
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("[URLSessionViewController] URLSessionDownloadDelegate expectedTotalBytes:\(expectedTotalBytes)")
    }
}
