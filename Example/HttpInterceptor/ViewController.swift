import UIKit

enum DemoSectionType: Int {
    case webview = 0
    case urlsession
    case urlconnection
    
    func getName() -> String {
        switch self {
        case .webview:
            return "WebView"
        case .urlsession:
            return "URLSession"
        case .urlconnection:
            return "NSURLConnection"
        }
    }
}

enum DemoRowType: Int {
    
    static var identifier: String { return "interceptor-demo" }
    case wkwebview = 0
    case uiwebview
    case urlsession
    case urlconnection
    
    func getName() -> String {
        switch self {
        case .uiwebview:
            return "拦截UIWebView中的http请求"
        case .wkwebview:
            return "拦截WKWebView中的http请求"
        case .urlconnection:
            return "拦截URLConnection发起的http请求"
        case .urlsession:
            return "拦截URLSession发起的http请求"
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .uiwebview:
            return "拦截UIWebView中所有的 png, svg, jpeg, gif 结尾的链接，替换成自定义资源链接。 测试链接 "
        case .wkwebview:
            return "拦截WKWebView中所有的 png, svg, jpeg, gif 结尾的链接，替换成自定义资源链接。"
        case .urlconnection:
            return "URLConnection的所有网络请求"
        case .urlsession:
            return "URLSession的所有网络请求"
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
        case .urlconnection:
            let vc = URLSessionViewController()
            vc.requestType = .nsurlconnection
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        case .urlsession:
            let vc = URLSessionViewController()
            vc.requestType = .urlsession
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    
    static func getDemoType(index: Int) -> DemoRowType? {
        return DemoRowType(rawValue: index)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var dataSource: [DemoSectionType: [DemoRowType]] = [.webview: [.uiwebview,.wkwebview],
                                                        .urlsession: [.urlsession],
                                                        .urlconnection: [.urlconnection]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DemoRowType.identifier)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let type = DemoSectionType(rawValue: section) else {
            assertionFailure()
            return ""
        }
        return type.getName()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = DemoSectionType(rawValue: section) else { return 0 }
        switch type {
            case .webview:
                return dataSource[.webview]!.count
            case .urlsession:
                return dataSource[.urlsession]!.count
            case .urlconnection:
                return dataSource[.urlconnection]!.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = DemoSectionType(rawValue: indexPath.section) else { return assertionFailure() }
        dataSource[type]?[indexPath.row].todo(viewController: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = DemoSectionType(rawValue: indexPath.section) else { assertionFailure(); return UITableViewCell() }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: DemoType.identifier)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: DemoRowType.identifier)
        cell.textLabel?.text = dataSource[type]?[indexPath.row].getName()
        cell.detailTextLabel?.text = dataSource[type]?[indexPath.row].getDescription()
        cell.detailTextLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
}
