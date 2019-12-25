import UIKit
import BestHttpInterceptor

class URLSessionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let identifier = "TableViewIdentifier"
    let sectionHeader: [ContentType] = [.httpRequestHeader,.httpRequestQueryString,.httpRequestBody,.httpResponseHeader,.httpResponseBody,.httpReuestURL,.httpIntercepingMetrics,.httpIntercepingRequest,.httpIntercepingResponse]
    
    var interceptor: HttpInterceptor? = nil
    var sessionManager: SessionManager = SessionManager()
    var session: URLSession? = nil
    
    var requestHeader: String? = nil
    var httpRequestQueryString: String? = nil
    var httpRequestBody: String? = nil
    var httpResponseHeader: String? = nil
    var httpResponseBody: String? = nil
    var httpRequestURL: String? = nil

    var httpIntercepingRequest: String? = nil
    var httpIntercepingResponseHeader: String? = nil
    var httpIntercepingResponseBody: String? = nil
    var httpIntercepingMetrics: String? = nil
    var httpIntercepingStatusCode: String? = nil

    var requestType: RequestType = .urlsession_get
    
    enum RequestType {
        case urlsession_get
        case urlsession_post
        case urlsession_download
        case nsurlconnection_get
        case nsurlconnection_post
        case nsurlconnection_download
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerInterceptor()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableLabelViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44.0;

        switch requestType {
        case .nsurlconnection_get:
            title = "NSURLConnection"
            connectionGETRequest()
        case .nsurlconnection_post:
            title = "NSURLConnection"
            connectionPOSTRequest()
        case .nsurlconnection_download:
            title = "NSURLConnection"
            connectionDownloadRequest()
        case .urlsession_get:
            title = "URLSession GET"
            sessionGETRequest()
        case .urlsession_post:
            title = "URLSession POST"
            sessionPOSTRequest()
        case .urlsession_download:
            title = "URLSession DOWNLOAD"
            sessionDownloadRequest()
        }
    }
    
    /// `URLSession` start `get`request
    func sessionGETRequest() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: sessionManager, delegateQueue: nil)
        var request = URLRequest(url: URL(string: "https://httpbin.org/get?name=henry&gender=male")!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let task = session!.dataTask(with: request)
        
        parseRequest(request)
        task.resume()
    }
    
    /// `URLSession` start `post`request
    func sessionPOSTRequest() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: sessionManager, delegateQueue: nil)
        var request = URLRequest(url: URL(string: "https://httpbin.org/post?name=henry&gender=male")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameterDictionary: [String: Any] = ["name":"henry","subs":["var","let","some","option","undefine"]]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameterDictionary, options: [.fragmentsAllowed,.prettyPrinted])
        let task = session!.dataTask(with: request)
        
        parseRequest(request)
        task.resume()
    }
    
    /// `URLSession` start `download`request
    func sessionDownloadRequest() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: sessionManager, delegateQueue: nil)
        var request = URLRequest(url: URL(string: "http://47.99.237.180:2088/files/628cae9fb56964c7c158ccd0a5bf83ff?name=henry&gender=male")!)
        request.httpMethod = "GET"
        request.setValue("NSURLConnectionDownloadSample", forHTTPHeaderField: "Custom-Field")
        let task = session!.downloadTask(with: request)
        
        parseRequest(request)
        task.resume()
    }
    
    /// `NSURLConnection` start `post` request
    func connectionPOSTRequest() {
        var request = URLRequest(url: URL(string: "https://httpbin.org/post")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameterDictionary: [String: Any] = ["name":"henry","subs":["var","let","some","option","undefine"]]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameterDictionary, options: [.fragmentsAllowed,.prettyPrinted])
        
        parseRequest(request)
        NSURLConnection(request: request, delegate: self, startImmediately: true)
    }
    
    /// `NSURLConnection` start `get` request
    func connectionGETRequest() {
        var request = URLRequest(url: URL(string: "https://httpbin.org/get?name=henry&gender=male")!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        parseRequest(request)
        NSURLConnection(request: request, delegate: self, startImmediately: true)
    }
    
    /// `NSURLConnection` start `download` request
    func connectionDownloadRequest() {
        var request = URLRequest(url: URL(string: "http://47.99.237.180:2088/files/628cae9fb56964c7c158ccd0a5bf83ff?name=henry&gender=male")!)
        request.httpMethod = "GET"
        request.setValue("NSURLConnectionDownloadSample", forHTTPHeaderField: "Custom-Field")

        parseRequest(request)
        NSURLConnection(request: request, delegate: self, startImmediately: true)
    }
    
    func parseRequest(_ request: URLRequest) {
        if let urlStr = request.url?.absoluteString {
            self.httpRequestURL = urlStr
        }
        
        if let header = request.allHTTPHeaderFields {
            let jsonData = try! JSONSerialization.data(withJSONObject: header, options: [.prettyPrinted,.fragmentsAllowed])
            let headerStr = String.init(data: jsonData, encoding: String.Encoding.utf8)
            self.requestHeader = headerStr
        }
        
        if let body = request.httpBody {
            let bodyObject = try! JSONSerialization.jsonObject(with: body, options: [.allowFragments, .mutableContainers])
            let jsonData = try! JSONSerialization.data(withJSONObject: bodyObject, options: [.prettyPrinted,.fragmentsAllowed])
            let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8)
            self.httpRequestBody = jsonString
        }
        
        self.httpRequestQueryString = request.url?.query
        
        sessionManager.complete = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        sessionManager.didReviceData = { [weak self] (bodyString: String?) in
            self?.httpResponseBody = bodyString
        }
        
        sessionManager.didReviceResponse = { [weak self] (headerStr: String?) in
            self?.httpResponseHeader = headerStr
        }
    }
    
    
    deinit {
        print("URLSessionViewController deinit")
        interceptor?.unregister()
        session?.finishTasksAndInvalidate()
    }

}


