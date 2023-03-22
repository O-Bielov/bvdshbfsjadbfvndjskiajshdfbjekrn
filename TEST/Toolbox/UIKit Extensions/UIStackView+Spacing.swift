//
//  UIStackView+Spacing.swift

//
//    on 12.02.2021.
//

import UIKit

extension UIStackView {
  
  func setSpacingAfterLastAddedView(_ spacing: CGFloat) {
    arrangedSubviews.last.map {
      setCustomSpacing(spacing, after: $0)
    }
  }
  
}
