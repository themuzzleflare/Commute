import UIKit
import AsyncDisplayKit
import SwiftDate
import TfNSW

final class StopSequenceVC: ASDKViewController<ASTableNode> {
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
    tableNode.view.showsVerticalScrollIndicator = false
  }
}

extension StopSequenceVC: ASTableDataSource {
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return stopSequence.count
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let stop = stopSequence[indexPath.row]

    let text: String

    if let parent = stop.parent?.parent?.name {
      text = stop.name?.replacingOccurrences(of: "\(parent), ", with: "") ?? stop.disassembledName ?? ""
    } else {
      text = stop.disassembledName ?? ""
    }

    return {
      SubtitleCellNode(text: text, detailText: stop.departureTime?.toDate()?.toString(.time(.short)) ?? stop.arrivalTime?.toDate()?.toString(.time(.short)) ?? "")
    }
  }
}
