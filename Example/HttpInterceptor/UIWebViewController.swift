import UIKit
import WebKit

class UIWebViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIWebViewController"
        let webview = UIWebView(frame: UIScreen.main.bounds)
        view.addSubview(webview)
        let url = URL(string: "https://zhuanlan.zhihu.com/p/98880261")
        webview.loadRequest(URLRequest(url: url!))
    }
    
    deinit {
        print("UIWebViewController deinit")
    }

}
