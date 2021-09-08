import Foundation
import MarqueeLabel

extension MarqueeLabel {
  /// A `MarqueeLabel` with a `duration` of 8.0 and a `fadeLength` of 10.0.
  static func navigationTitle(text: String) -> MarqueeLabel {
    let label = MarqueeLabel()
    label.speed = .duration(8.0)
    label.fadeLength = 10.0
    label.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
    label.text = text
    return label
  }
}
