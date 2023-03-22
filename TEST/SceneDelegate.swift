//
//  SceneDelegate.swift

//
//    on 19.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?

  private lazy var rootFlow = RootFlow()

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
  
    guard let scene = (scene as? UIWindowScene) else { return }
    
    with(UIWindow(windowScene: scene)) {
      $0.rootViewController = rootFlow.rootViewController
      self.window = $0
      $0.makeKeyAndVisible()
    }
  }

}

