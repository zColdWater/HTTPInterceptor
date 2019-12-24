import UIKit

enum DemoType: Int {
    
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
    
    static func getDemoType(index: Int) -> DemoType? {
        return DemoType(rawValue: index)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [DemoType] = [.uiwebview,.wkwebview,.urlsession,.urlconnection]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HTTPInterceptor-Demo"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DemoType.identifier)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = DemoType.getDemoType(index: indexPath.row)
        type?.todo(viewController: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = DemoType.getDemoType(index: indexPath.row)
//        let cell = tableView.dequeueReusableCell(withIdentifier: DemoType.identifier)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: DemoType.identifier)
        cell.textLabel?.text = type?.getName()
        cell.detailTextLabel?.text = type?.getDescription()
        cell.detailTextLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        
        return cell
    }
}
