import UIKit
import WebKit
import BestHttpInterceptor

class WKViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    var interceptor: HttpInterceptor? = nil
    
    enum PathExtension: String {
        case gif = "gif"
        case png = "png"
        case jpeg = "jpeg"
        case svg = "svg"
        case jpg = "jpg"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WKWebViewController"
        registerInterceptor()
        let url = URL(string: "https://www.baidu.com/")
        webview.load(URLRequest(url: url!))
    }
    
    func registerInterceptor() {
        let condition = HttpIntercepCondition(schemeType: .all) { (request) -> Bool in
            guard let pathExtensionStr = request.url?.pathExtension,
                  let host = request.url?.host else {
                return false
            }
            if host.contains("ss") || host.contains("timgmb") {
                return true
            }
            let pathExtension = WKViewController.PathExtension(rawValue: pathExtensionStr)
            switch pathExtension {
            case .gif,.jpeg,.png,.svg,.jpg:
                return true
            case .none:
                return false
            }
        }
        interceptor = HttpInterceptor(condition: condition, interceptorDelegate: self)
        interceptor?.register()
    }
    
    deinit {
        print("WKViewController deinit")
        interceptor?.unregister()
    }
    
}

extension WKViewController: HttpInterceptDelegate {
    
    func httpRequest(request: URLRequest) -> URLRequest {
        var newRequest = request
        newRequest.url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577182928067&di=4a039119f074e775880d33ee7589e556&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170307%2Fc1529f8154f949ef83abee83f6d5ece7.jpg")!
        return newRequest
    }
    
}
