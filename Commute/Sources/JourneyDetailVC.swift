import UIKit
import AsyncDisplayKit
import SwiftDate
import TfNSW

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
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return legs.count
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    return {
      return LegCellNode(legs: self.legs, index: indexPath.row)
    }
  }
}

extension JourneyDetailVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    let leg = legs[indexPath.row]

    tableNode.deselectRow(at: indexPath, animated: true)

    guard let stops = leg.stopSequence else { return }

    navigationController?.pushViewController(StopSequenceVC(stops: stops), animated: true)
  }
}
