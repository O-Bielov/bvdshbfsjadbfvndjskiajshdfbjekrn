//
//  HeightCalculating.swift

//
//    on 18.06.2021.
//

import UIKit

protocol HeightCalculating {
  
  func height(atWidth width: CGFloat) -> CGFloat
  
}

extension HeightCalculating where Self: UIView {
  
  func height(atWidth width: CGFloat) -> CGFloat {
    let size = systemLayoutSizeFitting(.init(width: width, height: .zero), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)

    return size.height
  }
  
}
