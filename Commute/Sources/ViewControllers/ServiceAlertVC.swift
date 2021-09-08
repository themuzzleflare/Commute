import WebKit
import UIKit
import MarqueeLabel

final class ServiceAlertVC: ASViewController {
  private var alert: TransitRealtime_Alert
  private let webNode = WKWebNode()

  init(alert: TransitRealtime_Alert) {
    self.alert = alert
    super.init(node: webNode)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigation()
    configureWebNode()
  }

  private func configureNavigation() {
    navigationItem.titleView = MarqueeLabel.navigationTitle(text: alert.headerText.translation[0].text)
    navigationItem.title = alert.headerText.translation[0].text
  }

  private func configureWebNode() {
    webNode.loadHTMLString(alert.descriptionText.translation[1].text, baseURL: nil)
  }
}
