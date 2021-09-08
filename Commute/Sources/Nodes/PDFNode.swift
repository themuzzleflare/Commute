import PDFKit
import UIKit
import AsyncDisplayKit

final class PDFNode: ASDisplayNode {
  private let pdfViewBlock: ASDisplayNodeViewBlock = {
    return PDFView()
  }

  private var pdfView: PDFView {
    return view as! PDFView
  }

  override init() {
    super.init()
    setViewBlock(pdfViewBlock)
  }

  init(document: PDFDocument) {
    super.init()
    setViewBlock(pdfViewBlock)
    pdfView.document = document
  }
}

extension PDFNode {
  /// Returns the document associated with a `PDFView` object.
  var document: PDFDocument? {
    get {
      return pdfView.document
    }
    set {
      pdfView.document = newValue
    }
  }
}
