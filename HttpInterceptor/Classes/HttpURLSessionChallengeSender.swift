class HttpURLSessionChallengeSender: NSObject, URLAuthenticationChallengeSender {
    
    var sessionCompletionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    
    init(completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        sessionCompletionHandler = completionHandler
        super.init()
    }
    
    func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) {
        sessionCompletionHandler(.useCredential, credential)
    }
    
    func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {
        sessionCompletionHandler(.useCredential, nil)
    }
    
    func cancel(_ challenge: URLAuthenticationChallenge) {
        sessionCompletionHandler(.cancelAuthenticationChallenge, nil)
    }
    
    func performDefaultHandling(for challenge: URLAuthenticationChallenge) {
        sessionCompletionHandler(.performDefaultHandling, nil)
    }
    
    func rejectProtectionSpaceAndContinue(with challenge: URLAuthenticationChallenge) {
        sessionCompletionHandler(.rejectProtectionSpace, nil)
    }
    
}
