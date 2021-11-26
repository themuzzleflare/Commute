import UIKit
import AsyncDisplayKit
import TfNSW

final class LegInfoVC: ASViewController {
  private let tableNode = ASTableNode(style: .insetGrouped)
  
  private var infos: [TripRequestResponseJourneyLegStopInfo]
  
  init(infos: [TripRequestResponseJourneyLegStopInfo]) {
    self.infos = infos
    super.init(node: tableNode)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigation()
    configureTableNode()
  }
  
  private func configureTableNode() {
    tableNode.dataSource = self
    tableNode.delegate = self
  }
  
  private func configureNavigation() {
    navigationItem.title = "Leg Info"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
  }
  
  @objc private func close() {
    navigationController?.dismiss(animated: true)
  }
}

extension LegInfoVC: ASTableDataSource {
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return infos.count
  }
  
  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let info = infos[indexPath.row]
    return {
      SubtitleCellNode(text: info.subtitle ?? "", detailText: "")
    }
  }
}

extension LegInfoVC: ASTableDelegate {
  
}
