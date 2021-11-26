import TfNSW
import UIKit
import AsyncDisplayKit

final class JourneyDetailVC: ASViewController {
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
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return legs.count
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let cellNode = LegCellNode(legs: legs, index: indexPath.row)

    return {
      cellNode
    }
  }
}

extension JourneyDetailVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    let leg = legs[indexPath.row]

    tableNode.deselectRow(at: indexPath, animated: true)

    if let stops = leg.stopSequence {
      navigationController?.pushViewController(StopSequenceVC(stops: stops, infos: leg.infos), animated: true)
    }
  }
}