extension URLSessionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ContentType.getSectionHeaderText(index: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = ContentType(rawValue: indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! TableLabelViewCell
        
        switch type {
        case .httpReuestURL:
            cell.label.text = self.httpRequestURL ?? "None"
            cell.label.textColor = .black
            cell.backgroundColor = .white
            return cell
            
        case .httpRequestHeader:
            cell.label.text = self.requestHeader ?? "None"
            cell.label.textColor = .black
            cell.backgroundColor = .white
            return cell
            
        case .httpRequestQueryString:
            cell.label.text = self.httpRequestQueryString ?? "None"
            cell.label.textColor = .black
            cell.backgroundColor = .white
            return cell
            
        case .httpRequestBody:
            cell.label.text = self.httpRequestBody ?? "None"
            cell.label.textColor = .black
            cell.backgroundColor = .white
            return cell
            
        case .httpResponseHeader:
            cell.label.text = self.httpResponseHeader ?? "None"
            cell.label.textColor = .black
            cell.backgroundColor = .white
            return cell
            
        case .httpResponseBody:
            cell.label.text = self.httpResponseBody ?? "None"
            cell.label.textColor = .black
            cell.backgroundColor = .white
            return cell
            
        case .httpIntercepingRequest:
            cell.label.text = self.httpIntercepingRequest ?? "None"
            cell.label.textColor = .green
            cell.backgroundColor = .black
            return cell
            
        case .httpIntercepingResponse:
            let result: String = """
            AllHTTPHeaderFields: \(self.httpIntercepingResponseHeader ?? "") \n
            StatusCode: \(self.httpIntercepingStatusCode ?? "") \n
            ResponseBody: \(self.httpIntercepingResponseBody ?? "") \n
            """
            cell.label.text = result
            cell.label.textColor = .green
            cell.backgroundColor = .black
            return cell
            
        case .httpIntercepingMetrics:
            cell.label.text = self.httpIntercepingMetrics ?? "None"
            cell.label.textColor = .green
            cell.backgroundColor = .black
            return cell
            
        case .none:
            return cell
        
        }
    }
    
}



