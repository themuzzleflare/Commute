import UIKit
import WebKit
import MarqueeLabel

final class ServiceAlertVC: ASViewController {
  private var alert: TransitRealtime_Alert
  private let webView = WKWebView(frame: .zero)

  init(alert: TransitRealtime_Alert) {
    self.alert = alert
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(webView)
    configureNavigation()
    configureWebView()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    webView.frame = view.bounds
  }

  private func configureNavigation() {
    navigationItem.titleView = MarqueeLabel.textLabel(for: alert.headerText.translation[0].text)
    navigationItem.title = alert.headerText.translation[0].text
  }

  private func configureWebView() {
    webView.loadHTMLString(alert.descriptionText.translation[1].text, baseURL: nil)
  }
}
