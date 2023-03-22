//
//  ViewStylePrimitives.swift

//
//    on 21.03.2021.
//

import UIKit

struct UIStyle {

  static func roundCorners<T: UIView>(_ r: CGFloat) -> ViewStyle<T> {
    .init {
      with($0.layer) {
        $0.cornerRadius = r
        $0.cornerCurve = .continuous
        $0.masksToBounds = true
      }
    }
  }
  
}
