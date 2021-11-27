import Foundation
import CoreData
import IGListKit
import AsyncDisplayKit

final class StationSC: ListSectionController {
  private var object: StationViewModel!
  private var addTripType: AddTripType
  private var fromStation: Station?
  
  init(addTripType: AddTripType, fromStation: Station? = nil) {
    self.addTripType = addTripType
    self.fromStation = fromStation
    super.init()
    supplementaryViewSource = self
  }
  
  override func sizeForItem(at index: Int) -> CGSize {
    return ASIGListSectionControllerMethods.sizeForItem(at: index)
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
  }
  
  override func didUpdate(to object: Any) {
    self.object = object as? StationViewModel
  }
  
  override func didSelectItem(at index: Int) {
    collectionContext?.deselectItem(at: index, sectionController: self, animated: true)
    switch addTripType {
    case .origin:
      viewController?.navigationItem.backButtonTitle = object.name
      viewController?.navigationController?.pushViewController(AddTripVC(type: .destination, station: object.station), animated: true)
    case .destination:
      configureCoreData(toStation: object.station)
    }
  }
  
  private func configureCoreData(toStation: Station) {
    let fromStation = fromStation!
    
    if Trip.fetchAll().contains(where: { $0.fromId == fromStation.globalId && $0.toId == toStation.globalId }) {
      DispatchQueue.main.async {
        let alertController = UIAlertController.alertWithDismissButton(title: "Error", message: "This trip has already been added.")
        self.viewController?.present(alertController, animated: true)
      }
    } else {
      let newTrip = Trip(context: AppDelegate.viewContext)
      
      newTrip.id = UUID()
      newTrip.fromId = fromStation.globalId
      newTrip.fromStopId = fromStation.stopId
      newTrip.fromName = fromStation.name
      newTrip.toId = toStation.globalId
      newTrip.toStopId = toStation.stopId
      newTrip.toName = toStation.name
      newTrip.dateAdded = Date()
      
      do {
        try AppDelegate.viewContext.save()
        viewController?.navigationController?.dismiss(animated: true)
      } catch {
        DispatchQueue.main.async {
          let alertController = UIAlertController.alertWithDismissButton(title: "Error", message: error.localizedDescription)
          self.viewController?.present(alertController, animated: true)
        }
      }
    }
  }
}

extension StationSC: ASSectionController {
  func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
    return {
      StationCellNode(station: self.object)
    }
  }
  
  func sizeRangeForItem(at index: Int) -> ASSizeRange {
    return .cellNode(minHeight: 40, maxHeight: 55)
  }
}

extension StationSC: ListSupplementaryViewSource {
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

extension StationSC: ASSupplementaryNodeSource {
  func nodeBlockForSupplementaryElement(ofKind elementKind: String, at index: Int) -> ASCellNodeBlock {
    return {
      SeparatorCellNode()
    }
  }
  
  func sizeRangeForSupplementaryElement(ofKind elementKind: String, at index: Int) -> ASSizeRange {
    return .separator
  }
}
