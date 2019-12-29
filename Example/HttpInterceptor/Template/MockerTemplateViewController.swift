import UIKit
import WebKit
import BestHttpInterceptor


let jsonURL: URL = URL(string: "https://mocker.example.com/json?arg1=1234567890")!
let pngURL: URL = URL(string: "https://mocker.example.com/png?arg1=1234567890")!
let jpgURL: URL = URL(string: "https://mocker.example.com/jpg?arg1=1234567890")!
let gifURL: URL = URL(string: "https://mocker.example.com/gif?arg1=1234567890")!
let htmlURL: URL = URL(string: "https://mocker.example.com/html?arg1=1234567890")!
let pdfURL: URL = URL(string: "https://mocker.example.com/pdf?arg1=1234567890")!

let URLS: [URL] = [jsonURL,pngURL,jpgURL,gifURL,htmlURL,pdfURL]

class MockerTemplateViewController: UIViewController {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentWebView: WKWebView!
    
    var type: MockExampleType
    var interceptor: HttpInterceptor!

    init(type: MockExampleType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerInterceptor()
        setupViews()
        doTask()
    }
    
    deinit {
        print("MockerTemplateViewController deinit")
        interceptor.unregister()
    }
    
    func registerInterceptor() {
        let condition = HttpIntercepCondition.init(schemeType: .all) { (request) -> Bool in
            if let url = request.url, URLS.contains(url) {
                return true
            }
            return false
        }
        interceptor = HttpInterceptor(condition: condition, mockerDelegate: self)
        interceptor.register()
    }
    
    func setupViews() {
        contentLabel.isHidden = true
        contentImageView.isHidden = true
        contentWebView.isHidden = true
        switch self.type {
        case .html,.pdf:
            contentWebView.isHidden = false
            break
        case .imageGIF,.imageJPG,.imagePNG:
            contentImageView.isHidden = false
            break
        case .json:
            contentLabel.isHidden = false
            break
        }
    }
    
    func doTask() {
        switch self.type {
        case .json:
            URLSession.shared.dataTask(with: jsonURL) { (data, response, error) in
                if let e = error {
                    print("e:\(e)")
                } else {
                    let jsonStr = String(data: data!, encoding: .utf8)
                    DispatchQueue.main.async {
                        self.contentLabel.text = jsonStr
                    }
                }
            }.resume()
            break
        case .html:
            URLSession.shared.dataTask(with: htmlURL) { (data, response, error) in
                if let e = error {
                    print("e:\(e)")
                } else {
                    DispatchQueue.main.async {
                        let htmlString = String(data: data!, encoding: .utf8)
                        self.contentWebView.loadHTMLString(htmlString!, baseURL: nil)
                    }
                }
            }.resume()
            break
        case .imagePNG:
            URLSession.shared.dataTask(with: pngURL) { (data, response, error) in
                if let e = error {
                    print("e:\(e)")
                } else {
                    DispatchQueue.main.async {
                        self.contentImageView.image = UIImage(data: data!)
                    }
                }
            }.resume()
            break
        case .imageJPG:
            URLSession.shared.dataTask(with: jpgURL) { (data, response, error) in
                if let e = error {
                    print("e:\(e)")
                } else {
                    DispatchQueue.main.async {
                        self.contentImageView.image = UIImage(data: data!)
                    }
                }
            }.resume()
            break
        case .imageGIF:
            URLSession.shared.dataTask(with: gifURL) { (data, response, error) in
                if let e = error {
                    print("e:\(e)")
                } else {
                    DispatchQueue.main.async {
                        self.contentImageView.image = UIImage.gifImageWithData(data!)
                    }
                }
            }.resume()
            break
        case .pdf:
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let localUrl = URL(string: "file://"+documentsPath+"/mock_pdf.pdf")!
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let task = session.downloadTask(with: pdfURL) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Success: \(statusCode)")
                    }

                    if FileManager.default.fileExists(atPath: (documentsPath+"/mock_pdf.pdf")) {
                        DispatchQueue.main.async {
                            self.contentWebView.loadFileURL(localUrl, allowingReadAccessTo: localUrl)
                        }
                    } else {
                        do {
                            try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                            DispatchQueue.main.async {
                                self.contentWebView.loadFileURL(localUrl, allowingReadAccessTo: localUrl)
                            }
                        } catch let writeError {
                            print("error writing file \(localUrl) : \(writeError)")
                        }
                    }

                } else {
                    print("Failure: %@", error?.localizedDescription);
                }
            }
            task.resume()
            break
        }
    }
    
}


extension MockerTemplateViewController: HttpMockerDelegate {
    
    func httpMocker(request: URLRequest) -> HttpMocker {
        
        guard let url = request.url else { fatalError() }
        
        switch url {
        case jsonURL:
            let jsonUrl = Bundle(for: MockerTemplateViewController.self).url(forResource: "mock_json", withExtension: "json")!
            let mocker = HttpMocker(dataType: .json, mockData: jsonUrl.data, statusCode: 200, httpVer: .http1_1)
            return mocker
        case pngURL:
            let pngUrl = Bundle(for: MockerTemplateViewController.self).url(forResource: "mock_png", withExtension: "png")!
            let mocker = HttpMocker(dataType: .imagePNG, mockData: pngUrl.data, statusCode: 200, httpVer: .http1_1)
            return mocker
        case jpgURL:
            let jpgUrl = Bundle(for: MockerTemplateViewController.self).url(forResource: "mock_jpg", withExtension: "jpg")!
            let mocker = HttpMocker(dataType: .imageJPG, mockData: jpgUrl.data, statusCode: 200, httpVer: .http1_1)
            return mocker
        case gifURL:
            let gifUrl = Bundle(for: MockerTemplateViewController.self).url(forResource: "mock_gif", withExtension: "gif")!
            let mocker = HttpMocker(dataType: .imageGIF, mockData: gifUrl.data, statusCode: 200, httpVer: .http1_1)
            return mocker
        case pdfURL:
            let gifUrl = Bundle(for: MockerTemplateViewController.self).url(forResource: "mock_pdf", withExtension: "pdf")!
            let mocker = HttpMocker(dataType: .pdf, mockData: gifUrl.data, statusCode: 200, httpVer: .http1_1)
            return mocker
        case htmlURL:
            let gifUrl = Bundle(for: MockerTemplateViewController.self).url(forResource: "mock_html", withExtension: "html")!
            let mocker = HttpMocker(dataType: .html, mockData: gifUrl.data, statusCode: 200, httpVer: .http1_1)
            return mocker
        default:
            break
        }
        
        fatalError()
    }
}


internal extension URL {
    /// Returns a `Data` representation of the current `URL`. Force unwrapping as it's only used for tests.
    var data: Data {
        return try! Data(contentsOf: self)
    }
}
