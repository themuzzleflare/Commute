import UIKit
import AsyncDisplayKit
import MapboxMaps

final class MapboxMapNode: ASDisplayNode {
  private let mapboxViewBlock: ASDisplayNodeViewBlock = {
    let styleUri = StyleURI(rawValue: "mapbox://styles/themuzzleflare/cksoh1z262udz17o93pl4q4vj")
    let mapOptions = MapInitOptions(styleURI: styleUri)
    return MapView(frame: .zero, mapInitOptions: mapOptions)
  }

  var rootView: MapView {
    return view as! MapView
  }

  override init() {
    super.init()
    setViewBlock(mapboxViewBlock)
  }
  
  deinit {
    print(#function)
  }
}
