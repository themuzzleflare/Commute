import UIKit
import AsyncDisplayKit

final class AboutVC: ASViewController {
  private let tableNode = ASTableNode(style: .grouped)

  override init() {
    super.init(node: tableNode)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigation()
    configureTableNode()
  }

  private func configureNavigation() {
    navigationItem.title = "About"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: .gear,
      style: .plain,
      target: self,
      action: #selector(openSettings)
    )
  }

  private func configureTableNode() {
    tableNode.dataSource = self
  }

  @objc private func openSettings() {
    if UIApplication.shared.canOpenURL(.settingsApp) {
      UIApplication.shared.open(.settingsApp)
    }
  }
}

extension AboutVC: ASTableDataSource {
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    return {
      switch indexPath.row {
      case 0:
        return AboutTopCellNode()
      case 1:
        return RightDetailCellNode(text: "Version", detailText: UserDefaults.commute.appVersion)
      case 2:
        return RightDetailCellNode(text: "Build", detailText: UserDefaults.commute.appBuild)
      default:
        fatalError("Unknown row")
      }
    }
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return InfoPlist.nsHumanReadableCopyright
  }
}
