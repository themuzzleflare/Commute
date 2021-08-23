import UIKit
import AsyncDisplayKit

final class StationDetailVC: ASDKViewController<ASTableNode> {
  private let tableNode = ASTableNode(style: .grouped)

  var station: Station

  init(station: Station) {
    self.station = station
    super.init(node: tableNode)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigation()
    configureTableNode()
  }

  private func configureNavigation() {
    navigationItem.title = station.name
  }

  private func configureTableNode() {
    tableNode.dataSource = self
    tableNode.view.showsVerticalScrollIndicator = false
  }
}

extension StationDetailVC: ASTableDataSource {
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 2
  }

  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 4
    case 1: return 1
    default: fatalError("Unknown section")
    }
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0: return "Details"
    case 1: return "Location"
    default: return nil
    }
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let mapNode = StationMapCellNode(station: station)

    return {
      switch indexPath.section {
      case 0:
        switch indexPath.row {
        case 0:
          return RightDetailCellNode(text: "Name", detailText: self.station.name)
        case 1:
          return RightDetailCellNode(text: "ID", detailText: self.station.globalId)
        case 2:
          return RightDetailCellNode(text: "Stop ID", detailText: self.station.stopId)
        case 3:
          return RightDetailCellNode(text: "Suburb", detailText: self.station.suburb)
        default:
          fatalError("Unknown row")
        }
      case 1:
        return mapNode
      default:
        fatalError("Unknown section")
      }
    }
  }
}
