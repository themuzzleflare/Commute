import UIKit
import AsyncDisplayKit
import SwiftDate
import TfNSW

final class StopSequenceVC: ASDKViewController<ASTableNode> {
  weak var delegate: StopSequenceDelegate?

  private let tableNode = ASTableNode(style: .grouped)

  private var stopSequence: [TripRequestResponseJourneyLegStop]

  init(stops: [TripRequestResponseJourneyLegStop]) {
    self.stopSequence = stops
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
    navigationItem.title = "Stops"
  }

  private func configureTableNode() {
    tableNode.dataSource = self
    tableNode.delegate = self
    tableNode.view.showsVerticalScrollIndicator = false
  }
}

extension StopSequenceVC: ASTableDataSource {
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 2
  }

  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return stopSequence.count
    default:
      fatalError("Unknown section")
    }
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let stop = stopSequence[indexPath.row]

    let text: String

    if let parent = stop.parent?.parent?.name {
      text = stop.name?.replacingOccurrences(of: "\(parent), ", with: "") ?? stop.disassembledName ?? ""
    } else {
      text = stop.disassembledName ?? ""
    }

    let stopsMapCellNode = StopsMapCellNode(self, stops: stopSequence)

    return {
      switch indexPath.section {
      case 0:
        return stopsMapCellNode
      case 1:
        return SubtitleCellNode(text: text, detailText: stop.departureTime?.toDate()?.toString(.time(.short)) ?? stop.arrivalTime?.toDate()?.toString(.time(.short)) ?? "")
      default:
        fatalError("Unknown section")
      }
    }
  }
}

extension StopSequenceVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 1:
      tableNode.deselectRow(at: indexPath, animated: true)
      tableNode.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
      delegate?.didSelectStop(stopSequence[indexPath.row])
    default:
      break
    }
  }
}
