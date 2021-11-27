import UIKit
import AsyncDisplayKit
import BonMot

final class SubtitleCellNode: ASCellNode {
  private let topTextNode = ASTextNode()
  private let bottomTextNode = ASTextNode()
  
  private var text: String
  private var detailText: String
  
  init(text: String, detailText: String) {
    self.text = text
    self.detailText = detailText
    super.init()
    automaticallyManagesSubnodes = true
    topTextNode.attributedText = text.styled(with: .commuteBold)
    bottomTextNode.attributedText = detailText.styled(with: .stationDistance)
  }
  
  override func layout() {
    super.layout()
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let vStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .start,
      children: detailText.isEmpty ? [topTextNode] : [topTextNode, bottomTextNode]
    )
    
    return ASInsetLayoutSpec(insets: .cellNode, child: vStack)
  }
}
