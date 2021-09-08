import PDFKit
import UIKit
import AsyncDisplayKit

final class PDFVC: ASViewController {
  private var document: PDFDocument

  private let pdfNode = PDFNode()

  init(document: PDFDocument) {
    self.document = document
    super.init(node: pdfNode)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigation()
    configurePDFNode()
  }

  private func configureNavigation() {
    navigationItem.title = document.documentAttributes?["Title"] as? String ?? ""
  }

  private func configurePDFNode() {
    pdfNode.document = document
  }
}
