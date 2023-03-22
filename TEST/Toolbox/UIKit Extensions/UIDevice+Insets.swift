//
//  UIDevice+Insets.swift

//
//    on 18.12.2020.
//

import UIKit

extension UIDevice {
  
  static var safeAreaInsets: UIEdgeInsets {
    UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
  }
  
  static var hasSafeArea: Bool {
    safeAreaInsets.bottom != .zero
  }
  
  static var isShort: Bool {
    UIScreen.main.bounds.height < 700.0
  }
  
}
