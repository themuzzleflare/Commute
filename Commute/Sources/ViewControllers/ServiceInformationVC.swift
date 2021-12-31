import UIKit
import AsyncDisplayKit

final class ServiceInformationVC: ASViewController {
  private let tableNode = ASTableNode(style: .plain)

  private var alerts = [TransitRealtime_FeedEntity]() {
    didSet {
      tableNode.reloadData()
    }
  }

  override init() {
    super.init(node: tableNode)
  }
  
  deinit {
    print("\(#function) \(String(describing: type(of: self)))")
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigation()
    configureTableNode()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchTrackworkAlerts()
  }

  private func configureNavigation() {
    navigationItem.title = "Service Information"
  }

  private func configureTableNode() {
    tableNode.dataSource = self
    tableNode.delegate = self
  }

  private func fetchTrackworkAlerts() {
    APIFacade.fetchTrackworkAlerts { (result) in
      DispatchQueue.main.async {
        switch result {
        case let .success(feed):
          self.alerts = feed.entity
        case let .failure(error):
          let alertController = UIAlertController.alertWithDismissPopButton(self.navigationController, title: "Error", message: error.localizedDescription)
          self.present(alertController, animated: true)
        }
      }
    }
  }
}

extension ServiceInformationVC: ASTableDataSource {
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return alerts.count
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let alert = alerts[indexPath.row].alert

    return {
      AlertCellNode(alert: alert)
    }
  }
}

extension ServiceInformationVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    let alert = alerts[indexPath.row].alert

    tableNode.deselectRow(at: indexPath, animated: true)

    navigationController?.pushViewController(ServiceAlertVC(alert: alert), animated: true)
  }
}
