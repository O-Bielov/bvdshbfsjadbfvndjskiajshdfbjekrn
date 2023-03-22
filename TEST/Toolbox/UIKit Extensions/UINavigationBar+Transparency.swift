//
//  UINavigationBar+Transparency.swift

//
//    on 01.06.2021.
//

import UIKit

extension UINavigationBar {
  
  func makeTransparent() {
    setColor(.clear)
    isTranslucent = true
    setBackgroundImage(UIImage(), for: .default)
  }

  func setColor(_ color: UIColor) {
    shadowImage = UIImage()
    isTranslucent = true
    backgroundColor = color
    barTintColor = color
    
    flatten(self, get(\.subviews))
      .forEach { $0.backgroundColor = .clear }
  }
  
}
