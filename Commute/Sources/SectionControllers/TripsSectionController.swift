import Foundation
import IGListKit
import AsyncDisplayKit

final class TripsSectionController: ListSectionController {
  private var object: TripViewModel!
  
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
    self.object = object as? TripViewModel
  }
  
  override func didSelectItem(at index: Int) {
    collectionContext?.deselectItem(at: index, sectionController: self, animated: true)
    viewController?.navigationController?.pushViewController(TripDetailVC(trip: object), animated: true)
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
