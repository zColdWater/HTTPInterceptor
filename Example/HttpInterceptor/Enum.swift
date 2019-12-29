import Foundation
import UIKit

enum DemoSectionType: Int {
    case webview = 0
    case urlsession
    case urlconnection
    case mock
    
    func getName() -> String {
        switch self {
        case .webview:
            return "WebView"
        case .urlsession:
            return "URLSession"
        case .urlconnection:
            return "NSURLConnection"
        case .mock:
            return "Mocker"
        }
    }
}

enum DemoRowType: Int {
    
    static var identifier: String { return "interceptor-demo" }
    case wkwebview = 0
    case uiwebview
    case urlsessionGet
    case urlsessionPost
    case urlsessionDownload
    case urlconnectionGet
    case urlconnectionPost
    case urlconnectionDownload
    case mockData
    
    func getName() -> String {
        switch self {
        case .uiwebview:
            return "拦截 UIWebView 中的 HTTP/HTTPS 请求"
        case .wkwebview:
            return "拦截 WKWebView 中的 HTTP/HTTPS 请求"
        case .urlconnectionGet:
            return "拦截 URLConnection 发起的 GET 请求"
        case .urlconnectionPost:
            return "拦截 URLConnection 发起的 POST 请求"
        case .urlconnectionDownload:
            return "拦截 URLConnection 发起的 DOWNLOAD 请求"
        case .urlsessionGet:
            return "拦截 URLSession 发起的 GET 请求"
        case .urlsessionPost:
            return "拦截 URLSession 发起的 POST 请求"
        case .urlsessionDownload:
            return "拦截 URLSession 发起的 DOWNLOAD 请求"
        case .mockData:
            return "Mock 网络请求数据"
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .uiwebview:
            return "拦截UIWebView中所有的 png, svg, jpeg, gif 结尾的链接，替换成自定义资源链接。 测试链接 "
        case .wkwebview:
            return "拦截WKWebView中所有的 png, svg, jpeg, gif 结尾的链接，替换成自定义资源链接。"
        case .urlconnectionGet:
            return "拦截网络GET请求"
        case .urlconnectionPost:
            return "拦截网络POST请求"
        case .urlconnectionDownload:
            return "拦截网络DOWNLOAD请求"
        case .urlsessionGet:
            return "拦截网络GET请求"
        case .urlsessionPost:
            return "拦截网络POST请求"
        case .urlsessionDownload:
            return "拦截网络DOWNLOAD请求"
        case .mockData:
            return "Mock网络请求返回数据"
        }
    }
    
    func todo(viewController: UIViewController) {
        switch self {
        case .uiwebview:
            let vc = UIWebViewController()
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        case .wkwebview:
            let vc = WKViewController()
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        case .urlconnectionGet:
            let vc = URLSessionViewController()
            vc.requestType = .nsurlconnection_get
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        case .urlconnectionPost:
            let vc = URLSessionViewController()
            vc.requestType = .nsurlconnection_post
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        case .urlconnectionDownload:
            let vc = URLSessionViewController()
            vc.requestType = .nsurlconnection_download
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        case .urlsessionGet:
            let vc = URLSessionViewController()
            vc.requestType = .urlsession_get
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        case .urlsessionPost:
            let vc = URLSessionViewController()
            vc.requestType = .urlsession_post
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        case .urlsessionDownload:
            let vc = URLSessionViewController()
            vc.requestType = .urlsession_download
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        case .mockData:
            let vc = MockerViewController()
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    
    static func getDemoType(index: Int) -> DemoRowType? {
        return DemoRowType(rawValue: index)
    }
}
