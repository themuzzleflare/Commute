import PDFKit
import UIKit
import AsyncDisplayKit

final class ToolsVC: ASDKViewController<ASTableNode> {
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
    navigationItem.title = "Tools"
  }

  private func configureTableNode() {
    tableNode.dataSource = self
    tableNode.delegate = self
    tableNode.view.showsVerticalScrollIndicator = false
  }
}

extension ToolsVC: ASTableDataSource {
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    return {
      switch indexPath.row {
      case 0:
        return ASTextCellNode(text: "Sydney Rail Network Map", accessoryType: .disclosureIndicator)
      case 1:
        return ASTextCellNode(text: "Service Information", accessoryType: .disclosureIndicator)
      default:
        fatalError("Unknown row")
      }
    }
  }
}

extension ToolsVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    tableNode.deselectRow(at: indexPath, animated: true)

    switch indexPath.row {
    case 0:
      if let document = PDFDocument(url: .sydneyRailNetworkPDF) {
        navigationController?.pushViewController(PDFVC(document: document), animated: true)
      }
    case 1:
      navigationController?.pushViewController(ServiceInformationVC(), animated: true)
    default:
      break
    }
  }
}
