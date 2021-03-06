import SwiftDate
import TfNSW
import UIKit
import AsyncDisplayKit

final class StopSequenceVC: ASViewController {
  weak var delegate: StopSequenceDelegate?
  
  private let tableNode = ASTableNode(style: .grouped)
  
  private var leg: TripRequestResponseJourneyLeg
  private var stopSequence: [TripRequestResponseJourneyLegStop]
  private var infos: [TripRequestResponseJourneyLegStopInfo]?
  
  init(leg: TripRequestResponseJourneyLeg, stops: [TripRequestResponseJourneyLegStop], infos: [TripRequestResponseJourneyLegStopInfo]? = nil) {
    self.leg = leg
    self.stopSequence = stops
    self.infos = infos
    super.init(node: tableNode)
  }
  
  deinit {
    print("\(#function) \(String(describing: type(of: self)))")
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
    if infos != nil {
      navigationItem.rightBarButtonItem = UIBarButtonItem(image: .infoCircle, style: .plain, target: self, action: #selector(openInfo))
    }
  }
  
  @objc private func openInfo() {
    if let infos = infos {
      let viewController = NavigationController(rootViewController: LegInfoVC(infos: infos))
      present(viewController, animated: true)
    }
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
    
    let subtitleCellNode = SubtitleCellNode(text: text, detailText: stop.departureTime?.toDate()?.toString(.time(.short)) ?? stop.arrivalTime?.toDate()?.toString(.time(.short)) ?? "")
    let stopsMapCellNode = StopsMapCellNode(self, stops: stopSequence, colour: leg.colour ?? .accentColor)
    
    return {
      switch indexPath.section {
      case 0:
        return stopsMapCellNode
      case 1:
        return subtitleCellNode
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
