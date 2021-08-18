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
    return 1
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let cell = ASTextCellNode(
      attributes: [
        NSAttributedString.Key.font: R.font.newFrankRegular(size: UIFont.labelFontSize)!,
        NSAttributedString.Key.foregroundColor: UIColor.label,
        NSAttributedString.Key.paragraphStyle: ModelFacade.pLeftStyle
      ],
      insets: UIEdgeInsets(
        top: 13,
        left: 16,
        bottom: 13,
        right: 16
      )
    )

    cell.accessoryType = .disclosureIndicator
    cell.text = "Sydney Rail Network Map"

    return {
      cell
    }
  }
}

extension ToolsVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    tableNode.deselectRow(at: indexPath, animated: true)

    if let document = PDFDocument(url: R.file.sydneyRailNetworkPdf.url()!) {
      navigationController?.pushViewController(PDFVC(document: document), animated: true)
    }
  }
}
