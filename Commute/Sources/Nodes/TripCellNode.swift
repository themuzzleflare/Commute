import BonMot
import UIKit
import AsyncDisplayKit

final class TripCellNode: ASCellNode {
  private let tripNameTextNode = ASTextNode()
  private var trip: Trip

  init(trip: Trip) {
    self.trip = trip
    super.init()

    automaticallyManagesSubnodes = true

    let style = StringStyle(
      .alignment(.left),
      .font(.newFrankRegular(size: UIFont.labelFontSize)),
      .color(.label)
    )

    tripNameTextNode.attributedText = trip.tripName.styled(with: style)
  }

  override func didLoad() {
    view.addInteraction(UIContextMenuInteraction(delegate: self))
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .cellNode, child: tripNameTextNode)
  }
}

extension TripCellNode: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { (_) in
      UIMenu(children: [
        UIAction(title: "Remove", image: .trash, attributes: .destructive, handler: { (_) in
          AppDelegate.viewContext.delete(self.trip)
          do {
            try AppDelegate.viewContext.save()
          } catch {
            DispatchQueue.main.async {
              let alertController = UIAlertController.alertWithDismissButton(title: "Error", message: error.localizedDescription)
              self.viewController?.present(alertController, animated: true)
            }
          }
        })
      ])
    })
  }
}
