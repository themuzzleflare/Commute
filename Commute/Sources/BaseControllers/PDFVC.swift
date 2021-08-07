import UIKit
import AsyncDisplayKit
import PDFKit

final class PDFVC: ASViewController {
  private var document: PDFDocument

  private lazy var pdfNode = ASDisplayNode { () -> UIView in
    let view = PDFView()
    view.delegate = self
    view.document = self.document
    return view
  }

  init(document: PDFDocument) {
    self.document = document
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    displayNode.addSubnode(pdfNode)
    configureNavigation()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    pdfNode.frame = displayNode.bounds
  }

  private func configureNavigation() {
    navigationItem.title = document.documentAttributes?["Title"] as? String ?? ""
  }
}

extension PDFVC: PDFViewDelegate {
}
