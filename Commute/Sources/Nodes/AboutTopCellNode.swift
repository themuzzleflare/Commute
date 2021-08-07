import UIKit
import AsyncDisplayKit

final class AboutTopCellNode: ASCellNode {
  let logoNode = ASImageNode()
  let labelNode = ASTextNode()

  override init() {
    super.init()

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    logoNode.image = UIImage(named: "appLogo")
    logoNode.forceUpscaling = true
    logoNode.style.width = ASDimension(unit: .points, value: 150)
    logoNode.style.height = ASDimension(unit: .points, value: 150)
    logoNode.cornerRadius = 40

    labelNode.attributedText = NSAttributedString(
      string: "Commute",
      attributes: [
        .font: UIFont.boldSystemFont(ofSize: 32),
        .foregroundColor: UIColor.label,
        .paragraphStyle: pCentreStyle
      ]
    )
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let vStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 15,
      justifyContent: .center,
      alignItems: .center,
      children: [
        logoNode,
        labelNode
      ]
    )

    return ASInsetLayoutSpec(
      insets: UIEdgeInsets(
        top: 13,
        left: 16,
        bottom: 13,
        right: 16
      ),
      child: vStack
    )
  }
}
