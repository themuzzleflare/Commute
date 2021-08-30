import UIKit
import AsyncDisplayKit
import PDFKit
import Rswift

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
    let cell = ASTextCellNode(
      attributes: [
        NSAttributedString.Key.font: R.font.newFrankRegular(size: UIFont.labelFontSize)!,
        NSAttributedString.Key.foregroundColor: UIColor.label,
        NSAttributedString.Key.paragraphStyle: NSParagraphStyle.leftAligned
      ],
      insets: UIEdgeInsets(
        top: 13,
        left: 16,
        bottom: 13,
        right: 16
      )
    )

    cell.accessoryType = .disclosureIndicator

    return {
      switch indexPath.row {
      case 0:
        cell.text = "Sydney Rail Network Map"
        return cell
      case 1:
        cell.text = "Service Information"
        return cell
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
      if let document = PDFDocument(url: R.file.sydneyRailNetworkPdf.url()!) {
        navigationController?.pushViewController(PDFVC(document: document), animated: true)
      }
    case 1:
      navigationController?.pushViewController(ServiceInformationVC(), animated: true)
    default:
      break
    }
  }
}
