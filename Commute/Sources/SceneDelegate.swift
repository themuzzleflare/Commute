import UIKit
import Rswift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var savedShortcutItem: UIApplicationShortcutItem!

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    if let shortcutItem = connectionOptions.shortcutItem {
      savedShortcutItem = shortcutItem
    }

    let window = UIWindow(windowScene: windowScene)

    window.tintColor = R.color.accentColor()
    window.rootViewController = TabBarController()
    window.makeKeyAndVisible()

    self.window = window
  }

  func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    completionHandler(handleShortcutItem(shortcutItem: shortcutItem))
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    if savedShortcutItem != nil {
      _ = handleShortcutItem(shortcutItem: savedShortcutItem)
    }
  }

  func sceneWillResignActive(_ scene: UIScene) {
    if savedShortcutItem != nil {
      savedShortcutItem = nil
    }
  }

  private func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
    if let tbc = window?.rootViewController as? TabBarController,
       let actionTypeValue = ShortcutType(rawValue: shortcutItem.type) {
      switch actionTypeValue {
      case .trips: tbc.selectedIndex = 0
      case .stations: tbc.selectedIndex = 1
      case .tools: tbc.selectedIndex = 2
      case .about: tbc.selectedIndex = 3
      }
    }
    return true
  }
}
