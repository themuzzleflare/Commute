import UIKit
import AsyncDisplayKit

final class SeparatorCellNode: ASCellNode {
  private let separatorDisplayNode = ASDisplayNode()

  override init() {
    super.init()

    automaticallyManagesSubnodes = true

    separatorDisplayNode.backgroundColor = .separator
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .zero, child: separatorDisplayNode)
  }
}
