import UIKit
import WebKit
import MarqueeLabel

final class ServiceAlertVC: UIViewController {
  private var alert: TransitRealtime_Alert
  private let webView = WKWebView(frame: .zero)

  init(alert: TransitRealtime_Alert) {
    self.alert = alert
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    let label = MarqueeLabel(frame: navigationController!.navigationBar.bounds, duration: 8.0, fadeLength: 10.0)
    label.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
    label.text = alert.headerText.translation[0].text
    navigationItem.titleView = label
    navigationItem.title = alert.headerText.translation[0].text
  }

  private func configureWebView() {
    webView.loadHTMLString(alert.descriptionText.translation[1].text, baseURL: nil)
  }
}
