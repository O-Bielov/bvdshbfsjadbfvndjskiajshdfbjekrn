//
//  UIViewController+BackButton.swift

//
//    on 27.10.2021.
//

import UIKit

extension UIViewController {
  
  func addPinkBackButton() {
    let button = with(UIButton()) {
      $0.backgroundColor = .palePink
      $0.setImage(.init(named: "navigation.back"), for: .normal)
      $0.layer.cornerRadius = 22.0
      $0.layer.masksToBounds = true
      $0 |> UIStyle.splashEffect
      $0.addTouchAction { [weak self] in
        self?.navigationController?.pop()
      }
    }.constrainWidth(to: 44.0)
      .constrainHeight(to: 44.0)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
  }
  
}
