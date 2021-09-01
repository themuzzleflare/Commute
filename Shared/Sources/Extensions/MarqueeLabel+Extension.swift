import Foundation
import MarqueeLabel

extension MarqueeLabel {
  static func textLabel(for string: String) -> MarqueeLabel {
    let label = MarqueeLabel()
    label.speed = .duration(8.0)
    label.fadeLength = 10.0
    label.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
    label.text = string
    return label
  }
}
