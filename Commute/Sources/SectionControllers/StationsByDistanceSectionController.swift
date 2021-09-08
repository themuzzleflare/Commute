import Foundation
import CoreData
import CoreLocation
import IGListKit
import AsyncDisplayKit

final class StationsByDistanceSectionController: ListSectionController {
  private var object: Station!
  private var addTripType: AddTripType
  private var fromStation: Station?
  private var relativeLocation: CLLocation

  init(addTripType: AddTripType, fromStation: Station? = nil, relativeLocation: CLLocation) {
    self.addTripType = addTripType
    self.fromStation = fromStation
    self.relativeLocation = relativeLocation
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
    self.object = object as? Station
  }

  override func didSelectItem(at index: Int) {
    collectionContext?.nodeForItem(at: index, sectionController: self)?.select()
    collectionContext?.nodeForItem(at: index, sectionController: self)?.deselect()

    switch addTripType {
    case .origin:
      viewController?.navigationItem.backButtonTitle = object.shortName
      viewController?.navigationController?.pushViewController(AddTripVC(type: .destination, station: object), animated: true)
    case .destination:
      configureCoreData(toStation: object)
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

extension StationsByDistanceSectionController: ASSectionController {
  func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
    return {
      StationByDistanceCellNode(station: self.object, relativeLocation: self.relativeLocation)
    }
  }

  func sizeRangeForItem(at index: Int) -> ASSizeRange {
    return .cellNode(minHeight: 55, maxHeight: 65)
  }
}

extension StationsByDistanceSectionController: ListSupplementaryViewSource {
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

extension StationsByDistanceSectionController: ASSupplementaryNodeSource {
  func nodeBlockForSupplementaryElement(ofKind elementKind: String, at index: Int) -> ASCellNodeBlock {
    return {
      SeparatorCellNode()
    }
  }

  func sizeRangeForSupplementaryElement(ofKind elementKind: String, at index: Int) -> ASSizeRange {
    return .separator
  }
}
