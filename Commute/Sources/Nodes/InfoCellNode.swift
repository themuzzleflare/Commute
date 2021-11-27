import Foundation
import UIKit
import AsyncDisplayKit
import BonMot

final class InfoCellNode: ASCellNode {
  private let textNode = ASTextNode()
  
  private var text: String
  
  init(text: String) {
    self.text = text
    super.init()
    automaticallyManagesSubnodes = true
    textNode.attributedText = text.styled(with: .commute)
  }
  
  deinit {
    print(#function)
  }
  
  override func layout() {
    super.layout()
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .cellNode, child: textNode)
  }
}