//extension URLSessionViewController: NSURLConnectionDownloadDelegate {
//    func connection(_ connection: NSURLConnection, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, expectedTotalBytes: Int64) {
//        print("[URLSessionViewController] NSURLConnectionDownloadDelegate didWriteData bytesWritten: totalBytesWritten: expectedTotalBytes:")
//    }
//
//    func connectionDidResumeDownloading(_ connection: NSURLConnection, totalBytesWritten: Int64, expectedTotalBytes: Int64) {
//        print("[URLSessionViewController] NSURLConnectionDownloadDelegate totalBytesWritten: expectedTotalBytes:")
//    }
//
//    func connectionDidFinishDownloading(_ connection: NSURLConnection, destinationURL: URL) {
//        print("[URLSessionViewController] NSURLConnectionDownloadDelegate destinationURL:")
//    }
//}

extension URLSessionViewController: NSURLConnectionDelegate {
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("[URLSessionViewController] NSURLConnectionDataDelegate didFailWithError error:\(error)")
    }

//    func connectionShouldUseCredentialStorage(_ connection: NSURLConnection) -> Bool {
//        print("[URLSessionViewController] NSURLConnectionDataDelegate connectionShouldUseCredentialStorage")
//        return false
//    }

//    func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge) {
//        print("[URLSessionViewController] NSURLConnectionDataDelegate willSendRequestFor challenge:\(challenge)")
//    }

//    func connection(_ connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: URLProtectionSpace) -> Bool {
//        print("[URLSessionViewController] NSURLConnectionDataDelegate canAuthenticateAgainstProtectionSpace protectionSpace:")
//        return true
//    }

//    func connection(_ connection: NSURLConnection, didReceive challenge: URLAuthenticationChallenge) {
//        print("[URLSessionViewController] NSURLConnectionDataDelegate didReceive challenge:")
//    }
//
//    func connection(_ connection: NSURLConnection, didCancel challenge: URLAuthenticationChallenge) {
//        print("[URLSessionViewController] NSURLConnectionDataDelegate didCancel challenge:")
//    }
    
}


extension URLSessionViewController: NSURLConnectionDataDelegate {
//    func connection(_ connection: NSURLConnection, willSend request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
//        print("[URLSessionViewController] NSURLConnectionDataDelegate willSend request: redirectResponse response:")
//        return request
//    }

    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        let httpResponse = response as! HTTPURLResponse
        let jsonData = try! JSONSerialization.data(withJSONObject: httpResponse.allHeaderFields, options: [.prettyPrinted,.fragmentsAllowed])
        let headerStr = String(data: jsonData, encoding: String.Encoding.utf8)
        self.httpResponseHeader = headerStr
        print("[URLSessionViewController] NSURLConnectionDataDelegate didReceive response:")
    }

    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        let bodyString = String(data: data, encoding: String.Encoding.utf8)
        self.httpResponseBody = bodyString
        print("[URLSessionViewController] NSURLConnectionDataDelegate didReceive data:")
    }

    func connection(_ connection: NSURLConnection, needNewBodyStream request: URLRequest) -> InputStream? {
        print("[URLSessionViewController] NSURLConnectionDataDelegate needNewBodyStream request:")
        return nil
    }

    func connection(_ connection: NSURLConnection, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
        print("[URLSessionViewController] NSURLConnectionDataDelegate didSendBodyData bytesWritten: totalBytesWritten: totalBytesExpectedToWrite:")
    }

    func connection(_ connection: NSURLConnection, willCacheResponse cachedResponse: CachedURLResponse) -> CachedURLResponse? {
        print("[URLSessionViewController] NSURLConnectionDataDelegate willCacheResponse cachedResponse:")
        return nil
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("[URLSessionViewController] NSURLConnectionDataDelegate connectionDidFinishLoading")
    }
}
