import UIKit

let mockerTableViewIdentifier = "mockerTableViewIdentifier"

enum MockExampleType: Int {
    
    case json = 0
    case html
    case imagePNG
    case imageJPG
    case imageGIF
    case pdf
    
    func getName() -> String {
        switch self {
        case .json:
            return "Mock JSON"
        case .html:
            return "Mock HTML"
        case .imagePNG:
            return "Mock PNG"
        case .imageJPG:
            return "Mock JPG"
        case .imageGIF:
            return "Mock GIF"
        case .pdf:
            return "Mock PDF"
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .json:
            return "Mock返回JSON数据"
        case .html:
            return "Mock返回HTML数据"
        case .imagePNG:
            return "Mock返回PNG数据"
        case .imageJPG:
            return "Mock返回JPG数据"
        case .imageGIF:
            return "Mock返回GIF数据"
        case .pdf:
            return "Mock返回PDF数据"
        }
    }
    
    func todo(viewController: UIViewController) {
        switch self {
        case .json:
            let vc = MockerTemplateViewController.init(type: .json)
            vc.title = "Mock JSON"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .html:
            let vc = MockerTemplateViewController.init(type: .html)
            vc.title = "Mock HTML"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .imagePNG:
            let vc = MockerTemplateViewController.init(type: .imagePNG)
            vc.title = "Mock PNG"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .imageJPG:
            let vc = MockerTemplateViewController.init(type: .imageJPG)
            vc.title = "Mock JPG"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .imageGIF:
            let vc = MockerTemplateViewController.init(type: .imageGIF)
            vc.title = "Mock GIF"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .pdf:
            let vc = MockerTemplateViewController.init(type: .pdf)
            vc.title = "Mock PDF"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
}

class MockerViewController: UIViewController {

    var dataSource: [MockExampleType] = [.json,.html,.imageGIF,.imageJPG,.imagePNG,.pdf]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mocker"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: mockerTableViewIdentifier)
    }
    
    deinit {
        print("MockerViewController deinit")
    }

}

extension MockerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt indexPath:\(indexPath)")
        let type = MockExampleType(rawValue: indexPath.row)
        type?.todo(viewController: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = MockExampleType(rawValue: indexPath.row)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: mockerTableViewIdentifier)
        cell.detailTextLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        cell.textLabel?.text = type?.getName()
        cell.detailTextLabel?.text = type?.getDescription()
        return cell
    }
}
