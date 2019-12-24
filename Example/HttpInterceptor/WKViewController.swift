import UIKit
import WebKit


class WKViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WKWebViewController"
        let url = URL(string: "https://zhuanlan.zhihu.com/p/98880261")
        webview.load(URLRequest(url: url!))
    }
}
