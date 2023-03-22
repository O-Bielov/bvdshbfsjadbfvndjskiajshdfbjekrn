//
//  RootViewController.swift

//
//    on 19.10.2021.
//

import UIKit

final class RootViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func switchTo(_ viewController: UIViewController) {
    let shouldAnimate = !self.children.isEmpty
    
    view.animatedTransition(duration: shouldAnimate ? 0.15 : .zero) {
      if let currentController = self.children.first {
        currentController.willMove(toParent: nil)
        currentController.view.removeFromSuperview()
        currentController.removeFromParent()
      }
      
      self.addChild(viewController)
      self.view.addSubview(viewController.view)
      viewController.didMove(toParent: self)
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
  }
  
}
