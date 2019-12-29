import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var dataSource: [DemoSectionType: [DemoRowType]] = [.webview: [.uiwebview,.wkwebview],
                                                        .urlsession: [.urlsessionGet,.urlsessionPost,.urlsessionDownload],
                                                        .urlconnection: [.urlconnectionGet,.urlconnectionPost,.urlconnectionDownload],
                                                        .mock:[.mockData]]
    
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
            case .mock:
                return dataSource[.mock]!.count
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
