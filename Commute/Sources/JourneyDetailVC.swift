import UIKit
import AsyncDisplayKit
import SwiftDate

final class JourneyDetailVC: ASDKViewController<ASTableNode> {
  private var legs: [TripRequestResponseJourneyLeg]

  private let tableNode = ASTableNode(style: .grouped)

  init(legs: [TripRequestResponseJourneyLeg]) {
    self.legs = legs
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
    navigationItem.title = "Legs"
  }

  private func configureTableNode() {
    tableNode.dataSource = self
    tableNode.delegate = self
    tableNode.view.showsVerticalScrollIndicator = false
  }
}

extension JourneyDetailVC: ASTableDataSource {
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return legs.count
  }

  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Leg \((section + 1).description)"
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let leg = legs[indexPath.section]

    return {
      switch indexPath.row {
      case 0:
        return RightDetailCellNode(text: "Origin", detailText: leg.origin?.disassembledName ?? "")
      case 1:
        return RightDetailCellNode(text: "Destination", detailText: leg.destination?.disassembledName ?? "")
      case 2:
        return RightDetailCellNode(text: "Duration", detailText: secondsToHoursMinutesSecondsStr(seconds: leg.duration!))
      case 3:
        let node = RightDetailCellNode(text: "Stop Sequence", detailText: leg.stopSequence?.count.description ?? "")
        node.selectionStyle = .default
        node.accessoryType = .disclosureIndicator
        return node
      default:
        fatalError("Unknown row")
      }
    }
  }
}

extension JourneyDetailVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    let leg = legs[indexPath.section]

    tableNode.deselectRow(at: indexPath, animated: true)

    guard let stops = leg.stopSequence else { return }

    switch indexPath.row {
    case 3:
      navigationController?.pushViewController(StopSequenceVC(stops: stops), animated: true)
    default: break
    }
  }
}
