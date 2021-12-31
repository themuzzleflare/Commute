import WebKit
import UIKit
import AsyncDisplayKit

final class WKWebNode: ASDisplayNode {
  private let webNodeViewBlock: ASDisplayNodeViewBlock = {
    return WKWebView()
  }

  private var webView: WKWebView {
    return view as! WKWebView
  }

  override init() {
    super.init()
    setViewBlock(webNodeViewBlock)
  }
  
  deinit {
    print("\(#function) \(String(describing: type(of: self)))")
  }
}

extension WKWebNode {
  /// Sets the webpage contents and base URL.
  func loadHTMLString(_ string: String, baseURL: URL?) {
    webView.loadHTMLString(string, baseURL: baseURL)
  }
}
