import Foundation
import IGListKit
import AsyncDisplayKit

final class TripsSectionController: ListSectionController {
  private var object: Trip!

  override init() {
    super.init()
    supplementaryViewSource = self
  }

  override func numberOfItems() -> Int {
    return 1
  }

  override func sizeForItem(at index: Int) -> CGSize {
    return ASIGListSectionControllerMethods.sizeForItem(at: index)
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
  }

  override func didUpdate(to object: Any) {
    self.object = object as? Trip
  }

  override func didSelectItem(at index: Int) {
    collectionContext?.nodeForItem(at: index, sectionController: self)?.select()
    collectionContext?.nodeForItem(at: index, sectionController: self)?.deselect()
    viewController?.navigationController?.pushViewController(TripDetailVC(trip: object), animated: true)
  }

  override func didDeselectItem(at index: Int) {
    collectionContext?.nodeForItem(at: index, sectionController: self)?.deselect()
  }

  override func didHighlightItem(at index: Int) {
    collectionContext?.nodeForItem(at: index, sectionController: self)?.highlight()
  }

  override func didUnhighlightItem(at index: Int) {
    collectionContext?.nodeForItem(at: index, sectionController: self)?.unhighlight()
  }
}

extension TripsSectionController: ASSectionController {
  func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
    return {
      TripCellNode(trip: self.object)
    }
  }

  func sizeRangeForItem(at index: Int) -> ASSizeRange {
    return .cellNode(minHeight: 45, maxHeight: 55)
  }
}

extension TripsSectionController: ListSupplementaryViewSource {
  func supportedElementKinds() -> [String] {
    return [ASCollectionView.elementKindSectionFooter]
  }

  func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
    return ASIGListSupplementaryViewSourceMethods.viewForSupplementaryElement(ofKind: elementKind, at: index, sectionController: self)
  }

  func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
    return ASIGListSupplementaryViewSourceMethods.sizeForSupplementaryView(ofKind: elementKind, at: index)
  }
}

extension TripsSectionController: ASSupplementaryNodeSource {
  func nodeBlockForSupplementaryElement(ofKind elementKind: String, at index: Int) -> ASCellNodeBlock {
    return {
      SeparatorCellNode()
    }
  }

  func sizeRangeForSupplementaryElement(ofKind elementKind: String, at index: Int) -> ASSizeRange {
    return .separator
  }
}
