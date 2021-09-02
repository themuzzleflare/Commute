import UIKit
import AsyncDisplayKit

final class AboutTopCellNode: ASCellNode {
  private let logoImageNode = ASImageNode()
  private let labelTextNode = ASTextNode()

  override init() {
    super.init()

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    logoImageNode.image = .appLogo
    logoImageNode.forceUpscaling = true
    logoImageNode.style.width = ASDimension(unit: .points, value: 150)
    logoImageNode.style.height = ASDimension(unit: .points, value: 150)
    logoImageNode.cornerRadius = 40

    labelTextNode.attributedText = NSAttributedString(
      string: "Commute",
      font: .newFrankBold(size: 32),
      alignment: .centreAligned
    )
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let vStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 15,
      justifyContent: .center,
      alignItems: .center,
      children: [
        logoImageNode,
        labelTextNode
      ]
    )

    return ASInsetLayoutSpec(insets: .cellNode, child: vStack)
  }
}
